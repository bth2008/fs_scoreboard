CREATE DATABASE `fs_rating_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `fs_rating_system`;
CREATE TABLE `rating_actions` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `from_user_steam_id` varchar(200) NOT NULL,
                                  `to_user_steam_id` varchar(200) NOT NULL,
                                  `amount` double NOT NULL,
                                  `date_time` datetime DEFAULT NULL,
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `user_rating` (
                               `STEAM_ID` varchar(200) NOT NULL,
                               `total_rating` int DEFAULT '100',
                               PRIMARY KEY (`STEAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

