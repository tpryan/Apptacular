-- Connecting to localhost...
-- Retrieving table structure for table author...
-- Sending SELECT query...
-- Retrieving rows...
-- MySQL dump 10.13  Distrib 5.1.30, for apple-darwin9.5.0 (i386)
--
-- Host: localhost    Database: apptacular_blog
-- ------------------------------------------------------
-- Server version	5.1.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES (1,'Terrence','Ryan ','terry@terrenceryan.com','2009-11-25 12:00:00','2009-12-14 11:07:28',1,'1976-12-19'),(2,'Earl','Ragefest','earl@ragefest','2009-11-25 13:11:40','2009-11-25 13:11:40',0,'1976-12-19'),(3,'Adam','Lehman','adam@adrocknapohbia.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1978-10-26'),(4,'Ryan','Stewart','ryan@ryanstewart.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1980-01-01'),(5,'Kevin','Hoyt','kevin@kevinhoyt.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1975-01-01'),(6,'Serge','Jespers','serge@webkitchen.be','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1975-01-01'),(7,'Ben','Forta','ben@forta.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1970-01-01'),(8,'Lee','Brimlowe','lee@brimlow.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01'),(9,'Ted','Patrick','ted@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01'),(10,'Andrew','Shorten','ashorten@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01'),(11,'Greg','Wilson','gwilson@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',1,'1970-01-01'),(12,'Danny','Dura','ddura@adobe.com','2009-11-25 12:18:16','2009-11-25 12:18:16',0,'1975-01-01');
-- Retrieving table structure for table comment...
-- Sending SELECT query...
-- Retrieving rows...
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,1,'<p>ROOOOOOOAAAARRRRRR!</p>','Earl','earl@ragefest.com','http://www.earl.com','2009-11-25 12:00:00','2009-12-08 10:38:17'),(2,2,'<p>I agree, but I am you, so I better.</p>','Terrence P Ryan','terrence.p.ryan@gmail.com','http://terrenceryan.com','2009-11-25 21:58:04','2009-12-08 10:37:58'),(3,3,'<p>I\'d rather it be Flaming Labala. </p>','Terrence Ryan','terry@numtopia.com','http://terrenceryan.com','2009-12-07 19:14:23','2009-12-08 10:37:41'),(4,1,'<p>I totally and whole heartedly agree</p>','Terrence P Ryan','terrence.p.ryan@gmail.com','http://terrenceryan.com','2009-12-09 09:00:08','2009-12-09 09:00:08');
-- Retrieving table structure for table post...
-- Sending SELECT query...
-- Retrieving rows...
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (1,'ColdFusion Builder Rocks','<p>It\'s awesome.&nbsp; It integrates with Flex Builder.&nbsp; I once saw it lift a burning car off it\'s injured son.&nbsp; It\'s asymptotically approaching infinity.</p>','2009-11-25 16:23:31','2009-12-14 11:03:37',1),(2,'ColdFusion 9 is Awesome','<p>Yeah, I said it.&nbsp; So what. It is. </p>','2009-11-25 17:24:15','2009-12-08 10:36:08',1),(3,'Flex 4 is going to be a game changer','<p>And that game will be &quot;Yahtzee.&quot;</p>','2009-12-07 19:13:30','2009-12-08 10:36:54',1);
-- Retrieving table structure for table tag...
-- Sending SELECT query...
-- Retrieving rows...
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tag` (
  `tagid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `createdOn` datetime DEFAULT NULL,
  `updatedOn` datetime DEFAULT NULL,
  PRIMARY KEY (`tagid`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (1,'ColdFusion','2009-12-07 12:45:55','2009-12-07 12:45:55'),(2,'Flex','2009-12-07 12:46:04','2009-12-07 12:46:04'),(3,'Flash Builder','2009-12-07 12:46:14','2009-12-07 12:46:14'),(4,'ColdFusion Builder','2009-12-07 12:46:23','2009-12-07 12:46:23'),(5,'Flash','2009-12-15 14:59:07','2009-12-15 14:59:07'),(6,'Java','2009-12-15 15:20:58','2009-12-15 15:20:58'),(7,'Higher Education','2009-12-16 11:33:27','2009-12-16 11:33:27'),(8,'MySQL','2009-12-16 11:33:46','2009-12-16 11:33:46'),(9,'Code Generation','2009-12-16 11:33:58','2009-12-16 11:33:58'),(10,'Apache Derby','2009-12-16 11:34:29','2009-12-16 11:34:29'),(11,'Flash Catalyst','2009-12-16 11:35:21','2009-12-16 11:35:21'),(12,'Evangelist','2009-12-16 11:36:16','2009-12-16 11:36:16'),(13,'AIR','2009-12-16 11:36:44','2009-12-16 11:36:44'),(14,'AIR with JavaScript','2009-12-16 11:37:04','2009-12-16 11:37:04');
-- Retrieving table structure for table tagToAuthor...
-- Sending SELECT query...
-- Retrieving rows...
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagToAuthor`
--

DROP TABLE IF EXISTS `tagToAuthor`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tagToAuthor` (
  `tagID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `authorID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`tagID`,`authorID`),
  KEY `FK_tagToAuthor_author` (`authorID`),
  CONSTRAINT `FK_tagToAuthor_author` FOREIGN KEY (`authorID`) REFERENCES `author` (`authorID`),
  CONSTRAINT `FK_tagToAuthor_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagid`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tagToAuthor`
--

LOCK TABLES `tagToAuthor` WRITE;
/*!40000 ALTER TABLE `tagToAuthor` DISABLE KEYS */;
INSERT INTO `tagToAuthor` VALUES (1,1),(2,1),(3,1),(4,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(12,2),(13,2),(1,3),(4,3),(12,3),(13,3),(11,4),(12,4),(13,4),(11,5),(12,5),(13,5),(14,5),(11,6),(12,6),(13,6),(12,7),(13,7),(12,8),(13,8),(12,9),(13,9),(11,10),(12,10),(13,10),(12,11),(13,11),(12,12),(13,12);
-- Retrieving table structure for table tagToPost...
-- Sending SELECT query...
-- Retrieving rows...
/*!40000 ALTER TABLE `tagToAuthor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tagToPost`
--

DROP TABLE IF EXISTS `tagToPost`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tagToPost` (
  `tagID` int(10) unsigned NOT NULL,
  `postID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`postID`,`tagID`),
  KEY `FK_tagToPost_tag` (`tagID`),
  CONSTRAINT `FK_tagToPost_post` FOREIGN KEY (`postID`) REFERENCES `post` (`postID`),
  CONSTRAINT `FK_tagToPost_tag` FOREIGN KEY (`tagID`) REFERENCES `tag` (`tagid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tagToPost`
--

LOCK TABLES `tagToPost` WRITE;
/*!40000 ALTER TABLE `tagToPost` DISABLE KEYS */;
INSERT INTO `tagToPost` VALUES (1,2),(2,3),(3,1),(3,3),(4,1),(4,3);
/*!40000 ALTER TABLE `tagToPost` ENABLE KEYS */;
UNLOCK TABLES;
-- Disconnecting from localhost...
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-12-24 21:47:31
