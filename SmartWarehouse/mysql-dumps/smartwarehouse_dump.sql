-- MySQL dump 10.13  Distrib 8.3.0, for Linux (aarch64)
--
-- Host: localhost    Database: smartwarehouse
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `order_header`
--

DROP TABLE IF EXISTS `order_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_header` (
  `id` int NOT NULL,
  `nominal_price` int NOT NULL,
  `actual_price` int NOT NULL,
  `delivery_status` tinyint DEFAULT NULL,
  `datetime` varchar(50) NOT NULL,
  `address` varchar(200) NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_header`
--

LOCK TABLES `order_header` WRITE;
/*!40000 ALTER TABLE `order_header` DISABLE KEYS */;
INSERT INTO `order_header` VALUES (24098001,2200,2000,2,'2024-04-07T08:09:27.410Z','Singapore 570407',103.834051,1.363462),(24098002,19000,18000,2,'2024-04-07T08:11:12.253Z','Singapore Zoo, Singapore',103.793023,1.4043485);
/*!40000 ALTER TABLE `order_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `item_id` int NOT NULL,
  `header_id` int NOT NULL,
  `price` int NOT NULL,
  `quantity` int NOT NULL,
  `symbol` varchar(20) NOT NULL,
  `total_price` int NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `header_id` (`header_id`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`header_id`) REFERENCES `order_header` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,24098002,1000,10,'Kg',10000),(2,24098002,900,10,'Kg',9000),(3,24098001,2000,1,'pcs',2000),(4,24098001,200,1,'pcs',200);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` tinyint DEFAULT NULL,
  `price` int NOT NULL,
  `quantity` int NOT NULL,
  `symbol` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Apple',1,1000,9980,'Kg'),(2,'Pineapple',1,900,980,'Kg'),(3,'apple-package',0,2000,99,'pcs'),(4,'banana-package',0,200,999,'pcs'),(5,'banana',1,200,10000,'kg');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_task`
--

DROP TABLE IF EXISTS `sub_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_task` (
  `order_id` int NOT NULL,
  `task_id` int NOT NULL,
  `address` varchar(200) NOT NULL,
  `status` tinyint DEFAULT NULL,
  `sequence` int NOT NULL,
  `longitude` double NOT NULL,
  `latitude` double NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `sub_task_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task_header` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_task`
--

LOCK TABLES `sub_task` WRITE;
/*!40000 ALTER TABLE `sub_task` DISABLE KEYS */;
INSERT INTO `sub_task` VALUES (24098001,1712477520,'Singapore 570407',2,1,103.834051,1.363462),(24098002,1712477520,'Singapore Zoo, Singapore',2,2,103.793023,1.4043485),(1712477520,1712477520,'Nanyang Link, Nanyang Technological University, Wee Kim Wee School of Communication and Information, Singapore',2,0,103.6799623,1.3421965);
/*!40000 ALTER TABLE `sub_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_header`
--

DROP TABLE IF EXISTS `task_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_header` (
  `id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `status` tinyint DEFAULT NULL,
  `decision` tinyint DEFAULT NULL,
  `need_return` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_header`
--

LOCK TABLES `task_header` WRITE;
/*!40000 ALTER TABLE `task_header` DISABLE KEYS */;
INSERT INTO `task_header` VALUES (1712477520,'2024-04-09-task1',2,0,1);
/*!40000 ALTER TABLE `task_header` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-07  8:14:08
