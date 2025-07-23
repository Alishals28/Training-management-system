TYPE=VIEW
query=select `eha`.`manager_pin` AS `manager_pin`,`eha`.`manager_role` AS `manager_role`,`ets`.`PIN` AS `PIN`,`ets`.`EMPNAME` AS `EMPNAME`,`ets`.`DESIG` AS `DESIG`,`ets`.`JOBPOSITION` AS `JOBPOSITION`,`ets`.`DIVISION` AS `DIVISION`,`ets`.`SECTION` AS `SECTION`,`ets`.`Role` AS `Role`,`ets`.`Project` AS `Project`,`ets`.`total_required_trainings` AS `total_required_trainings`,`ets`.`total_acquired_trainings` AS `total_acquired_trainings`,`ets`.`total_missing_trainings` AS `total_missing_trainings`,`ets`.`training_completion_percentage` AS `training_completion_percentage`,case when `ets`.`training_completion_percentage` >= 90 then \'Excellent\' when `ets`.`training_completion_percentage` >= 75 then \'Good\' when `ets`.`training_completion_percentage` >= 50 then \'Average\' else \'Needs Attention\' end AS `training_status` from (`training_program2`.`employee_hierarchy_access` `eha` join `training_program2`.`employee_training_summary` `ets` on(`eha`.`PIN` = `ets`.`PIN`))
md5=9e84938c4b958d0fd1767a79d204cd25
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174904341948
create-version=2
source=SELECT \n    eha.manager_pin,\n    eha.manager_role,\n    ets.PIN,\n    ets.EMPNAME,\n    ets.DESIG,\n    ets.JOBPOSITION,\n    ets.DIVISION,\n    ets.SECTION,\n    ets.Role,\n    ets.Project,\n    ets.total_required_trainings,\n    ets.total_acquired_trainings,\n    ets.total_missing_trainings,\n    ets.training_completion_percentage,\n    CASE \n        WHEN ets.training_completion_percentage >= 90 THEN \'Excellent\'\n        WHEN ets.training_completion_percentage >= 75 THEN \'Good\'\n        WHEN ets.training_completion_percentage >= 50 THEN \'Average\'\n        ELSE \'Needs Attention\'\n    END as training_status\nFROM employee_hierarchy_access eha\nJOIN employee_training_summary ets ON eha.PIN = ets.PIN
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `eha`.`manager_pin` AS `manager_pin`,`eha`.`manager_role` AS `manager_role`,`ets`.`PIN` AS `PIN`,`ets`.`EMPNAME` AS `EMPNAME`,`ets`.`DESIG` AS `DESIG`,`ets`.`JOBPOSITION` AS `JOBPOSITION`,`ets`.`DIVISION` AS `DIVISION`,`ets`.`SECTION` AS `SECTION`,`ets`.`Role` AS `Role`,`ets`.`Project` AS `Project`,`ets`.`total_required_trainings` AS `total_required_trainings`,`ets`.`total_acquired_trainings` AS `total_acquired_trainings`,`ets`.`total_missing_trainings` AS `total_missing_trainings`,`ets`.`training_completion_percentage` AS `training_completion_percentage`,case when `ets`.`training_completion_percentage` >= 90 then \'Excellent\' when `ets`.`training_completion_percentage` >= 75 then \'Good\' when `ets`.`training_completion_percentage` >= 50 then \'Average\' else \'Needs Attention\' end AS `training_status` from (`training_program2`.`employee_hierarchy_access` `eha` join `training_program2`.`employee_training_summary` `ets` on(`eha`.`PIN` = `ets`.`PIN`))
mariadb-version=100432
