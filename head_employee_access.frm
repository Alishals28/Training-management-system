TYPE=VIEW
query=select `h`.`PIN` AS `head_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `h` join `training_program2`.`cat_employee` `e`) where `h`.`Role` = \'head\' and `e`.`DIVISION` = `h`.`DIVISION`
md5=58148fa6a8f68c12a22e7b35f355304c
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174868314745
create-version=2
source=SELECT \n    h.PIN as head_pin,\n    e.PIN, e.EMPNAME, e.DESIG, e.JOBPOSITION, e.DIVISION, e.SECTION, e.Role, e.Project\nFROM cat_employee h\nCROSS JOIN cat_employee e\nWHERE h.Role = \'head\' \nAND e.DIVISION = h.DIVISION
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `h`.`PIN` AS `head_pin`,`e`.`PIN` AS `PIN`,`e`.`EMPNAME` AS `EMPNAME`,`e`.`DESIG` AS `DESIG`,`e`.`JOBPOSITION` AS `JOBPOSITION`,`e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,`e`.`Project` AS `Project` from (`training_program2`.`cat_employee` `h` join `training_program2`.`cat_employee` `e`) where `h`.`Role` = \'head\' and `e`.`DIVISION` = `h`.`DIVISION`
mariadb-version=100432
