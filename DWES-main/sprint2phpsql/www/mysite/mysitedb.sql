/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: mysitedb
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `tComentarios`
--

DROP TABLE IF EXISTS `tComentarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tComentarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comentario` varchar(2000) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `pelicula_id` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `pelicula_id` (`pelicula_id`),
  CONSTRAINT `tComentarios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `tUsuarios` (`id`),
  CONSTRAINT `tComentarios_ibfk_2` FOREIGN KEY (`pelicula_id`) REFERENCES `tPeliculas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tComentarios`
--

LOCK TABLES `tComentarios` WRITE;
/*!40000 ALTER TABLE `tComentarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tComentarios` VALUES
(1,'Increíble película, me encantó el final',1,1,'2025-10-22 00:00:00'),
(2,'Demasiado larga pero buena historia',2,3,'2025-10-22 00:00:00'),
(3,'Los efectos de Avatar son impresionantes',3,4,'2025-10-22 00:00:00'),
(4,'Nolan es un genio, Interstellar me hizo pensar',4,2,'2025-10-22 00:00:00'),
(5,'Gladiator tiene una banda sonora espectacular',5,5,'2025-10-22 00:00:00'),
(6,'10 de 10',NULL,1,'2025-10-22 00:00:00');
/*!40000 ALTER TABLE `tComentarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tPeliculas`
--

DROP TABLE IF EXISTS `tPeliculas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tPeliculas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `url_imagen` varchar(200) DEFAULT NULL,
  `director` varchar(100) DEFAULT NULL,
  `anio` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tPeliculas`
--

LOCK TABLES `tPeliculas` WRITE;
/*!40000 ALTER TABLE `tPeliculas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tPeliculas` VALUES
(1,'Inception','https://m.media-amazon.com/images/I/912AErFSBHL._AC_UF1000,1000_QL80_.jpg','Christopher Nolan',2010),
(2,'Interstellar','https://upload.wikimedia.org/wikipedia/en/b/bc/Interstellar_film_poster.jpg','Christopher Nolan',2014),
(3,'Titanic','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQAG31iXM0ttrUA8r3hIjCv01cKGrkaE_ZvQ&s','James Cameron',1997),
(4,'Avatar','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdPWWxazFDRWSqqFRKNOI6Pk0OmB08J6gn4w&s','James Cameron',2009),
(5,'Gladiator','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrjrbE8c6jWTwlprWmk2ALNMZwLksVtSo6iw&s','Ridley Scott',2000);
/*!40000 ALTER TABLE `tPeliculas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `tUsuarios`
--

DROP TABLE IF EXISTS `tUsuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tUsuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `contraseña` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tUsuarios`
--

LOCK TABLES `tUsuarios` WRITE;
/*!40000 ALTER TABLE `tUsuarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tUsuarios` VALUES
(1,'Laura','Gómez Pérez','laura@example.com','1234'),
(2,'Carlos','Ruiz Díaz','carlos@example.com','abcd'),
(3,'Marta','Santos León','marta@example.com','qwerty'),
(4,'Pedro','López García','pedro@example.com','pass'),
(5,'Lucía','Ramírez Soto','lucia@example.com','xyz');
/*!40000 ALTER TABLE `tUsuarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-10-22 14:59:20
