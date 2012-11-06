-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generato il: Nov 06, 2012 alle 17:56
-- Versione del server: 5.5.27
-- Versione PHP: 5.4.6-1ubuntu1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `picus`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `data`
--

CREATE TABLE IF NOT EXISTS `data` (
  `apikey` varchar(25) NOT NULL,
  `project_name` varchar(25) NOT NULL,
  `name` varchar(25) NOT NULL,
  `value` int(11) NOT NULL,
  `last_access` date NOT NULL,
  KEY `apikey` (`apikey`),
  KEY `project_name` (`project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Struttura della tabella `flyports`
--

CREATE TABLE IF NOT EXISTS `flyports` (
  `apikey` varchar(25) NOT NULL,
  `project_name` varchar(25) NOT NULL,
  KEY `apikey` (`apikey`),
  KEY `project_name` (`project_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user` varchar(15) NOT NULL,
  `email` varchar(35) NOT NULL,
  `password` text NOT NULL,
  `apikey` varchar(25) NOT NULL,
  KEY `apikey` (`apikey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `data`
--
ALTER TABLE `data`
  ADD CONSTRAINT `data_ibfk_3` FOREIGN KEY (`apikey`) REFERENCES `flyports` (`apikey`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `data_ibfk_4` FOREIGN KEY (`project_name`) REFERENCES `flyports` (`project_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `flyports`
--
ALTER TABLE `flyports`
  ADD CONSTRAINT `flyports_ibfk_1` FOREIGN KEY (`apikey`) REFERENCES `users` (`apikey`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;