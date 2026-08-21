-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 21, 2026 at 05:39 PM
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
-- Database: `eltrack`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(15) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('personal','business') NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `phone`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'Test User', '081234567890', 'testuser01@example.com', '$2y$10$UwxVfcfu', 'personal', '2026-08-21 14:23:58'),
(6, 'Business Test', '081234567891', 'businesstest01@example.com', '$2y$10$vtsadyp5', 'business', '2026-08-21 14:31:32'),
(7, 'Test User', '081234567890', 'testuser02@example.com', '$2y$10$gWKtF1gr5dw0M401za5w5.6WRJC.B5DjyKbV7dqJdXAyW4EBqVZxu', 'personal', '2026-08-21 15:34:13'),
(9, 'Business Test 2', '081234567892', 'businesstest02@example.com', '$2y$10$7.2iGky9Qt3CF15Ysrn2heEEE1XYNop0T5MDLYLNlaHXwWBILuOB6', 'business', '2026-08-21 15:35:25');

-- --------------------------------------------------------

--
-- Table structure for table `user_business`
--

CREATE TABLE `user_business` (
  `user_id` int(11) NOT NULL,
  `business_name` varchar(25) NOT NULL,
  `NIB` varchar(22) NOT NULL,
  `address_text` varchar(150) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `vehicle_type` enum('motorcycle','car') NOT NULL,
  `pickup` decimal(10,0) NOT NULL,
  `Opening_Time` time NOT NULL,
  `closing_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_business`
--

INSERT INTO `user_business` (`user_id`, `business_name`, `NIB`, `address_text`, `latitude`, `longitude`, `vehicle_type`, `pickup`, `Opening_Time`, `closing_time`) VALUES
(6, 'Test Recycling', '1234567890123', 'Jakarta', NULL, NULL, 'motorcycle', 5, '08:00:00', '17:00:00'),
(9, 'Test Recycling 2', '9876543210123', 'Jakarta', NULL, NULL, 'motorcycle', 5, '08:00:00', '17:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_business`
--
ALTER TABLE `user_business`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `NIB` (`NIB`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `user_business`
--
ALTER TABLE `user_business`
  ADD CONSTRAINT `user_business_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
