-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 16, 2021 at 07:54 PM
-- Server version: 8.0.23-0ubuntu0.20.04.1
-- PHP Version: 7.2.24-0ubuntu0.18.04.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `digitaltrons`
--

-- --------------------------------------------------------

--
-- Table structure for table `add_notification`
--

CREATE TABLE `add_notification` (
  `name` varchar(100) NOT NULL,
  `d` tinyint(1) NOT NULL,
  `moment` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `add_notification`
--

INSERT INTO `add_notification` (`name`, `d`, `moment`) VALUES
('Folder10', 1, '2021-05-16 10:21:02');

-- --------------------------------------------------------

--
-- Table structure for table `filesystem`
--

CREATE TABLE `filesystem` (
  `parent` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `node` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `d` tinyint(1) NOT NULL DEFAULT '0',
  `moment` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `filesystem`
--

INSERT INTO `filesystem` (`parent`, `node`, `d`, `moment`) VALUES
(NULL, 'File1', 0, '2021-05-15 01:07:09'),
(NULL, 'File2', 0, '2021-05-15 01:07:09'),
('Folder1', 'File3', 0, '2021-05-15 01:16:40'),
('Folder2', 'File4', 0, '2021-05-15 01:07:09'),
(NULL, 'Folder1', 1, '2021-05-15 01:07:09'),
('Folder1', 'Folder10', 1, '2021-05-16 10:21:02'),
(NULL, 'Folder2', 1, '2021-05-15 01:07:09'),
(NULL, 'Folder3', 1, '2021-05-15 01:07:09'),
('Folder1', 'Folder4', 1, '2021-05-15 01:07:09'),
('Folder1', 'Folder5', 1, '2021-05-15 01:07:09'),
('Folder4', 'Folder6', 1, '2021-05-15 01:16:40'),
('Folder6', 'Folder99', 1, '2021-05-15 13:28:25');

--
-- Triggers `filesystem`
--
DELIMITER $$
CREATE TRIGGER `NotifyOnAdd` AFTER INSERT ON `filesystem` FOR EACH ROW INSERT INTO add_notification(name, d)
VALUES(NEW.node, NEW.d)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ValidateMove` BEFORE UPDATE ON `filesystem` FOR EACH ROW IF ((SELECT d FROM filesystem WHERE node=NEW.parent)=0) THEN
  SIGNAL sqlstate '45001' SET message_text = "Target must be a Folder";
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `file_hierarchy`
-- (See below for the actual view)
--
CREATE TABLE `file_hierarchy` (
`d` tinyint
,`node` varchar(500)
,`path` varchar(500)
);

-- --------------------------------------------------------

--
-- Structure for view `file_hierarchy`
--
DROP TABLE IF EXISTS `file_hierarchy`;

CREATE ALGORITHM=MERGE DEFINER=`koushik`@`%` SQL SECURITY DEFINER VIEW `file_hierarchy`  AS  with recursive `file_hierarchy` (`node`,`path`,`d`) as (select `filesystem`.`node` AS `node`,`filesystem`.`node` AS `path`,`filesystem`.`d` AS `d` from `filesystem` where (`filesystem`.`parent` is null) union all select `c`.`node` AS `node`,concat(`cp`.`path`,'/',`c`.`node`) AS `CONCAT(cp.path, '/', c.node)`,`c`.`d` AS `d` from (`file_hierarchy` `cp` join `filesystem` `c` on((`cp`.`node` = `c`.`parent`)))) select `file_hierarchy`.`node` AS `node`,`file_hierarchy`.`path` AS `path`,`file_hierarchy`.`d` AS `d` from `file_hierarchy` order by `file_hierarchy`.`path` WITH LOCAL CHECK OPTION ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `filesystem`
--
ALTER TABLE `filesystem`
  ADD PRIMARY KEY (`node`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
