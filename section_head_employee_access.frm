TYPE=VIEW
query=select `sh`.`PIN` AS `section_head_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `sh` join `training_program2`.`cat_employee` `e`) where `sh`.`Role` = \'Section Head\' and `e`.`SECTION` = `sh`.`SECTION`
md5=97190c712436463f770de7bccaabdc7e
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174904156563
create-version=2
source=SELECT \n    sh.PIN as section_head_pin,\n    e.PIN, e.EMPNAME, e.DESIG, e.JOBPOSITION, e.DIVISION, e.SECTION, e.Role, e.Project\nFROM cat_employee sh\nCROSS JOIN cat_employee e\nWHERE sh.Role = \'Section Head\' \nAND e.SECTION = sh.SECTION
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `sh`.`PIN` AS `section_head_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `sh` join `training_program2`.`cat_employee` `e`) where `sh`.`Role` = \'Section Head\' and `e`.`SECTION` = `sh`.`SECTION`
mariadb-version=100432
