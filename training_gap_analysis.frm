TYPE=VIEW
query=select `e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,count(distinct `e`.`PIN`) AS `total_employees`,count(distinct `emt`.`PIN`) AS `employees_with_gaps`,count(`emt`.`Missing_Training`) AS `total_missing_trainings`,round(count(distinct `emt`.`PIN`) * 100.0 / count(distinct `e`.`PIN`),2) AS `percentage_employees_with_gaps`,group_concat(distinct coalesce(`cat`.`TrgDesc`,`emt`.`Missing_Training`) separator \'; \') AS `common_missing_trainings` from ((`training_program2`.`cat_employee` `e` left join `training_program2`.`employee_missing_trainings` `emt` on(`e`.`PIN` = `emt`.`PIN`)) left join `training_program2`.`cat_alltrainings` `cat` on(`emt`.`Missing_Training` = `cat`.`TrgCode`)) group by `e`.`DIVISION`,`e`.`SECTION`,`e`.`Role` order by round(count(distinct `emt`.`PIN`) * 100.0 / count(distinct `e`.`PIN`),2) desc
md5=0f46ce358c08fabe834f21471fb45935
updatable=0
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001753174904458325
create-version=2
source=SELECT \n    e.DIVISION,\n    e.SECTION,\n    e.Role,\n    COUNT(DISTINCT e.PIN) as total_employees,\n    COUNT(DISTINCT emt.PIN) as employees_with_gaps,\n    COUNT(emt.Missing_Training) as total_missing_trainings,\n    ROUND((COUNT(DISTINCT emt.PIN) * 100.0) / COUNT(DISTINCT e.PIN), 2) as percentage_employees_with_gaps,\n    GROUP_CONCAT(DISTINCT COALESCE(cat.TrgDesc, emt.Missing_Training) SEPARATOR \'; \') as common_missing_trainings\nFROM cat_employee e\nLEFT JOIN employee_missing_trainings emt ON e.PIN = emt.PIN\nLEFT JOIN cat_alltrainings cat ON emt.Missing_Training = cat.TrgCode\nGROUP BY e.DIVISION, e.SECTION, e.Role\nORDER BY percentage_employees_with_gaps DESC
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `e`.`DIVISION` AS `DIVISION`,`e`.`SECTION` AS `SECTION`,`e`.`Role` AS `Role`,count(distinct `e`.`PIN`) AS `total_employees`,count(distinct `emt`.`PIN`) AS `employees_with_gaps`,count(`emt`.`Missing_Training`) AS `total_missing_trainings`,round(count(distinct `emt`.`PIN`) * 100.0 / count(distinct `e`.`PIN`),2) AS `percentage_employees_with_gaps`,group_concat(distinct coalesce(`cat`.`TrgDesc`,`emt`.`Missing_Training`) separator \'; \') AS `common_missing_trainings` from ((`training_program2`.`cat_employee` `e` left join `training_program2`.`employee_missing_trainings` `emt` on(`e`.`PIN` = `emt`.`PIN`)) left join `training_program2`.`cat_alltrainings` `cat` on(`emt`.`Missing_Training` = `cat`.`TrgCode`)) group by `e`.`DIVISION`,`e`.`SECTION`,`e`.`Role` order by round(count(distinct `emt`.`PIN`) * 100.0 / count(distinct `e`.`PIN`),2) desc
mariadb-version=100432
