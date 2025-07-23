TYPE=VIEW
query=select `jp`.`JobPosition` AS `JobPosition`,`req`.`TrgCode` AS `TrgCode`,`ta`.`TrgDesc` AS `TrgDesc` from ((`training_program2`.`trainings_jac_required_for_job_position` `req` join `training_program2`.`cat_jobposition` `jp` on(`req`.`Jobposition` = `jp`.`JobPosition`)) left join `training_program2`.`cat_alltrainings` `ta` on(trim(`req`.`TrgCode`) = trim(`ta`.`TrgCode`))) where `ta`.`TrgDesc` is not null order by `jp`.`JobPosition`,`req`.`TrgCode`
md5=43815b7305a158b4382818b1c358d487
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001752730345375791
create-version=2
source=SELECT \n    jp.JobPosition,\n    req.TrgCode,\n    ta.TrgDesc\nFROM \n    trainings_jac_required_for_job_position req\n    JOIN cat_jobposition jp ON req.Jobposition = jp.JobPosition\n    LEFT JOIN cat_alltrainings ta ON TRIM(req.TrgCode) = TRIM(ta.TrgCode)\nWHERE \n    ta.TrgDesc IS NOT NULL\nORDER BY \n    jp.JobPosition, req.TrgCode
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `jp`.`JobPosition` AS `JobPosition`,`req`.`TrgCode` AS `TrgCode`,`ta`.`TrgDesc` AS `TrgDesc` from ((`training_program2`.`trainings_jac_required_for_job_position` `req` join `training_program2`.`cat_jobposition` `jp` on(`req`.`Jobposition` = `jp`.`JobPosition`)) left join `training_program2`.`cat_alltrainings` `ta` on(trim(`req`.`TrgCode`) = trim(`ta`.`TrgCode`))) where `ta`.`TrgDesc` is not null order by `jp`.`JobPosition`,`req`.`TrgCode`
mariadb-version=100432
