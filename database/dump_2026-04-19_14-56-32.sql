-- MySQL dump 10.13  Distrib 8.4.8, for macos15 (x86_64)
--
-- Host: localhost    Database: Oblig3_1
-- ------------------------------------------------------
-- Server version	8.4.8

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
-- Table structure for table `Kunde`
--

DROP TABLE IF EXISTS `Kunde`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Kunde` (
  `KundeNr` int NOT NULL,
  `Kundenavn` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `KundeType` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `KundeEpost` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LeveringAdrGate` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LeveringAdrGateNr` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LeveringAdrPostNr` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LeveringAdrPoststed` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FakturaAdrGate` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FakturaAdrGateNr` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FakturaAdrPostNr` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `FakturaAdrPoststed` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`KundeNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Kunde`
--

LOCK TABLES `Kunde` WRITE;
/*!40000 ALTER TABLE `Kunde` DISABLE KEYS */;
INSERT INTO `Kunde` VALUES (8988,'Murer Pedersen ANS','Bedrift','mu_pe@ånnlain.no','Murergata','2','9000','Tromsø','Murergata','1','9000','Tromsø'),(10002,'Grøft og Kant AS','Bedrift','gm@uuiitt.nu','Lillegata','233','8000','Bodø','Øvregata','332','8000','Bodø'),(11122,'Lokalbyggern AS','Bedrift','lok_bygg@no.no','Veien','124','8000','Bodø','Nedreveien','223','8000','Bodø'),(20011,'Anders Andersen','Privat','aa@post.no','Fjelltoppen','3','8500','Narvik','Fjelltoppen','4','8500','Narvik');
/*!40000 ALTER TABLE `Kunde` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Kundebehandler`
--

DROP TABLE IF EXISTS `Kundebehandler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Kundebehandler` (
  `KundebehandlerID` int NOT NULL,
  `KundebehandlerNavn` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `KundebehandlerTlf` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`KundebehandlerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Kundebehandler`
--

LOCK TABLES `Kundebehandler` WRITE;
/*!40000 ALTER TABLE `Kundebehandler` DISABLE KEYS */;
INSERT INTO `Kundebehandler` VALUES (1,'Hilde Pettersen','10090999'),(2,'Berit Hansen','10191999');
/*!40000 ALTER TABLE `Kundebehandler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Login`
--

DROP TABLE IF EXISTS `Login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Login` (
  `LoginID` int NOT NULL AUTO_INCREMENT,
  `Brukernavn` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PassordHash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `KundebehandlerID` int NOT NULL,
  PRIMARY KEY (`LoginID`),
  UNIQUE KEY `Brukernavn` (`Brukernavn`),
  UNIQUE KEY `KundebehandlerID` (`KundebehandlerID`),
  CONSTRAINT `fk_login_kundebehandler` FOREIGN KEY (`KundebehandlerID`) REFERENCES `Kundebehandler` (`KundebehandlerID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Login`
--

LOCK TABLES `Login` WRITE;
/*!40000 ALTER TABLE `Login` DISABLE KEYS */;
INSERT INTO `Login` VALUES (1,'hilde','scrypt:32768:8:1$C40TR1SPSIUIXSlM$9274cb61b496a1f69cce50ebfdcf3c449250ba832655ab51509fbebacd09016f2211ee722158d208f908c063fdf589111ecf84f52699c1bd7a3ace1b8f41cba7',1),(2,'berit','scrypt:32768:8:1$Ne0CfyyYweaJLcpV$65334ca94153abd3fa6ab8f9ec6f79d81958f57bde05fff8bfd1717aa086c451df68886bda76dd3806eb8a3f7a82b314482438b48746de3700b731fc4986811b',2);
/*!40000 ALTER TABLE `Login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utleie`
--

DROP TABLE IF EXISTS `Utleie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utleie` (
  `UtleieID` int NOT NULL AUTO_INCREMENT,
  `UtleidDato` date NOT NULL,
  `InnlevertDato` date DEFAULT NULL,
  `Betalingsmate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LeveresKunde` tinyint DEFAULT NULL,
  `LeveringsKostnad` decimal(6,2) DEFAULT NULL,
  `UtstyrsMal_ID` int NOT NULL,
  `InstansID` int NOT NULL,
  `KundebehandlerID` int NOT NULL,
  `KundeNr` int NOT NULL,
  PRIMARY KEY (`UtleieID`),
  KEY `fk_utleie_utstyr` (`UtstyrsMal_ID`,`InstansID`),
  KEY `fk_utleie_kundebehandler` (`KundebehandlerID`),
  KEY `fk_utleie_kunde` (`KundeNr`),
  CONSTRAINT `fk_utleie_kunde` FOREIGN KEY (`KundeNr`) REFERENCES `Kunde` (`KundeNr`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_utleie_kundebehandler` FOREIGN KEY (`KundebehandlerID`) REFERENCES `Kundebehandler` (`KundebehandlerID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_utleie_utstyr` FOREIGN KEY (`UtstyrsMal_ID`, `InstansID`) REFERENCES `Utstyr` (`UtstyrsMal_ID`, `InstansID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utleie`
--

LOCK TABLES `Utleie` WRITE;
/*!40000 ALTER TABLE `Utleie` DISABLE KEYS */;
INSERT INTO `Utleie` VALUES (1,'2019-02-01','2019-02-03','Kort',0,0.00,234,1,2,11122),(2,'2019-03-05','2019-03-06','Kontant',0,0.00,233,2,2,20011),(3,'2020-02-04','2020-02-10','Vipps',1,200.00,7654,1,2,8988),(4,'2021-02-01',NULL,'Kort',1,150.00,233,1,1,20011),(5,'2021-02-05','2021-02-08','Kontant',1,500.00,1001,1,1,10002),(6,'2021-02-05',NULL,'Kort',0,0.00,7653,1,2,11122);
/*!40000 ALTER TABLE `Utleie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utstyr`
--

DROP TABLE IF EXISTS `Utstyr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utstyr` (
  `UtstyrsMal_ID` int NOT NULL,
  `InstansID` int NOT NULL,
  `UtstyrSistVedlikeholdtDato` date DEFAULT NULL,
  `NesteVedlikehold` date DEFAULT NULL,
  PRIMARY KEY (`UtstyrsMal_ID`,`InstansID`),
  CONSTRAINT `fk_utstyr_utstyrsmal` FOREIGN KEY (`UtstyrsMal_ID`) REFERENCES `UtstyrsMal` (`UtstyrsMal_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utstyr`
--

LOCK TABLES `Utstyr` WRITE;
/*!40000 ALTER TABLE `Utstyr` DISABLE KEYS */;
INSERT INTO `Utstyr` VALUES (233,1,'2018-04-03','2021-04-03'),(233,2,'2017-01-02','2022-01-02'),(234,1,'2021-02-10','2022-02-10'),(1001,1,'2019-09-01','2022-09-01'),(7653,1,'2016-12-11','2021-12-11'),(7654,1,'2019-03-20','2024-03-20');
/*!40000 ALTER TABLE `Utstyr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UtstyrsMal`
--

DROP TABLE IF EXISTS `UtstyrsMal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UtstyrsMal` (
  `UtstyrsMal_ID` int NOT NULL,
  `UtstyrsMerke` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UtstyrsModell` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UtstyrsType` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Kategori` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `UtstyrsBeskrivelse` text COLLATE utf8mb4_unicode_ci,
  `LeieprisDogn` decimal(10,2) NOT NULL,
  `AntallUtstyr` int DEFAULT NULL,
  `AntallPaLager` int DEFAULT NULL,
  PRIMARY KEY (`UtstyrsMal_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UtstyrsMal`
--

LOCK TABLES `UtstyrsMal` WRITE;
/*!40000 ALTER TABLE `UtstyrsMal` DISABLE KEYS */;
INSERT INTO `UtstyrsMal` VALUES (233,'Stanley','Vento 6L','Kompressor','Lette maskiner','Liten og hendig, med en motor på 1,5HK. Regulerbart trykk opp till 8bar, 180L luft i minuttet.',79.00,10,4),(234,'ESSVE','Coil CN-15-65','Spikerpistol','Lette maskiner','ESSVE Coilpistol beregnet for spikring av bjelkelag, reisverk, kledning, utforinger, panel, sponplater m.m.',100.00,50,45),(1001,'Hitachi','ZX10U-6','Minigraver','Tunge maskiner','Minigraveren ZX10U-6 fra Hitachi er vår minste minigraver og er laget for bruk på trange og små plasser',1200.00,1,0),(7653,'Haki Stilas','150','Stilas','Annleggsutstyr','Stilas på ca 150 kvadratmeter.',350.00,2,1),(7654,'Atika','130l 600w','Sementblander','Annleggsutstyr','Atika betongblander med kapasitet på 130 l og 600 W. Bruker 230 V. IP44',230.00,8,4);
/*!40000 ALTER TABLE `UtstyrsMal` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-19 14:56:32
