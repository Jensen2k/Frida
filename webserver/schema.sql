# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.25)
# Database: frida
# Generation Time: 2013-06-01 13:12:38 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table devices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `devices`;

CREATE TABLE `devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) DEFAULT NULL,
  `fridge` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table fridge_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fridge_data`;

CREATE TABLE `fridge_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fridge` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table fridge_data_types
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fridge_data_types`;

CREATE TABLE `fridge_data_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `fridge_data_types` WRITE;
/*!40000 ALTER TABLE `fridge_data_types` DISABLE KEYS */;

INSERT INTO `fridge_data_types` (`id`, `name`)
VALUES
	(1,'Temperature'),
	(2,'Door status');

/*!40000 ALTER TABLE `fridge_data_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table fridge_tokens
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fridge_tokens`;

CREATE TABLE `fridge_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `expires` timestamp NULL DEFAULT NULL,
  `fridge` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table fridge_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fridge_user`;

CREATE TABLE `fridge_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fridge_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table fridges
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fridges`;

CREATE TABLE `fridges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `fridges` WRITE;
/*!40000 ALTER TABLE `fridges` DISABLE KEYS */;

INSERT INTO `fridges` (`id`, `name`)
VALUES
	(1,'Frida'),
	(2,'Linda');

/*!40000 ALTER TABLE `fridges` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table groceries
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groceries`;

CREATE TABLE `groceries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fridge_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `expiration` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(225) DEFAULT NULL,
  `ean` bigint(20) DEFAULT NULL,
  `producer` varchar(255) DEFAULT NULL,
  `defaultExpire` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;

INSERT INTO `items` (`id`, `name`, `ean`, `producer`, `defaultExpire`)
VALUES
	(1,'Melk Tine 1L',8475636362,NULL,172800),
	(10,'Tine Økologisk Lettmelk',7038010000560,'Tine',172800),
	(11,'Carlsberg',7044610063034,NULL,1036800),
	(13,'Bonaqua',5449000130969,NULL,NULL),
	(14,'Imsdal med smak',7044610778181,NULL,NULL),
	(16,'Yogurt ',NULL,'Q-Meieriene',NULL),
	(17,'Snickers',5000159461122,'Mars',NULL),
	(18,'Läkerol Cactus',7310350104178,'Läkerol',2592000),
	(19,'Chrushed Ice White',7311250009112,'Nick and Johnny',NULL),
	(20,'Fisherman\'s Friend Extra Strong',50819126,'Lofthouse\'s',NULL),
	(21,'Passionad',7313613035523,'Brämhulst',NULL),
	(22,'Kex',7310040027688,'Cloetta',NULL),
	(23,'Fisherman\'s Friend Fresh Mint',50819140,'Lofthouse\'s',NULL);

/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(225) DEFAULT NULL,
  `password` varchar(225) DEFAULT NULL,
  `email` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
