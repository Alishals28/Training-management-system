-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 22, 2025 at 07:59 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `training_program2`
--

-- --------------------------------------------------------

--
-- Table structure for table `cat_alltrainings`
--

CREATE TABLE `cat_alltrainings` (
  `TrgCode` varchar(255) NOT NULL,
  `TrgDesc` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_alltrainings`
--

INSERT INTO `cat_alltrainings` (`TrgCode`, `TrgDesc`) VALUES
('BALGATOM', 'Belgatom Step-1 Trg. Course & PDMS, K-2'),
('BMC', 'Basic Management Course, PIEAS Islamabad'),
('SELF_ASSESS', 'Self assessment'),
('IS', 'Industrial Safety'),
('MSM', 'Management Systems Manual'),
('DATAANALYSIS', 'Data Analytics'),
('SELF_ASSESS', 'Assessment'),
('K2/K3_System_Equip', 'Kanupp 2 and Kanupp 3'),
('MsOffice', 'Microsoft Office 2013');

-- --------------------------------------------------------

--
-- Table structure for table `cat_division`
--

CREATE TABLE `cat_division` (
  `div_code` varchar(255) NOT NULL,
  `div_name` varchar(255) NOT NULL,
  `div_description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_division`
--

INSERT INTO `cat_division` (`div_code`, `div_name`, `div_description`) VALUES
('1', 'IT&CS', 'Information Technology & Cybersecurity');

-- --------------------------------------------------------

--
-- Table structure for table `cat_employee`
--

CREATE TABLE `cat_employee` (
  `PIN` int(10) DEFAULT NULL,
  `PNO` int(10) DEFAULT NULL,
  `EMPNAME` varchar(255) DEFAULT NULL,
  `DESIG` varchar(255) DEFAULT NULL,
  `JOBPOSITION` varchar(255) DEFAULT NULL,
  `EDUCATION` varchar(255) DEFAULT NULL,
  `EXPERIENCE` int(10) DEFAULT NULL,
  `DIVISION` varchar(255) DEFAULT NULL,
  `SECTION` varchar(255) DEFAULT NULL,
  `Project` varchar(255) NOT NULL,
  `Role` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `cat_employee`
--

INSERT INTO `cat_employee` (`PIN`, `PNO`, `EMPNAME`, `DESIG`, `JOBPOSITION`, `EDUCATION`, `EXPERIENCE`, `DIVISION`, `SECTION`, `Project`, `Role`) VALUES
(14477, 1567, 'Akhtar JA', 'PE', 'HO&M', 'B.E (Computer System) / PGTP (Nuclear Power)', 20, 'Simulator ', 'O&M', '', ''),
(12977, 1552, 'KA Jafri', 'DCE', 'MSD', 'BE(Electrical)/ M. Engg. (NPE)', 5, 'Simulator ', 'Simulation', '', ''),
(12978, 1552, 'R Ali ', 'PE', 'HSIM', 'PhD', 2, 'Simulator ', 'Simulation', '', ''),
(4917, 4917, 'm.ahsaan', 'Tec', 'Dev', 'DAE', 1, 'IT&CS', 'CS', 'KINPOE', 'Employee'),
(1, 111, 'P Asdaque', 'CS', 'Director', 'MSc Elec.', 25, NULL, NULL, 'KINPOE', 'Director'),
(2, 122, 'N. Ahsan', 'DCS', ' H(IT&CS)', 'MSc Computer', 20, 'IT&CS', 'IT&CS', 'KINPOE', 'head'),
(3, 133, 'Salman Ahmed Khan', 'PE', 'SH(CS)', 'PhD Computer/ MSc NPE', 18, 'IT&CS', 'CS', 'KINPOE', 'Section Head');

-- --------------------------------------------------------

--
-- Table structure for table `cat_establishment`
--

CREATE TABLE `cat_establishment` (
  `est_code` varchar(255) NOT NULL,
  `est_name` varchar(255) NOT NULL,
  `est_discription` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_establishment`
--

INSERT INTO `cat_establishment` (`est_code`, `est_name`, `est_discription`) VALUES
('1', 'KINPOE', 'Karachi Institute Of Power Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `cat_jobarea`
--

CREATE TABLE `cat_jobarea` (
  `JobAreaCode` varchar(255) NOT NULL,
  `JobArea` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_jobarea`
--

INSERT INTO `cat_jobarea` (`JobAreaCode`, `JobArea`, `Reference`) VALUES
('FSS-DnD', 'Displays of K-2 Full Scope Simulator ', 'KIN-SD-RES-03-001'),
('SD-DOC', 'Documentation of Simulator Division', 'KIN-SD-RES-03-002'),
('SA-CRD', 'Self Assessment Coordinator', 'KIN-SD-RES-03-003'),
('QA-CRD', 'QA Coordinator', 'KIN-SD-RES-03-004'),
('FSS-O&M', 'Operation and Maintenance of K2FSS', 'KIN-SD-RES-03-002'),
('FSS-LVL0', 'Process Model (level0) of K2 Full Scope Simulator', 'KIN-SD-RES-03-003'),
('FSS-LVL1', 'DCS Logic (level1) of K2 Full Scope Simulator', 'KIN-SD-RES-03-004'),
('FSS-TCS', 'TCS (level0 & 1 ) of K2 Full Scope Simulator', 'KIN-SD-RES-03-005'),
('TEACH-MS', 'Teaching in MS/ Supervision of MS Projects', 'KIN-SD-RES-03-006'),
('TEACH-TRG', 'Teaching in Training Center for different courses when required', 'KIN-SD-RES-03-007'),
('COORD-SER-KTC', 'Coordinate services require fot KINPOE Training Center, BT building (KNPGS)', 'KIN-SD-RES-03-008'),
('SD-MNG', 'Management and Supervision of Simulator Division', 'KIN-SD-RES-03-009'),
('FSS-ACPT', 'Supervision of Acceptance of Simulator', 'KIN-SD-RES-03-010');

-- --------------------------------------------------------

--
-- Table structure for table `cat_jobgtask`
--

CREATE TABLE `cat_jobgtask` (
  `JobGTaskCode` varchar(255) NOT NULL,
  `JobGTask` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_jobgtask`
--

INSERT INTO `cat_jobgtask` (`JobGTaskCode`, `JobGTask`, `Reference`) VALUES
('G-SD-DnD-LEAD', 'Provide leadership to section personnel for planning, managing and execution of relevant simulator activities.', 'KIN-SD-RES-03-001'),
('G-SD-DnD-MODIF', 'Coordinate activities with CNOS/CNPO through Manager to follow-up Level 2 modifications.', 'KIN-SD-RES-03-002'),
('G-SD-DnD-RESMNG', 'Ensure the best utilization of available resources within the section.', 'KIN-SD-RES-03-005'),
('G-SD-DnD-RK', 'Ensure the management and maintenance of relevant sectional/vendor documents/records.', 'KIN-SD-RES-03-004'),
('G-SD-DnD-SA', ' Responsible for implementation of self-assessment program of SD.', 'KIN-SD-RES-03-003'),
('G-SD-DnD-SFC', ' Ensure and promote safety culture (awareness) among sectional personnel.', 'KIN-SD-RES-03-006'),
('Tm_wk', 'Team Work ', '');

-- --------------------------------------------------------

--
-- Table structure for table `cat_jobposition`
--

CREATE TABLE `cat_jobposition` (
  `JobPosition` varchar(255) DEFAULT NULL,
  `JobPos_Descrip` varchar(255) DEFAULT NULL,
  `JobPos_ExpReq` int(20) DEFAULT NULL,
  `JobPos_EduReq` varchar(255) DEFAULT NULL,
  `JobPos_Purpose` varchar(255) DEFAULT NULL,
  `JobPos_Tools_Software` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `cat_jobposition`
--

INSERT INTO `cat_jobposition` (`JobPosition`, `JobPos_Descrip`, `JobPos_ExpReq`, `JobPos_EduReq`, `JobPos_Purpose`, `JobPos_Tools_Software`) VALUES
('HO&M', 'Head(O&M)', 5, 'BE/MSc', 'Responsible for the operation & maintenance of K-2 Full Scope Simulator and to ensure its availability for Plant Operator Training program and Licensing examination', '1. RINSIM Simulation Software Platform. 2. Simulation System Support Software. 3. MS Office and other related software. 4- FSS Hardware, Windows OS for servers, Audio/Video Control Software '),
('MSD', 'M(Simulator)', 5, 'BE/MSc', 'Responsible for the implementation of all functions & tasks assigned to Simulator Division', '1. RINSIM Simulation Software Platform. 2. Simulation System Support Software. 3. MS Office and other related software'),
('HSIM', 'H(Simulation)', 5, 'BE/MSc', 'Responsible to carry out all necessary activities related toProcess model (level 0), DCs Model (Level1), Turbine control system (RCS)and In-Core Instrumentation System (RII)', '1. RINSIM Simulation Software Platform. 2. Vpower Software for TCS DCS and for communication between TCS and modek server. 3. MS Office and other related software'),
('Dev', 'Developer', 5, 'DAE', 'to develop apps.', 'Excel, Vscode, SQL');

-- --------------------------------------------------------

--
-- Table structure for table `cat_jobttask`
--

CREATE TABLE `cat_jobttask` (
  `JobTTaskCode` varchar(255) NOT NULL,
  `JobTTask` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_jobttask`
--

INSERT INTO `cat_jobttask` (`JobTTaskCode`, `JobTTask`, `Reference`) VALUES
('T-SD-DnD-SLVL2', ' Provide K2 FSS software support to operator work panel and large display panel.', 'KIN-SD-REC-03-001'),
('T-SD-DnD-DRLVL2', ' Handle work request /deficiency report related to Level 2 model on RINSIM.', 'KIN-SD-REC-03-002'),
('T-SD-DnD-FSSDOC', 'Responsible to manage/maintain the Divisional and FSS related documentation.', 'KIN-SD-REC-03-003'),
('T-SD-DnD-PLDOC', ' Review documents received from Plant regarding changes in Level 2 simulation and assess their implementation in FSS.', 'KIN-SD-REC-03-004'),
('T-SD-DnD-QAP', ' Implementation/compliance of QAP requirements on section and divisional level.', 'KIN-SD-REC-03-005'),
('T-SD-DnD-DRMNG', 'Ensure implementation of Simulator Deficiency Report Management Program', 'KIN-SD-REC-03-006'),
('web_app_development', 'web Application Development', ''),
('Maintain_Operation_of_simulator', 'MSD shall be responsible for maintaining full operation of simulator for OTD.', '');

-- --------------------------------------------------------

--
-- Table structure for table `cat_role`
--

CREATE TABLE `cat_role` (
  `role_code` varchar(255) NOT NULL,
  `role_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_role`
--

INSERT INTO `cat_role` (`role_code`, `role_name`) VALUES
('1', 'Director'),
('2', 'Manger/Head'),
('3', 'Section Head'),
('4', 'Employee');

-- --------------------------------------------------------

--
-- Table structure for table `cat_section`
--

CREATE TABLE `cat_section` (
  `sec_code` varchar(255) NOT NULL,
  `sec_name` varchar(255) NOT NULL,
  `sec_description` varchar(255) NOT NULL,
  `div_code` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cat_section`
--

INSERT INTO `cat_section` (`sec_code`, `sec_name`, `sec_description`, `div_code`) VALUES
('11', 'IT', 'Information Technology', '1'),
('12', 'CS', 'Cybersecurity', '1');

-- --------------------------------------------------------

--
-- Stand-in structure for view `employee_missing_trainings`
-- (See below for the actual view)
--
CREATE TABLE `employee_missing_trainings` (
`EMPNAME` varchar(255)
,`PIN` int(10)
,`JobPosition` varchar(255)
,`Missing_Training` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `employee_trainings_acquired`
-- (See below for the actual view)
--
CREATE TABLE `employee_trainings_acquired` (
`EMPNAME` varchar(255)
,`PIN` int(10)
,`JobPosition` varchar(255)
,`Acquired_Training` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `job_gtask_view`
-- (See below for the actual view)
--
CREATE TABLE `job_gtask_view` (
`JobPosition` varchar(255)
,`General_Task` varchar(255)
,`Technical_Task` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `trainees_received_trainings`
--

CREATE TABLE `trainees_received_trainings` (
  `PIN` int(20) NOT NULL,
  `TrgCode` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trainees_received_trainings`
--

INSERT INTO `trainees_received_trainings` (`PIN`, `TrgCode`) VALUES
(12957, 'RPT'),
(12957, 'FIREPROT'),
(12957, 'NSC'),
(12957, 'FME'),
(12957, 'HU'),
(12957, 'e_PM'),
(12957, 'BMC'),
(12957, 'BALGATOM'),
(71113, 'RPT'),
(71113, 'RCA_IAEA_PNRA'),
(71113, 'WANOTSM_OE'),
(71113, 'AGING'),
(71113, 'FIREPROT'),
(71113, 'FME'),
(12977, 'K2/K3_System_Equip'),
(12977, 'IS'),
(4917, 'MsOffice');

-- --------------------------------------------------------

--
-- Table structure for table `trainings_jac_required_for_job_position`
--

CREATE TABLE `trainings_jac_required_for_job_position` (
  `TrgCode` varchar(255) NOT NULL,
  `Jobposition` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trainings_jac_required_for_job_position`
--

INSERT INTO `trainings_jac_required_for_job_position` (`TrgCode`, `Jobposition`) VALUES
('K2/K3_System_Equip', 'HOE&RCA'),
('NSC', 'HOE&RCA'),
('DATAANALYSIS', 'HOE&RCA'),
('SELF_ASSESS', 'HOE&RCA'),
('G_MSEXCEL', 'HOE&RCA'),
('MS_POWERBI', 'HOE&RCA'),
('K2/K3_System_Equip', 'MSD'),
('SELF_ASSESS', 'MSD'),
('MSM', 'MSD'),
('DATAANALYSIS', 'Dev'),
('BMC', 'Dev'),
('MsOffice', 'Dev');

-- --------------------------------------------------------

--
-- Stand-in structure for view `training_required_by_jobposition`
-- (See below for the actual view)
--
CREATE TABLE `training_required_by_jobposition` (
`JobPosition` varchar(255)
,`TrgCode` varchar(255)
,`TrgDesc` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `PIN` int(10) NOT NULL,
  `Password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`PIN`, `Password`) VALUES
(4917, 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'),
(12977, '6affdae3b3c1aa6aa7689e9b6a7b3225a636aa1ac0025f490cca1285ceaf1487'),
(1, 'ef7d74898c22a4bf0be437d30987bc945310dcdf1ddb48a6bce085f376b302ae'),
(2, '9d9414cbd35e10a2b1f889dc820ec7a91d6b272d78917ade61111cedf997ff77'),
(3, '13aacf62bf7029566aa6488bd4722075f9c8a3fa3e63ae018819998ff619e409');

-- --------------------------------------------------------

--
-- Table structure for table `x_jobposition_jobarea`
--

CREATE TABLE `x_jobposition_jobarea` (
  `JobPosition` varchar(255) NOT NULL,
  `JobAreaCode` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `x_jobposition_jobarea`
--

INSERT INTO `x_jobposition_jobarea` (`JobPosition`, `JobAreaCode`, `Reference`) VALUES
('HDnD', 'HDnDCode', ''),
('HO&M', 'FSS-O&M', ''),
('HD&D', 'FSS-D&D', ''),
('HD&D', 'FSS-DnD', ''),
('HD&D', 'SA-CRD', ''),
('HD&D', 'SD-DOC', ''),
('HO&M', 'FSS-O&M', ''),
('HSIM', 'COORD-SER-KTC', ''),
('HSIM', 'FSS-LVL0', ''),
('HSIM', 'FSS-LVL1', ''),
('HSIM', 'FSS-TCS', ''),
('HSIM', 'TEACH-MS', ''),
('HSIM', 'TEACH-TRG', ''),
('ESIM1', 'FSS-LVL0', ''),
('ESIM1', 'FSS-LVL1', ''),
('ESIM1', 'FSS-TCS', ''),
('MSD', 'COORD-SER-KTC', ''),
('MSD', 'FSS-ACPT', ''),
('MSD', 'SD-MNG', ''),
('HO&M', 'TEACH-MS\r\n', ''),
('HO&M', 'TEACH-TRG', '');

-- --------------------------------------------------------

--
-- Table structure for table `x_jobposition_jobgtask`
--

CREATE TABLE `x_jobposition_jobgtask` (
  `JobPosition` varchar(255) NOT NULL,
  `JobGTaskCode` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `x_jobposition_jobgtask`
--

INSERT INTO `x_jobposition_jobgtask` (`JobPosition`, `JobGTaskCode`, `Reference`) VALUES
('HDnD', 'G-SD-DnD-LEAD', 'KIN-SD-RES-03-001'),
('HDnD', 'G-SD-DnD-MODIF', 'KIN-SD-RES-03-002'),
('HDnD', 'G-SD-DnD-SA', 'KIN-SD-RES-03-003'),
('HDnD', 'G-SD-DnD-RK', 'KIN-SD-RES-03-004'),
('HDnD', 'G-SD-DnD-RESMNG', 'KIN-SD-RES-03-005'),
('HDnD', 'G-SD-DnD-SFC', 'KIN-SD-RES-03-006'),
('HO&M', 'G-SD-DnD-SFC', ''),
('MSD', 'G-SD-DnD-RK', ''),
('HO&M', 'G-SD-DnD-RESMNG', ''),
('Dev', 'Tm_wk', '');

-- --------------------------------------------------------

--
-- Table structure for table `x_jobposition_jobttask`
--

CREATE TABLE `x_jobposition_jobttask` (
  `ID` int(100) NOT NULL,
  `JobPosition` varchar(255) NOT NULL,
  `JobTTask` varchar(255) NOT NULL,
  `Reference` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `x_jobposition_jobttask`
--

INSERT INTO `x_jobposition_jobttask` (`ID`, `JobPosition`, `JobTTask`, `Reference`) VALUES
(62, 'HDnD', 'T-SD-DnD-DRLVL2', 'KIN-SD-RES-03-001'),
(64, 'HDnD', 'T-SD-DnD-PLDOC', 'KIN-SD-RES-03-001'),
(65, 'HDnD', 'T-SD-DnD-QAP', 'KIN-SD-RES-03-001'),
(66, 'HDnD', 'T-SD-DnD-DRMNG', 'KIN-SD-RES-03-001'),
(0, 'MSD', 'T-SD-DnD-SLVL2\r\n', ''),
(0, 'HO&M', 'T-SD-DnD-QAP', ''),
(0, 'HO&M', 'T-SD-DnD-QAC', ''),
(0, 'Dev', 'Web_app_development', ''),
(0, 'MSD', 'Maintain_Operation_of_simulator', '');

-- --------------------------------------------------------

--
-- Structure for view `employee_missing_trainings`
--
DROP TABLE IF EXISTS `employee_missing_trainings`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employee_missing_trainings`  AS SELECT `e`.`EMPNAME` AS `EMPNAME`, `e`.`PIN` AS `PIN`, `e`.`JOBPOSITION` AS `JobPosition`, `trj`.`TrgCode` AS `Missing_Training` FROM ((`cat_employee` `e` join `trainings_jac_required_for_job_position` `trj` on(`e`.`JOBPOSITION` = `trj`.`Jobposition`)) left join `trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN` and `trj`.`TrgCode` = `ta`.`TrgCode`)) WHERE `ta`.`TrgCode` is null ;

-- --------------------------------------------------------

--
-- Structure for view `employee_trainings_acquired`
--
DROP TABLE IF EXISTS `employee_trainings_acquired`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employee_trainings_acquired`  AS SELECT `e`.`EMPNAME` AS `EMPNAME`, `e`.`PIN` AS `PIN`, `e`.`JOBPOSITION` AS `JobPosition`, `ta`.`TrgCode` AS `Acquired_Training` FROM (`cat_employee` `e` join `trainees_received_trainings` `ta` on(`e`.`PIN` = `ta`.`PIN`)) ;

-- --------------------------------------------------------

--
-- Structure for view `job_gtask_view`
--
DROP TABLE IF EXISTS `job_gtask_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `job_gtask_view`  AS WITH numbers AS (SELECT 1 AS `n` UNION ALL SELECT `numbers`.`n`+ 1 AS `n + 1` FROM `numbers` WHERE `numbers`.`n` < (select greatest(max(`counts`.`task_count_g`),max(`counts`.`task_count_t`)) from (select `jp`.`JobPosition` AS `JobPosition`,count(distinct `g`.`JobGTaskCode`) AS `task_count_g`,count(distinct `t`.`JobTTask`) AS `task_count_t` from ((`cat_jobposition` `jp` left join `x_jobposition_jobgtask` `g` on(`jp`.`JobPosition` = `g`.`JobPosition`)) left join `x_jobposition_jobttask` `t` on(`jp`.`JobPosition` = `t`.`JobPosition`)) group by `jp`.`JobPosition`) `counts`)), GeneralTasks AS (SELECT `jp`.`JobPosition` AS `JobPosition`, `g`.`JobGTaskCode` AS `JobGTaskCode`, row_number() over ( partition by `jp`.`JobPosition` order by `g`.`JobGTaskCode`) AS `rn` FROM (`cat_jobposition` `jp` left join `x_jobposition_jobgtask` `g` on(`jp`.`JobPosition` = `g`.`JobPosition`))), TechnicalTasks AS (SELECT `jp`.`JobPosition` AS `JobPosition`, `t`.`JobTTask` AS `JobTTask`, row_number() over ( partition by `jp`.`JobPosition` order by `t`.`JobTTask`) AS `rn` FROM (`cat_jobposition` `jp` left join `x_jobposition_jobttask` `t` on(`jp`.`JobPosition` = `t`.`JobPosition`)))  SELECT `p`.`JobPosition` AS `JobPosition`, `g`.`JobGTaskCode` AS `General_Task`, `t`.`JobTTask` AS `Technical_Task` FROM (((`cat_jobposition` `p` join `numbers` `n`) left join `generaltasks` `g` on(`p`.`JobPosition` = `g`.`JobPosition` and `n`.`n` = `g`.`rn`)) left join `technicaltasks` `t` on(`p`.`JobPosition` = `t`.`JobPosition` and `n`.`n` = `t`.`rn`)) WHERE `g`.`JobGTaskCode` is not null OR `t`.`JobTTask` is not null ORDER BY `p`.`JobPosition` ASC, `n`.`n` ASC`n`  ;

-- --------------------------------------------------------

--
-- Structure for view `training_required_by_jobposition`
--
DROP TABLE IF EXISTS `training_required_by_jobposition`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `training_required_by_jobposition`  AS SELECT `jp`.`JobPosition` AS `JobPosition`, `req`.`TrgCode` AS `TrgCode`, `ta`.`TrgDesc` AS `TrgDesc` FROM ((`trainings_jac_required_for_job_position` `req` join `cat_jobposition` `jp` on(`req`.`Jobposition` = `jp`.`JobPosition`)) left join `cat_alltrainings` `ta` on(trim(`req`.`TrgCode`) = trim(`ta`.`TrgCode`))) WHERE `ta`.`TrgDesc` is not null ORDER BY `jp`.`JobPosition` ASC, `req`.`TrgCode` ASC ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
