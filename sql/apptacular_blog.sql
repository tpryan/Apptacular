-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.1.44


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,MYSQL323' */;


--
-- Create schema apptacular_blog
--

CREATE DATABASE IF NOT EXISTS apptacular_blog;
USE apptacular_blog;

--
-- Definition of table `author`
--

DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `authorID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `createdOn` datetime NOT NULL,
  `updatedOn` datetime NOT NULL,
  `isEditor` tinyint(1) NOT NULL,
  `dob` date NOT NULL,
  PRIMARY KEY (`authorID`)
) TYPE=InnoDB AUTO_INCREMENT=13;

--
-- Dumping data for table `author`
--

/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (1,'Terrence','Ryan ','terry@terrenceryan.com','2009-11-25 12:00:00','2009-12-14 11:07:28',1,'1976-12-19');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (2,'Earl','Ragefest','earl@ragefest','2009-11-25 13:11:40','2009-11-25 13:11:40',0,'1976-12-19');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (3,'Adam','Lehman','adam@adrocknapohbia.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1978-10-26');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (4,'Ryan','Stewart','ryan@ryanstewart.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1980-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (5,'Kevin','Hoyt','kevin@kevinhoyt.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1975-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (6,'Serge','Jespers','serge@webkitchen.be','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1975-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (7,'Ben','Forta','ben@forta.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1970-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (8,'Lee','Brimlowe','lee@brimlow.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (9,'Ted','Patrick','ted@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (10,'Andrew','Shorten','ashorten@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (11,'Greg','Wilson','gwilson@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1970-01-01');
INSERT INTO `author` (`authorID`,`firstName`,`lastName`,`email`,`createdOn`,`updatedOn`,`isEditor`,`dob`) VALUES 
  (12,'Danny','Dura','ddura@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01');
/*!40000 ALTER TABLE `author` ENABLE KEYS */;


--
-- Definition of table `comment`
--

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `commentID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `postID` int(10) unsigned NOT NULL,
  `body` text,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `website` varchar(255) NOT NULL,
  `createdOn` datetime NOT NULL,
  `updatedOn` datetime NOT NULL,
  PRIMARY KEY (`commentID`),
  KEY `FK_comment_post` (`postID`),
  CONSTRAINT `FK_comment_post` FOREIGN KEY (`postID`) REFERENCES `post` (`postID`)
) TYPE=InnoDB AUTO_INCREMENT=5;

--
-- Dumping data for table `comment`
--

/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` (`commentID`,`postID`,`body`,`name`,`email`,`website`,`createdOn`,`updatedOn`) VALUES 
  (1,1,'<p>ROOOOOOOAAAARRRRRR!</p>','Earl','earl@ragefest.com','http://www.earl.com','2009-11-25 12:00:00','2009-12-08 10:38:17');
INSERT INTO `comment` (`commentID`,`postID`,`body`,`name`,`email`,`website`,`createdOn`,`updatedOn`) VALUES 
  (2,2,'<p>I agree, but I am you, so I better.</p>','Terrence P Ryan','terrence.p.ryan@gmail.com','http://terrenceryan.com','2009-11-25 21:58:04','2009-12-08 10:37:58');
INSERT INTO `comment` (`commentID`,`postID`,`body`,`name`,`email`,`website`,`createdOn`,`updatedOn`) VALUES 
  (3,3,'<p>I\'d rather it be Flaming Labala. </p>','Terrence Ryan','terry@numtopia.com','http://terrenceryan.com','2009-12-07 19:14:23','2009-12-08 10:37:41');
INSERT INTO `comment` (`commentID`,`postID`,`body`,`name`,`email`,`website`,`createdOn`,`updatedOn`) VALUES 
  (4,1,'<p>I totally and whole heartedly agree</p>','Terrence P Ryan','terrence.p.ryan@gmail.com','http://terrenceryan.com','2009-12-09 09:00:08','2009-12-09 09:00:08');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;


--
-- Definition of table `post`
--

DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `postID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `createdOn` datetime NOT NULL,
  `updatedOn` datetime NOT NULL,
  `authorID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`postID`),
  KEY `FK_post_author` (`authorID`),
  CONSTRAINT `FK_post_author` FOREIGN KEY (`authorID`) REFERENCES `author` (`authorID`)
) TYPE=InnoDB AUTO_INCREMENT=4;

--
-- Dumping data for table `post`
--

/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` (`postID`,`title`,`body`,`createdOn`,`updatedOn`,`authorID`) VALUES 
  (1,'ColdFusion Builder Rocks','<p>It\'s awesome.&nbsp; It integrates with Flex Builder.&nbsp; I once saw it lift a burning car off it\'s injured son.&nbsp; It\'s asymptotically approaching infinity.</p>','2009-11-25 16:23:31','2009-12-14 11:03:37',1);
INSERT INTO `post` (`postID`,`title`,`body`,`createdOn`,`updatedOn`,`authorID`) VALUES 
  (2,'ColdFusion 9 is Awesome','<p>Yeah, I said it.&nbsp; So what. It is. </p>','2009-11-25 17:24:15','2009-12-08 10:36:08',1);
INSERT INTO `post` (`postID`,`title`,`body`,`createdOn`,`updatedOn`,`authorID`) VALUES 
  (3,'Flex 4 is going to be a game changer','<p>And that game will be &quot;Yahtzee.&quot;</p>','2009-12-07 19:13:30','2009-12-08 10:36:54',1);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;


--
-- Definition of table `tag`
--

DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `tagid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `createdOn` datetime DEFAULT NULL,
  `updatedOn` datetime DEFAULT NULL,
  PRIMARY KEY (`tagid`)
) TYPE=InnoDB AUTO_INCREMENT=15 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `tag`
--

/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (1,'ColdFusion','2009-12-07 12:45:55','2009-12-07 12:45:55');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (2,'Flex','2009-12-07 12:46:04','2009-12-07 12:46:04');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (3,'Flash Builder','2009-12-07 12:46:14','2009-12-07 12:46:14');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (4,'ColdFusion Builder','2009-12-07 12:46:23','2009-12-07 12:46:23');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (5,'Flash','2009-12-15 14:59:07','2009-12-15 14:59:07');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (6,'Java','2009-12-15 15:20:58','2009-12-15 15:20:58');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (7,'Higher Education','2009-12-16 11:33:27','2009-12-16 11:33:27');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (8,'MySQL','2009-12-16 11:33:46','2009-12-16 11:33:46');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (9,'Code Generation','2009-12-16 11:33:58','2009-12-16 11:33:58');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (10,'Apache Derby','2009-12-16 11:34:29','2009-12-16 11:34:29');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (11,'Flash Catalyst','2009-12-16 11:35:21','2009-12-16 11:35:21');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (12,'Evangelist','2009-12-16 11:36:16','2009-12-16 11:36:16');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (13,'AIR','2009-12-16 11:36:44','2009-12-16 11:36:44');
INSERT INTO `tag` (`tagid`,`name`,`createdOn`,`updatedOn`) VALUES 
  (14,'AIR with JavaScript','2009-12-16 11:37:04','2009-12-16 11:37:04');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;


--
-- Definition of table `tagToAuthor`
--

DROP TABLE IF EXISTS `tagToAuthor`;
CREATE TABLE `tagToAuthor` (
  `tagID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `authorID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`tagID`,`authorID`),
  KEY `FK_tagToAuthor_author` (`authorID`),
  CONSTRAINT `FK_tagToAuthor_author` FOREIGN KEY (`authorID`) REFERENCES `author` (`authorID`),
  CONSTRAINT `FK_tagToAuthor_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagid`)
) TYPE=InnoDB AUTO_INCREMENT=15;

--
-- Dumping data for table `tagToAuthor`
--

/*!40000 ALTER TABLE `tagToAuthor` DISABLE KEYS */;
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (1,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (2,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (3,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (4,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (7,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (8,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (9,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (10,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (11,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (14,1);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,2);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,2);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (1,3);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (4,3);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,3);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,3);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (11,4);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,4);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,4);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (11,5);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,5);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,5);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (14,5);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (11,6);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,6);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,6);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,7);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,7);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,8);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,8);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,9);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,9);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (11,10);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,10);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,10);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,11);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,11);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (12,12);
INSERT INTO `tagToAuthor` (`tagID`,`authorID`) VALUES 
  (13,12);
/*!40000 ALTER TABLE `tagToAuthor` ENABLE KEYS */;


--
-- Definition of table `tagToPost`
--

DROP TABLE IF EXISTS `tagToPost`;
CREATE TABLE `tagToPost` (
  `tagID` int(10) unsigned NOT NULL,
  `postID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`postID`,`tagID`),
  KEY `FK_tagToPost_tag` (`tagID`),
  CONSTRAINT `FK_tagToPost_post` FOREIGN KEY (`postID`) REFERENCES `post` (`postID`),
  CONSTRAINT `FK_tagToPost_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagid`)
) TYPE=InnoDB;

--
-- Dumping data for table `tagToPost`
--

/*!40000 ALTER TABLE `tagToPost` DISABLE KEYS */;
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (1,2);
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (2,3);
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (3,1);
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (3,3);
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (4,1);
INSERT INTO `tagToPost` (`tagID`,`postID`) VALUES 
  (4,3);
/*!40000 ALTER TABLE `tagToPost` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
