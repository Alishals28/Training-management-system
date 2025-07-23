TYPE=VIEW
query=select `e`.`EMPNAME` AS `EMPNAME`,`e`.`PIN` AS `PIN`,`e`.`JOBPOSITION` AS `JobPosition`,`trj`.`TrgCode` AS `Missing_Training` from ((`training_program2`.`cat_employee` `e` join `training_program2`.`trainings_jac_required_for_job_position` `trj` on(`e`.`JOBPOSITION` = `trj`.`Jobposition`)) left join `training_program2`.`trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN` and `trj`.`TrgCode` = `ta`.`TrgCode`)) where `ta`.`TrgCode` is null
md5=24e0939a476491e103afe63d514bbe97
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001752730934462569
create-version=2
source=SELECT \n    e.EMPNAME, \n    e.PIN, \n    e.JOBPOSITION AS JobPosition, \n    trj.TrgCode AS Missing_Training \nFROM \n    cat_employee e \n    JOIN trainings_jac_required_for_job_position trj ON e.JOBPOSITION = trj.Jobposition\n    LEFT JOIN trainees_received_trainings ta ON e.PIN = ta.PIN AND trj.TrgCode = ta.TrgCode\nWHERE \n    ta.TrgCode IS NULL
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `e`.`EMPNAME` AS `EMPNAME`,`e`.`PIN` AS `PIN`,`e`.`JOBPOSITION` AS `JobPosition`,`trj`.`TrgCode` AS `Missing_Training` from ((`training_program2`.`cat_employee` `e` join `training_program2`.`trainings_jac_required_for_job_position` `trj` on(`e`.`JOBPOSITION` = `trj`.`Jobposition`)) left join `training_program2`.`trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN` and `trj`.`TrgCode` = `ta`.`TrgCode`)) where `ta`.`TrgCode` is null
mariadb-version=100432
