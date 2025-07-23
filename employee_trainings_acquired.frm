TYPE=VIEW
query=select `e`.`EMPNAME` AS `EMPNAME`,`e`.`PIN` AS `PIN`,`e`.`JOBPOSITION` AS `JobPosition`,`ta`.`TrgCode` AS `Acquired_Training` from (`training_program2`.`cat_employee` `e` join `training_program2`.`trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN`))
md5=50a93a1649b1f0836366232541229bd4
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001752722919191313
create-version=2
source=SELECT\n    e.EMPNAME,\n    e.PIN,\n    e.JobPosition,\n    ta.Trgcode AS Acquired_Training\nFROM cat_employee e\nJOIN trainees_received_trainings ta\n    ON e.PIN = ta.PIN
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `e`.`EMPNAME` AS `EMPNAME`,`e`.`PIN` AS `PIN`,`e`.`JOBPOSITION` AS `JobPosition`,`ta`.`TrgCode` AS `Acquired_Training` from (`training_program2`.`cat_employee` `e` join `training_program2`.`trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN`))
mariadb-version=100432
