TYPE=VIEW
query=select `m`.`PIN` AS `manager_pin`,`m`.`EMPNAME` AS `manager_name`,`m`.`Role` AS `manager_role`,count(distinct `s`.`PIN`) AS `total_subordinates`,count(distinct case when `s`.`Role` = \'Employee\' then `s`.`PIN` end) AS `direct_employees`,count(distinct case when `s`.`Role` in (\'Section Head\',\'head\') then `s`.`PIN` end) AS `sub_managers`,round(avg(`ets`.`training_completion_percentage`),2) AS `avg_team_training_completion`,sum(`ets`.`total_missing_trainings`) AS `total_team_training_gaps` from (((`training_program2`.`cat_employee` `m` join `training_program2`.`employee_hierarchy_access` `eha` on(`m`.`PIN` = `eha`.`manager_pin`)) join `training_program2`.`cat_employee` `s` on(`eha`.`PIN` = `s`.`PIN`)) left join `training_program2`.`employee_training_summary` `ets` on(`s`.`PIN` = `ets`.`PIN`)) where `m`.`Role` in (\'Director\',\'head\',\'Section Head\') group by `m`.`PIN`,`m`.`EMPNAME`,`m`.`Role`
md5=522b618561717db4077b7a5cd0f9d954
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174904605126
create-version=2
source=SELECT \n    m.PIN as manager_pin,\n    m.EMPNAME as manager_name,\n    m.Role as manager_role,\n    COUNT(DISTINCT s.PIN) as total_subordinates,\n    COUNT(DISTINCT CASE WHEN s.Role = \'Employee\' THEN s.PIN END) as direct_employees,\n    COUNT(DISTINCT CASE WHEN s.Role IN (\'Section Head\', \'head\') THEN s.PIN END) as sub_managers,\n    ROUND(AVG(ets.training_completion_percentage), 2) as avg_team_training_completion,\n    SUM(ets.total_missing_trainings) as total_team_training_gaps\nFROM cat_employee m\nJOIN employee_hierarchy_access eha ON m.PIN = eha.manager_pin\nJOIN cat_employee s ON eha.PIN = s.PIN\nLEFT JOIN employee_training_summary ets ON s.PIN = ets.PIN\nWHERE m.Role IN (\'Director\', \'head\', \'Section Head\')\nGROUP BY m.PIN, m.EMPNAME, m.Role
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `m`.`PIN` AS `manager_pin`,`m`.`EMPNAME` AS `manager_name`,`m`.`Role` AS `manager_role`,count(distinct `s`.`PIN`) AS `total_subordinates`,count(distinct case when `s`.`Role` = \'Employee\' then `s`.`PIN` end) AS `direct_employees`,count(distinct case when `s`.`Role` in (\'Section Head\',\'head\') then `s`.`PIN` end) AS `sub_managers`,round(avg(`ets`.`training_completion_percentage`),2) AS `avg_team_training_completion`,sum(`ets`.`total_missing_trainings`) AS `total_team_training_gaps` from (((`training_program2`.`cat_employee` `m` join `training_program2`.`employee_hierarchy_access` `eha` on(`m`.`PIN` = `eha`.`manager_pin`)) join `training_program2`.`cat_employee` `s` on(`eha`.`PIN` = `s`.`PIN`)) left join `training_program2`.`employee_training_summary` `ets` on(`s`.`PIN` = `ets`.`PIN`)) where `m`.`Role` in (\'Director\',\'head\',\'Section Head\') group by `m`.`PIN`,`m`.`EMPNAME`,`m`.`Role`
mariadb-version=100432
