from flask import Flask, render_template, request, redirect, url_for, session, flash, make_response
import mysql.connector
from functools import wraps
import hashlib
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas
from io import BytesIO
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your_secret_key_here'  # Change this to a secure secret key

# Database configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'training_program2'
}

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_pin' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# Helper function to get employees based on user role
def get_accessible_employees(exclude_self=False):
    """Get list of employees accessible to current user based on their role"""
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    user_role = session.get('user_role', '').lower()
    user_pin = session.get('user_pin')
    
    if user_role == 'director':
        # Directors can see all employees in their project/establishment
        if exclude_self:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE Project = %s AND PIN != %s 
                ORDER BY EMPNAME
            ''', (session.get('user_project'), user_pin))
        else:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE Project = %s 
                ORDER BY EMPNAME
            ''', (session.get('user_project'),))
    elif user_role in ['head', 'manager', 'manager/head', 'head/manager']:
        # Heads/Managers can see all employees in their division
        if exclude_self:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE DIVISION = %s AND PIN != %s 
                ORDER BY EMPNAME
            ''', (session.get('user_division'), user_pin))
        else:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE DIVISION = %s 
                ORDER BY EMPNAME
            ''', (session.get('user_division'),))
    elif user_role == 'section head':
        # Section heads can see all employees in their section
        if exclude_self:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE SECTION = %s AND PIN != %s 
                ORDER BY EMPNAME
            ''', (session.get('user_section'), user_pin))
        else:
            cursor.execute('''
                SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
                FROM cat_employee 
                WHERE SECTION = %s 
                ORDER BY EMPNAME
            ''', (session.get('user_section'),))
    else:
        # Employees can only see themselves
        cursor.execute('''
            SELECT PIN, EMPNAME, DESIG, JOBPOSITION, DIVISION, SECTION, Role 
            FROM cat_employee 
            WHERE PIN = %s
        ''', (user_pin,))
    
    employees = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return employees

# Helper function to get employee data for a specific PIN
def get_employee_training_data(pin):
    """Get comprehensive training data for a specific employee"""
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Personal Information
    cursor.execute('SELECT * FROM cat_employee WHERE PIN = %s', (pin,))
    personal_info = cursor.fetchone()
    
    if not personal_info:
        cursor.close()
        conn.close()
        return None
    
    # Job position details
    cursor.execute('SELECT * FROM cat_jobposition WHERE JobPosition = %s', (personal_info['JOBPOSITION'],))
    job_details = cursor.fetchone() or {}
    
    # Job areas
    cursor.execute('''
        SELECT ja.JobArea 
        FROM x_jobposition_jobarea xja
        JOIN cat_jobarea ja ON xja.JobAreaCode = ja.JobAreaCode
        WHERE xja.JobPosition = %s
    ''', (personal_info['JOBPOSITION'],))
    job_areas = cursor.fetchall()
    
    # General tasks
    cursor.execute('''
        SELECT DISTINCT jgt.JobGTask as task_description
        FROM cat_jobgtask jgt
        JOIN x_jobposition_jobgtask xjg ON jgt.JobGTaskCode = xjg.JobGTaskCode
        WHERE xjg.JobPosition = %s
    ''', (personal_info['JOBPOSITION'],))
    general_tasks = cursor.fetchall()
    
    # Technical tasks
    cursor.execute('''
        SELECT DISTINCT jtt.JobTTask as task_description
        FROM cat_jobttask jtt
        JOIN x_jobposition_jobttask xjt ON jtt.JobTTaskCode = xjt.JobTTask
        WHERE xjt.JobPosition = %s
    ''', (personal_info['JOBPOSITION'],))
    technical_tasks = cursor.fetchall()
    
    # Required trainings
    cursor.execute('''
        SELECT * FROM training_required_by_jobposition 
        WHERE JobPosition = %s
    ''', (personal_info['JOBPOSITION'],))
    required_trainings = cursor.fetchall()
    
    # Acquired trainings
    cursor.execute('''
        SELECT eta.EMPNAME, eta.PIN, eta.JobPosition, 
               COALESCE(cat.TrgDesc, eta.Acquired_Training) as Acquired_Training_Desc
        FROM employee_trainings_acquired eta
        LEFT JOIN cat_alltrainings cat ON eta.Acquired_Training = cat.TrgCode
        WHERE eta.PIN = %s
    ''', (pin,))
    acquired_trainings = cursor.fetchall()
    
    # Missing trainings
    cursor.execute('''
        SELECT emt.EMPNAME, emt.PIN, 
               COALESCE(cat.TrgDesc, emt.Missing_Training) as Missing_Training_Desc
        FROM employee_missing_trainings emt
        LEFT JOIN cat_alltrainings cat ON emt.Missing_Training = cat.TrgCode
        WHERE emt.PIN = %s
    ''', (pin,))
    missing_trainings = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return {
        'personal_info': personal_info,
        'job_details': job_details,
        'job_areas': job_areas,
        'general_tasks': general_tasks,
        'technical_tasks': technical_tasks,
        'required_trainings': required_trainings,
        'acquired_trainings': acquired_trainings,
        'missing_trainings': missing_trainings
    }

@app.route('/')
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        pin = request.form['pin']
        password = request.form['password']
        
        # Hash the password using SHA-256
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        # Updated query to fetch EMPNAME, Role, and hierarchical info from cat_employee
        cursor.execute('''
            SELECT u.*, e.EMPNAME, e.Role, e.DIVISION, e.SECTION, e.Project 
            FROM users u 
            JOIN cat_employee e ON u.PIN = e.PIN 
            WHERE u.PIN = %s AND u.Password = %s
        ''', (pin, hashed_password))
        user = cursor.fetchone()
        
        cursor.close()
        conn.close()
        
        if user:
            session['user_pin'] = pin
            session['user_name'] = user['EMPNAME']
            session['user_role'] = user['Role']
            session['user_division'] = user['DIVISION']
            session['user_section'] = user['SECTION']
            session['user_project'] = user['Project']
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid PIN or Password', 'error')
    
    return render_template('login.html')

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html')

@app.route('/team_management')
@login_required
def team_management():
    """Role-based team management dashboard"""
    user_role = session.get('user_role', '').lower()
    
    # Only allow access to non-employee roles (including all manager/head variations)
    if user_role in ['employee', '']:
        flash('Access denied. This feature is for managers only.', 'error')
        return redirect(url_for('dashboard'))
    
    employees = get_accessible_employees(exclude_self=True)
    
    return render_template('team_management.html', 
                         employees=employees,
                         user_role=user_role.title())

@app.route('/employee_details/<int:pin>')
@login_required
def employee_details(pin):
    """View detailed training information for a specific employee"""
    user_role = session.get('user_role', '').lower()
    
    # Check if user has permission to view this employee
    accessible_employees = get_accessible_employees()
    accessible_pins = [emp['PIN'] for emp in accessible_employees]
    
    if pin not in accessible_pins:
        flash('Access denied. You do not have permission to view this employee.', 'error')
        return redirect(url_for('dashboard'))
    
    employee_data = get_employee_training_data(pin)
    
    if not employee_data:
        flash('Employee not found.', 'error')
        return redirect(url_for('team_management'))
    
    return render_template('employee_details.html', **employee_data)

@app.route('/view_missing_trainings')
@app.route('/view_missing_trainings/<int:pin>')
@login_required
def view_missing_trainings(pin=None):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Use provided PIN or default to current user
    target_pin = pin if pin else session['user_pin']
    
    # Check access permissions
    if pin and pin != session['user_pin']:
        accessible_employees = get_accessible_employees()
        accessible_pins = [emp['PIN'] for emp in accessible_employees]
        
        if pin not in accessible_pins:
            flash('Access denied.', 'error')
            cursor.close()
            conn.close()
            return redirect(url_for('dashboard'))
    
    cursor.execute('SELECT * FROM employee_missing_trainings WHERE PIN = %s', (target_pin,))
    trainings = cursor.fetchall()
    
    # Get employee name for display
    cursor.execute('SELECT EMPNAME FROM cat_employee WHERE PIN = %s', (target_pin,))
    employee = cursor.fetchone()
    employee_name = employee['EMPNAME'] if employee else 'Unknown'
    
    cursor.close()
    conn.close()
    
    return render_template('missing_trainings.html', 
                         trainings=trainings,
                         employee_name=employee_name,
                         is_viewing_other=(pin is not None and pin != session['user_pin']))

@app.route('/view_acquired_trainings')
@app.route('/view_acquired_trainings/<int:pin>')
@login_required
def view_acquired_trainings(pin=None):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Use provided PIN or default to current user
    target_pin = pin if pin else session['user_pin']
    
    # Check access permissions
    if pin and pin != session['user_pin']:
        accessible_employees = get_accessible_employees()
        accessible_pins = [emp['PIN'] for emp in accessible_employees]
        
        if pin not in accessible_pins:
            flash('Access denied.', 'error')
            cursor.close()
            conn.close()
            return redirect(url_for('dashboard'))
    
    cursor.execute('SELECT * FROM employee_trainings_acquired WHERE PIN = %s', (target_pin,))
    trainings = cursor.fetchall()
    
    # Get employee name for display
    cursor.execute('SELECT EMPNAME FROM cat_employee WHERE PIN = %s', (target_pin,))
    employee = cursor.fetchone()
    employee_name = employee['EMPNAME'] if employee else 'Unknown'
    
    cursor.close()
    conn.close()
    
    return render_template('acquired_trainings.html', 
                         trainings=trainings,
                         employee_name=employee_name,
                         is_viewing_other=(pin is not None and pin != session['user_pin']))

@app.route('/view_job_trainings')
@app.route('/view_job_trainings/<int:pin>')
@login_required
def view_job_trainings(pin=None):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Use provided PIN or default to current user
    target_pin = pin if pin else session['user_pin']
    
    # Check access permissions
    if pin and pin != session['user_pin']:
        accessible_employees = get_accessible_employees()
        accessible_pins = [emp['PIN'] for emp in accessible_employees]
        
        if pin not in accessible_pins:
            flash('Access denied.', 'error')
            cursor.close()
            conn.close()
            return redirect(url_for('dashboard'))
    
    # Get the target user's job position
    cursor.execute('SELECT JOBPOSITION, EMPNAME FROM cat_employee WHERE PIN = %s', (target_pin,))
    user_info = cursor.fetchone()
    
    if user_info:
        cursor.execute('SELECT * FROM training_required_by_jobposition WHERE JobPosition = %s', (user_info['JOBPOSITION'],))
        trainings = cursor.fetchall()
        employee_name = user_info['EMPNAME']
    else:
        trainings = []
        employee_name = 'Unknown'
    
    cursor.close()
    conn.close()
    
    return render_template('job_trainings.html', 
                         trainings=trainings,
                         employee_name=employee_name,
                         is_viewing_other=(pin is not None and pin != session['user_pin']))

@app.route('/view_all_trainings')
@login_required
def view_all_trainings():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute('SELECT * FROM cat_alltrainings')
    trainings = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('all_trainings.html', trainings=trainings)

@app.route('/view_job_gtask')
@login_required
def view_job_gtask():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Get the user's job position
    cursor.execute('SELECT JOBPOSITION FROM cat_employee WHERE PIN = %s', (session['user_pin'],))
    user_job = cursor.fetchone()
    
    if user_job:
        # Get general tasks
        cursor.execute('''
            SELECT 
                jp.JobPosition,
                xjg.JobGTaskCode as General_Task,
                jgt.JobGTask as General_Task_Desc,
                xjt.JobTTask as Technical_Task,
                jtt.JobTTask as Technical_Task_Desc
            FROM cat_jobposition jp
            LEFT JOIN x_jobposition_jobgtask xjg ON jp.JobPosition = xjg.JobPosition
            LEFT JOIN cat_jobgtask jgt ON xjg.JobGTaskCode = jgt.JobGTaskCode
            LEFT JOIN x_jobposition_jobttask xjt ON jp.JobPosition = xjt.JobPosition
            LEFT JOIN cat_jobttask jtt ON xjt.JobTTask = jtt.JobTTaskCode
            WHERE jp.JobPosition = %s
        ''', (user_job['JOBPOSITION'],))
        tasks = cursor.fetchall()
    else:
        tasks = []
    
    cursor.close()
    conn.close()
    
    return render_template('job_gtask.html', tasks=tasks)

@app.route('/user_profile')
@login_required
def user_profile():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Personal Information from cat_employee
    cursor.execute('SELECT * FROM cat_employee WHERE PIN = %s', (session['user_pin'],))
    personal_info = cursor.fetchone()
    
    # Initialize empty lists
    job_area = []
    general_tasks = []
    technical_tasks = []
    required_trainings = []
    acquired_trainings = []
    missing_trainings = []
    
    if personal_info:
        # Job Area from x_jobposition_jobarea joined with cat_jobarea
        cursor.execute('''
            SELECT ja.JobArea 
            FROM x_jobposition_jobarea xja
            JOIN cat_jobarea ja ON xja.JobAreaCode = ja.JobAreaCode
            WHERE xja.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        job_area = cursor.fetchall()
        
        # Job General Tasks - descriptions only
        cursor.execute('''
            SELECT DISTINCT jgt.JobGTask as task_description
            FROM cat_jobgtask jgt
            JOIN x_jobposition_jobgtask xjg ON jgt.JobGTaskCode = xjg.JobGTaskCode
            WHERE xjg.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        general_tasks = cursor.fetchall()
        
        # Job Technical Tasks - descriptions only
        cursor.execute('''
            SELECT DISTINCT jtt.JobTTask as task_description
            FROM cat_jobttask jtt
            JOIN x_jobposition_jobttask xjt ON jtt.JobTTaskCode = xjt.JobTTask
            WHERE xjt.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        technical_tasks = cursor.fetchall()
        
        # Training Required for Job Position (using the view)
        cursor.execute('''
            SELECT * FROM training_required_by_jobposition 
            WHERE JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        required_trainings = cursor.fetchall()
    
    # Employee's Acquired Trainings (using the view with training descriptions)
    cursor.execute('''
        SELECT eta.EMPNAME, eta.PIN, eta.JobPosition, 
               COALESCE(cat.TrgDesc, eta.Acquired_Training) as Acquired_Training_Desc
        FROM employee_trainings_acquired eta
        LEFT JOIN cat_alltrainings cat ON eta.Acquired_Training = cat.TrgCode
        WHERE eta.PIN = %s
    ''', (session['user_pin'],))
    acquired_trainings = cursor.fetchall()
    
    # Training Gap (Missing Trainings) (using the view with training descriptions)
    cursor.execute('''
        SELECT emt.EMPNAME, emt.PIN, 
               COALESCE(cat.TrgDesc, emt.Missing_Training) as Missing_Training_Desc
        FROM employee_missing_trainings emt
        LEFT JOIN cat_alltrainings cat ON emt.Missing_Training = cat.TrgCode
        WHERE emt.PIN = %s
    ''', (session['user_pin'],))
    missing_trainings = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('user_profile.html', 
                         personal_info=personal_info,
                         job_area=job_area,
                         general_tasks=general_tasks,
                         technical_tasks=technical_tasks,
                         required_trainings=required_trainings,
                         acquired_trainings=acquired_trainings,
                         missing_trainings=missing_trainings)

@app.route('/generate_jac_pdf')
@login_required
def generate_jac_pdf():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)

    # Get all user data
    cursor.execute('SELECT * FROM cat_employee WHERE PIN = %s', (session['user_pin'],))
    personal_info = cursor.fetchone()

    # Get job position details
    job_details = {}
    job_areas = []
    general_tasks = []
    technical_tasks = []
    required_trainings = []
    acquired_trainings = []
    missing_trainings = []

    if personal_info:
        cursor.execute('SELECT * FROM cat_jobposition WHERE JobPosition = %s', (personal_info['JOBPOSITION'],))
        job_details = cursor.fetchone() or {}

        # Get job areas
        cursor.execute('''
            SELECT ja.JobArea 
            FROM x_jobposition_jobarea xja
            JOIN cat_jobarea ja ON xja.JobAreaCode = ja.JobAreaCode
            WHERE xja.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        job_areas = cursor.fetchall()

        # Get general tasks
        cursor.execute('''
            SELECT DISTINCT jgt.JobGTask as task_description
            FROM cat_jobgtask jgt
            JOIN x_jobposition_jobgtask xjg ON jgt.JobGTaskCode = xjg.JobGTaskCode
            WHERE xjg.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        general_tasks = cursor.fetchall()

        # Get technical tasks
        cursor.execute('''
            SELECT DISTINCT jtt.JobTTask as task_description
            FROM cat_jobttask jtt
            JOIN x_jobposition_jobttask xjt ON jtt.JobTTaskCode = xjt.JobTTask
            WHERE xjt.JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        technical_tasks = cursor.fetchall()

        # Get required trainings
        cursor.execute('''
            SELECT * FROM training_required_by_jobposition 
            WHERE JobPosition = %s
        ''', (personal_info['JOBPOSITION'],))
        required_trainings = cursor.fetchall()

    # Acquired trainings
    cursor.execute('''
        SELECT eta.EMPNAME, eta.PIN, eta.JobPosition, 
               COALESCE(cat.TrgDesc, eta.Acquired_Training) as Acquired_Training_Desc
        FROM employee_trainings_acquired eta
        LEFT JOIN cat_alltrainings cat ON eta.Acquired_Training = cat.TrgCode
        WHERE eta.PIN = %s
    ''', (session['user_pin'],))
    acquired_trainings = cursor.fetchall()

    # Missing trainings
    cursor.execute('''
        SELECT emt.EMPNAME, emt.PIN, 
               COALESCE(cat.TrgDesc, emt.Missing_Training) as Missing_Training_Desc
        FROM employee_missing_trainings emt
        LEFT JOIN cat_alltrainings cat ON emt.Missing_Training = cat.TrgCode
        WHERE emt.PIN = %s
    ''', (session['user_pin'],))
    missing_trainings = cursor.fetchall()

    cursor.close()
    conn.close()

    from io import BytesIO
    from reportlab.lib.pagesizes import A4
    from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak, Table, TableStyle
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.lib import colors
    from flask import send_file

    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4, rightMargin=40, leftMargin=40, topMargin=30, bottomMargin=30)
    styles = getSampleStyleSheet()
    normal = styles['Normal']
    bold = ParagraphStyle('Bold', parent=normal, fontName='Helvetica-Bold')
    title_style = ParagraphStyle('Title', parent=styles['Title'], fontSize=18, fontName='Helvetica-Bold', 
                                alignment=1, spaceAfter=20, letterSpacing=2)
    section_title_style = ParagraphStyle('SectionTitle', parent=normal, fontSize=11, fontName='Helvetica-Bold', 
                                       textColor=colors.black, alignment=1, spaceAfter=6, spaceBefore=6,
                                       backColor=colors.Color(224/255, 224/255, 224/255))
    
    elements = []

    # Title and Header with employee name
    employee_name = personal_info.get('EMPNAME', 'Unknown Employee') if personal_info else 'Unknown Employee'
    elements.append(Paragraph(f"JOB ANALYSIS CARD: {employee_name}", title_style))
    elements.append(Spacer(1, 10))

    # SECTION 1: EMPLOYEE INFORMATION (Combined with Qualifications)
    # Combined employee and qualification data with header as first row
    employee_data = [
        [Paragraph("<b>EMPLOYEE INFORMATION</b>", bold), "", "", ""],
        [Paragraph("<b>Name:</b>", normal), personal_info.get('EMPNAME', 'N/A'), 
         Paragraph("<b>PIN:</b>", normal), personal_info.get('PIN', 'N/A')],
        [Paragraph("<b>PNO:</b>", normal), personal_info.get('PNO', 'N/A'), 
         Paragraph("<b>Project:</b>", normal), personal_info.get('Project', 'N/A')],
        [Paragraph("<b>Designation:</b>", normal), personal_info.get('DESIG', 'N/A'), 
         Paragraph("<b>Job Position:</b>", normal), personal_info.get('JOBPOSITION', 'N/A')],
        [Paragraph("<b>Division:</b>", normal), personal_info.get('DIVISION', 'N/A'), 
         Paragraph("<b>Section:</b>", normal), personal_info.get('SECTION', 'N/A')],
        [Paragraph("<b>Education Achieved:</b>", normal), personal_info.get('EDUCATION', 'N/A'), 
         Paragraph("<b>Education Required:</b>", normal), job_details.get('JobPos_EduReq', 'N/A')],
        [Paragraph("<b>Experience Achieved:</b>", normal), f"{personal_info.get('EXPERIENCE', 'N/A')} years", 
         Paragraph("<b>Experience Required:</b>", normal), f"{job_details.get('JobPos_ExpReq', 'N/A')} years"]
    ]
    
    employee_table = Table(employee_data, colWidths=[125, 125, 125, 125], rowHeights=[25, 20, 20, 20, 20, 20, 20])
    employee_table.setStyle(TableStyle([
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('LEFTPADDING', (0, 0), (-1, -1), 7),
        ('RIGHTPADDING', (0, 0), (-1, -1), 7),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        # Header row styling
        ('SPAN', (0, 0), (3, 0)),  # Merge header across all columns
        ('FONTNAME', (0, 0), (3, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (3, 0), 11),
        ('ALIGN', (0, 0), (3, 0), 'LEFT'),
        ('LEFTPADDING', (0, 0), (3, 0), 12),
    ]))
    elements.append(employee_table)

    # SECTION 2: JOB PURPOSE
    purpose_text = job_details.get('JobPos_Purpose', 'N/A')
    if purpose_text != 'N/A':
        purpose_text = f"• {purpose_text}"
    
    purpose_data = [
        [Paragraph("<b>JOB PURPOSE</b>", bold)],
        [Paragraph(purpose_text, normal)]
    ]
    
    purpose_table = Table(purpose_data, colWidths=[500], rowHeights=[25, 60])
    purpose_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('ALIGN', (0, 0), (-1, 0), 'LEFT'),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (-1, 0), 0, colors.white),
    ]))
    elements.append(purpose_table)

    # SECTION 3: TOOLS, SKILLS & SOFTWARE
    tools_text = job_details.get('JobPos_Tools_Software', 'N/A')
    if tools_text != 'N/A':
        tools_text = f"• {tools_text}"
    
    tools_data = [
        [Paragraph("<b>JOB RELATED TOOLS, SKILLS & SOFTWARE</b>", bold)],
        [Paragraph(tools_text, normal)]
    ]
    
    tools_table = Table(tools_data, colWidths=[500], rowHeights=[25, 60])
    tools_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('ALIGN', (0, 0), (-1, 0), 'LEFT'),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (-1, 0), 0, colors.white),
    ]))
    elements.append(tools_table)

    # SECTION 4: JOB DUTY/FUNCTIONAL AREAS
    if job_areas:
        areas_text = "<br/>".join([f"• {area['JobArea']}" for area in job_areas])
    else:
        areas_text = "• N/A"
    
    areas_data = [
        [Paragraph("<b>JOB DUTY/FUNCTIONAL AREAS</b>", bold)],
        [Paragraph(areas_text, normal)]
    ]
    
    areas_table = Table(areas_data, colWidths=[500], rowHeights=[25, 80])
    areas_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('ALIGN', (0, 0), (-1, 0), 'LEFT'),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (-1, 0), 0, colors.white),
    ]))
    elements.append(areas_table)

    # SECTION 5: JOB GENERAL TASKS
    if general_tasks:
        gen_tasks_text = "<br/>".join([f"• {task['task_description']}" for task in general_tasks])
    else:
        gen_tasks_text = "N/A"
    
    gen_data = [
        [Paragraph("<b>JOB GENERAL TASKS</b>", bold)],
        [Paragraph(gen_tasks_text, normal)]
    ]
    
    gen_tasks_table = Table(gen_data, colWidths=[500], rowHeights=[25, 80])
    gen_tasks_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('ALIGN', (0, 0), (-1, 0), 'LEFT'),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (-1, 0), 0, colors.white),
    ]))
    elements.append(gen_tasks_table)

    # SECTION 6: JOB TECHNICAL TASKS
    if technical_tasks:
        tech_tasks_text = "<br/>".join([f"• {task['task_description']}" for task in technical_tasks])
    else:
        tech_tasks_text = "N/A"
    
    tech_data = [
        [Paragraph("<b>JOB TECHNICAL TASKS</b>", bold)],
        [Paragraph(tech_tasks_text, normal)]
    ]
    
    tech_tasks_table = Table(tech_data, colWidths=[500], rowHeights=[25, 80])
    tech_tasks_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 11),
        ('ALIGN', (0, 0), (-1, 0), 'LEFT'),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (-1, 0), 0, colors.white),
    ]))
    elements.append(tech_tasks_table)
    
    # Add page break after Job Technical Tasks for balanced pagination
    elements.append(PageBreak())

    # SECTION 7: TRAININGS REQUIRED
    # Required trainings content - split into 2 columns
    if required_trainings:
        # Split trainings into two columns
        half = (len(required_trainings) + 1) // 2
        left_column = required_trainings[:half]
        right_column = required_trainings[half:]
        
        left_text = "<br/>".join([f"• {t.get('TrgDesc', '')}" for t in left_column])
        right_text = "<br/>".join([f"• {t.get('TrgDesc', '')}" for t in right_column])
    else:
        left_text = "N/A"
        right_text = ""
    
    req_data = [
        [Paragraph("<b>TRAININGS REQUIRED</b>", bold), ""],
        [Paragraph(left_text, normal), Paragraph(right_text, normal)]
    ]
    
    # Calculate dynamic height based on content (minimum 100px)
    content_lines = len(required_trainings) if required_trainings else 1
    dynamic_height = max(100, min(content_lines * 15, 200))  # 15px per line, max 200px
    
    req_table = Table(req_data, colWidths=[250, 250], rowHeights=[25, dynamic_height])
    req_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('SPAN', (0, 0), (1, 0)),  # Merge header across both columns
        ('FONTNAME', (0, 0), (1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (1, 0), 11),
        ('ALIGN', (0, 0), (1, 0), 'LEFT'),
        # Remove vertical line between columns
        ('LINEAFTER', (0, 1), (0, 1), 0, colors.white),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (1, 0), 0, colors.white),
    ]))
    elements.append(req_table)

    # SECTION 8: TRAININGS RECEIVED
    # Acquired trainings content - split into 2 columns
    if acquired_trainings:
        # Split trainings into two columns
        half = (len(acquired_trainings) + 1) // 2
        left_column = acquired_trainings[:half]
        right_column = acquired_trainings[half:]
        
        left_text = "<br/>".join([f"• {t.get('Acquired_Training_Desc', '')}" for t in left_column])
        right_text = "<br/>".join([f"• {t.get('Acquired_Training_Desc', '')}" for t in right_column])
    else:
        left_text = "N/A"
        right_text = ""
    
    acq_data = [
        [Paragraph("<b>TRAININGS RECEIVED</b>", bold), ""],
        [Paragraph(left_text, normal), Paragraph(right_text, normal)]
    ]
    
    # Calculate dynamic height based on content (minimum 100px)
    content_lines = len(acquired_trainings) if acquired_trainings else 1
    dynamic_height = max(100, min(content_lines * 15, 200))  # 15px per line, max 200px
    
    acq_table = Table(acq_data, colWidths=[250, 250], rowHeights=[25, dynamic_height])
    acq_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('SPAN', (0, 0), (1, 0)),  # Merge header across both columns
        ('FONTNAME', (0, 0), (1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (1, 0), 11),
        ('ALIGN', (0, 0), (1, 0), 'LEFT'),
        # Remove vertical line between columns
        ('LINEAFTER', (0, 1), (0, 1), 0, colors.white),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (1, 0), 0, colors.white),
    ]))
    elements.append(acq_table)

    # SECTION 9: TRAINING GAPS
    # Missing trainings content - split into 2 columns
    if missing_trainings:
        # Split trainings into two columns
        half = (len(missing_trainings) + 1) // 2
        left_column = missing_trainings[:half]
        right_column = missing_trainings[half:]
        
        left_text = "<br/>".join([f"• {t.get('Missing_Training_Desc', '')}" for t in left_column])
        right_text = "<br/>".join([f"• {t.get('Missing_Training_Desc', '')}" for t in right_column])
    else:
        left_text = "No training gaps identified"
        right_text = ""
    
    gaps_data = [
        [Paragraph("<b>TRAINING GAPS</b>", bold), ""],
        [Paragraph(left_text, normal), Paragraph(right_text, normal)]
    ]
    
    # Calculate dynamic height based on content (minimum 100px)
    content_lines = len(missing_trainings) if missing_trainings else 1
    dynamic_height = max(100, min(content_lines * 15, 200))  # 15px per line, max 200px
    
    gaps_table = Table(gaps_data, colWidths=[250, 250], rowHeights=[25, dynamic_height])
    gaps_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('LEFTPADDING', (0, 0), (-1, -1), 12),
        ('RIGHTPADDING', (0, 0), (-1, -1), 12),
        ('TOPPADDING', (0, 0), (-1, -1), 7),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        # Header row styling
        ('SPAN', (0, 0), (1, 0)),  # Merge header across both columns
        ('FONTNAME', (0, 0), (1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (1, 0), 11),
        ('ALIGN', (0, 0), (1, 0), 'LEFT'),
        # Remove vertical line between columns
        ('LINEAFTER', (0, 1), (0, 1), 0, colors.white),
        # Remove bottom border from header
        ('LINEBELOW', (0, 0), (1, 0), 0, colors.white),
        # Special pink background for training gaps header
        #('BACKGROUND', (0, 0), (1, 0), colors.Color(248/255, 215/255, 218/255)),
    ]))
    elements.append(gaps_table)
    elements.append(Spacer(1, 15))

    # SIGNATURE SECTION
    sig_data = [
        [Paragraph("<b>PREPARED BY</b>", normal), Paragraph("<b>REVIEWED BY</b>", normal), Paragraph("<b>APPROVED BY</b>", normal)],
        [Paragraph("<br/><br/>Name: ____________________<br/><br/>Designation: ______________<br/><br/>Signature: _______________<br/><br/>", normal),
         Paragraph("<br/><br/>Name: ____________________<br/><br/>Designation: ______________<br/><br/>Signature: _______________<br/><br/>", normal),
         Paragraph("<br/><br/>Name: ____________________<br/><br/>Designation: ______________<br/><br/>Signature: _______________<br/><br/>", normal)],
        [Paragraph("Date: ___________________", normal), Paragraph("Date: ___________________", normal), Paragraph("Date: ___________________", normal)]
    ]
    
    sig_table = Table(sig_data, colWidths=[167, 167, 166])
    sig_table.setStyle(TableStyle([
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('LEFTPADDING', (0, 0), (-1, -1), 10),
        ('RIGHTPADDING', (0, 0), (-1, -1), 10),
        ('TOPPADDING', (0, 0), (-1, -1), 12),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
    ]))
    elements.append(sig_table)
    
    # Footer
    elements.append(Spacer(1, 15))
    from datetime import datetime
    elements.append(Paragraph(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", 
                            ParagraphStyle('Footer', parent=normal, fontSize=9, textColor=colors.grey, alignment=1)))

    doc.build(elements)
    buffer.seek(0)
    return send_file(buffer, as_attachment=True, download_name='job_analysis_card.pdf', mimetype='application/pdf')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

@app.route('/training_analysis', methods=['GET', 'POST'])
@login_required
def training_analysis():
    """Training analysis for Directors and Managers/Heads"""
    user_role = session.get('user_role', '').lower()
    
    # Only allow access to Director and Manager/Head roles
    if user_role not in ['director', 'head', 'manager', 'manager/head', 'head/manager']:
        flash('Access denied. This feature is for Directors and Managers only.', 'error')
        return redirect(url_for('dashboard'))
    
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    
    # Get all training codes for dropdown
    cursor.execute('SELECT TrgCode, TrgDesc FROM cat_alltrainings ORDER BY TrgCode')
    all_trainings = cursor.fetchall()
    
    training_data = None
    selected_training = None
    
    if request.method == 'POST':
        selected_training_code = request.form.get('training_code')
        
        if selected_training_code:
            selected_training = next((t for t in all_trainings if t['TrgCode'] == selected_training_code), None)
            
            # Build role-based filter conditions
            user_pin = session.get('user_pin')
            
            if user_role == 'director':
                # Directors can see all employees in their project/establishment
                role_condition = 'AND e.Project = %s'
                role_params = (session.get('user_project'),)
            elif user_role in ['head', 'manager', 'manager/head', 'head/manager']:
                # Heads/Managers can see employees in their division only
                role_condition = 'AND e.DIVISION = %s'
                role_params = (session.get('user_division'),)
            elif user_role == 'section head':
                # Section heads can see employees in their section only
                role_condition = 'AND e.SECTION = %s'
                role_params = (session.get('user_section'),)
            else:
                # Default to no access
                role_condition = 'AND 1=0'
                role_params = ()
            
            # Get employees who require this training (with role-based filtering)
            cursor.execute(f'''
                SELECT DISTINCT e.PIN, e.EMPNAME, e.DESIG, e.JOBPOSITION, e.DIVISION, e.SECTION
                FROM cat_employee e
                JOIN trainings_jac_required_for_job_position req ON e.JOBPOSITION = req.Jobposition
                WHERE req.TrgCode = %s {role_condition}
                ORDER BY e.EMPNAME
            ''', (selected_training_code,) + role_params)
            employees_required = cursor.fetchall()
            
            # Get employees who have taken this training (with role-based filtering)
            cursor.execute(f'''
                SELECT e.PIN, e.EMPNAME, e.DESIG, e.JOBPOSITION, e.DIVISION, e.SECTION
                FROM cat_employee e
                JOIN trainees_received_trainings trt ON e.PIN = trt.PIN
                WHERE trt.TrgCode = %s {role_condition}
                ORDER BY e.EMPNAME
            ''', (selected_training_code,) + role_params)
            employees_completed = cursor.fetchall()
            
            # Get employees who still need this training (with role-based filtering)
            cursor.execute(f'''
                SELECT emt.PIN, emt.EMPNAME, e.DESIG, emt.JobPosition, e.DIVISION, e.SECTION
                FROM employee_missing_trainings emt
                JOIN cat_employee e ON emt.PIN = e.PIN
                WHERE emt.Missing_Training = %s {role_condition}
                ORDER BY emt.EMPNAME
            ''', (selected_training_code,) + role_params)
            employees_missing = cursor.fetchall()
            
            training_data = {
                'required': employees_required,
                'completed': employees_completed,
                'missing': employees_missing,
                'training_code': selected_training_code,
                'training_desc': selected_training['TrgDesc'] if selected_training else ''
            }
    
    cursor.close()
    conn.close()
    
    return render_template('training_analysis.html', 
                         all_trainings=all_trainings,
                         training_data=training_data,
                         selected_training=selected_training,
                         user_role=user_role.title())

if __name__ == '__main__':
    app.run(debug=True)