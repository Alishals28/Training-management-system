TYPE=VIEW
query=select `d`.`PIN` AS `director_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `d` join `training_program2`.`cat_employee` `e`) where `d`.`Role` = \'Director\' and `e`.`Project` = `d`.`Project`
md5=b442c3d5f8d1a9a6f5e2891c501db9b0
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174805631830
create-version=2
source=SELECT \n    d.PIN as director_pin,\n    e.PIN, e.EMPNAME, e.DESIG, e.JOBPOSITION, e.DIVISION, e.SECTION, e.Role, e.Project\nFROM cat_employee d\nCROSS JOIN cat_employee e\nWHERE d.Role = \'Director\' \nAND e.Project = d.Project
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `d`.`PIN` AS `director_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `d` join `training_program2`.`cat_employee` `e`) where `d`.`Role` = \'Director\' and `e`.`Project` = `d`.`Project`
mariadb-version=100432
