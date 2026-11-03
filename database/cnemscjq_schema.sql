-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 03, 2026 at 08:07 AM
-- Server version: 11.4.13-MariaDB-ubu2404
-- PHP Version: 8.3.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `csflix`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(10) UNSIGNED NOT NULL,
  `reference` char(10) NOT NULL,
  `qr_token` char(32) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `movie_id` int(10) UNSIGNED NOT NULL,
  `show_date` date NOT NULL,
  `show_time` time NOT NULL,
  `cinema` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `ticket_count` tinyint(3) UNSIGNED NOT NULL,
  `seat_list` varchar(80) NOT NULL,
  `ticket_price` int(10) UNSIGNED NOT NULL,
  `snacks_total` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total` int(10) UNSIGNED NOT NULL,
  `status` enum('pending','paid','expired','cancelled','refunded') NOT NULL DEFAULT 'pending',
  `snack_status` enum('ordered','preparing','ready','sold') DEFAULT NULL,
  `snack_number` smallint(5) UNSIGNED DEFAULT NULL,
  `snack_scanned_at` datetime DEFAULT NULL,
  `snack_sold_at` datetime DEFAULT NULL,
  `paymongo_checkout_id` varchar(64) DEFAULT NULL,
  `paymongo_intent_id` varchar(64) DEFAULT NULL,
  `paymongo_card_intent_id` varchar(64) DEFAULT NULL,
  `paymongo_wallet_intent_id` varchar(64) DEFAULT NULL,
  `paymongo_payment_id` varchar(64) DEFAULT NULL,
  `paymongo_refund_id` varchar(64) DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `paid_at` datetime DEFAULT NULL,
  `scanned_at` datetime DEFAULT NULL,
  `scanned_by` int(10) UNSIGNED DEFAULT NULL,
  `refunded_at` datetime DEFAULT NULL,
  `refunded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `reference`, `qr_token`, `user_id`, `movie_id`, `show_date`, `show_time`, `cinema`, `ticket_count`, `seat_list`, `ticket_price`, `snacks_total`, `total`, `status`, `snack_status`, `snack_number`, `snack_scanned_at`, `snack_sold_at`, `paymongo_checkout_id`, `paymongo_intent_id`, `paymongo_card_intent_id`, `paymongo_wallet_intent_id`, `paymongo_payment_id`, `paymongo_refund_id`, `expires_at`, `paid_at`, `scanned_at`, `scanned_by`, `refunded_at`, `refunded_by`, `created_at`) VALUES
(348, 'CSF-M4GW5D', '4b0ebf3018a7b0b387726015e8b6dccb', 248, 1, '2026-10-18', '18:10:00', 1, 1, 'D4', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-16 18:23:00', '2026-10-16 18:15:00', '2026-10-18 18:02:00', 1, NULL, NULL, '2026-10-16 18:13:00'),
(349, 'CSF-76X9HZ', 'e4bc1ba1524c88f32ec0b1f2312b039a', 251, 1, '2026-10-18', '18:10:00', 1, 1, 'D5', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-16 18:26:00', '2026-10-16 18:18:00', '2026-10-18 18:02:00', 1, NULL, NULL, '2026-10-16 18:16:00'),
(350, 'CSF-44NZUT', 'a4cf10c2ec6e4e1293ae162d55d49aba', 255, 1, '2026-10-18', '18:10:00', 1, 1, 'D6', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-16 18:23:00', '2026-10-16 18:15:00', '2026-10-18 18:00:00', 1, NULL, NULL, '2026-10-16 18:13:00'),
(351, 'CSF-768C95', '683d9c789f3270143bebfab77300944e', 250, 2, '2026-10-19', '16:05:00', 1, 1, 'E3', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-17 16:20:00', '2026-10-17 16:12:00', '2026-10-19 15:56:00', 1, NULL, NULL, '2026-10-17 16:10:00'),
(352, 'CSF-WBGB2E', 'a075460290dd9957e0f593baa9a5f865', 252, 2, '2026-10-19', '16:05:00', 1, 1, 'E4', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-17 16:15:00', '2026-10-17 16:07:00', '2026-10-19 15:55:00', 1, NULL, NULL, '2026-10-17 16:05:00'),
(353, 'CSF-3HUJA3', 'ced3b52bfd67005181b6d1d2b0cd774c', 256, 2, '2026-10-19', '16:05:00', 1, 1, 'E5', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-17 16:19:00', '2026-10-17 16:11:00', '2026-10-19 15:56:00', 1, NULL, NULL, '2026-10-17 16:09:00'),
(354, 'CSF-SANJTY', '915168ad092bef690a40eca417b62436', 253, 3, '2026-10-17', '14:25:00', 2, 1, 'C5', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-15 14:36:00', '2026-10-15 14:28:00', '2026-10-17 14:16:00', 1, NULL, NULL, '2026-10-15 14:26:00'),
(355, 'CSF-HTY9X8', 'bc23662438827a7bce8120a4781b4c85', 257, 3, '2026-10-17', '14:25:00', 2, 1, 'C6', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-15 14:40:00', '2026-10-15 14:32:00', '2026-10-17 14:17:00', 1, NULL, NULL, '2026-10-15 14:30:00'),
(356, 'CSF-DEE2Q9', 'b5b6880b8d9b6d7d6e7151c850159d2c', 254, 7, '2026-10-20', '21:05:00', 2, 1, 'F7', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-18 21:17:00', '2026-10-18 21:09:00', '2026-10-20 20:57:00', 1, NULL, NULL, '2026-10-18 21:07:00'),
(357, 'CSF-PP2GRF', '6340cc1123743db181783c688f5097cb', 258, 7, '2026-10-20', '21:05:00', 2, 1, 'F8', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-18 21:21:00', '2026-10-18 21:13:00', '2026-10-20 20:55:00', 1, NULL, NULL, '2026-10-18 21:11:00'),
(358, 'CSF-CA6W4G', '5d9fa95454b2bd563b201003c0338bd7', 248, 2, '2026-10-22', '16:05:00', 1, 1, 'D5', 220, 0, 220, 'expired', NULL, NULL, NULL, NULL, NULL, 'pi_7ZSTBmt2FgBPK11P694ojRuL', NULL, NULL, NULL, NULL, '2026-10-22 12:42:35', NULL, NULL, NULL, NULL, NULL, '2026-10-22 12:32:35'),
(359, 'CSF-E2LJZ8', 'fa7cf8ceaeaf2e2177bf8a3580eec9ea', 248, 2, '2026-10-23', '16:05:00', 1, 1, 'B5', 220, 0, 220, 'expired', NULL, NULL, NULL, NULL, NULL, 'pi_TMs4kJZDAKEcyukpthySNr5h', NULL, 'pi_MNf29gsbdpB1U9XcUrTaS8pK', NULL, NULL, '2026-10-23 14:23:16', NULL, NULL, NULL, NULL, NULL, '2026-10-23 14:13:16'),
(360, 'CSF-UPJJLJ', '588f6d6fef3932d2294778bd4f604ccc', 248, 2, '2026-10-26', '20:10:00', 1, 1, 'B4', 220, 110, 330, 'expired', NULL, NULL, NULL, NULL, NULL, 'pi_mpPdr4gNZUMNwVNLLZc8oXjf', NULL, 'pi_cNhDvXH2nTBi9EpPVRdHg6gE', NULL, NULL, '2026-10-26 16:00:27', NULL, NULL, NULL, NULL, NULL, '2026-10-26 15:50:27'),
(361, 'CSF-KTEA52', '77f471ebb15c342eebe6cedff2ce3dba', 248, 3, '2026-10-27', '18:50:00', 2, 1, 'E7', 220, 110, 330, 'paid', 'ordered', 1, NULL, NULL, NULL, 'pi_h77rh779Aygcnf2daxVVJW4t', NULL, 'pi_mZYrSSKweqjrP2TvsUdVqVZT', 'pay_MkY7eLLmk7kT3dz9o4JDQGHW', NULL, '2026-10-27 11:55:50', '2026-10-27 11:45:59', NULL, NULL, NULL, NULL, '2026-10-27 11:45:50'),
(362, 'CSF-C7F44J', '6791a20cccccbcdc8890c6a772095d2e', 248, 2, '2026-10-27', '16:05:00', 1, 1, 'B5', 220, 110, 330, 'paid', 'ordered', 2, NULL, NULL, NULL, 'pi_275PGbsdZ9cBZr3yqx8EAbMf', NULL, 'pi_mY1jfdp3a25GMdrQeXichdT5', 'pay_3eNjLp6Roth53ubtw2MAx5kd', NULL, '2026-10-27 11:56:29', '2026-10-27 11:49:28', NULL, NULL, NULL, NULL, '2026-10-27 11:46:29'),
(363, 'CSF-VMG82H', '55ea08fe9ee811cf1b2beb24ca543344', 248, 2, '2026-10-30', '16:05:00', 1, 1, 'E5', 220, 0, 220, 'paid', NULL, NULL, NULL, NULL, NULL, 'pi_FicRXn6cntbJPzScfHJZWDjS', NULL, 'pi_PY89Bbnu8MvhtvgJejWx4NmC', 'pay_CCqAnbENrCNAWGF7xerQH7tB', NULL, '2026-10-30 00:45:01', '2026-10-30 00:35:14', NULL, NULL, NULL, NULL, '2026-10-30 00:35:01');

-- --------------------------------------------------------

--
-- Table structure for table `booking_seats`
--

CREATE TABLE `booking_seats` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `movie_id` int(10) UNSIGNED NOT NULL,
  `show_date` date NOT NULL,
  `show_time` time NOT NULL,
  `seat_code` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking_seats`
--

INSERT INTO `booking_seats` (`id`, `booking_id`, `movie_id`, `show_date`, `show_time`, `seat_code`) VALUES
(382, 348, 1, '2026-10-18', '18:10:00', 'D4'),
(383, 349, 1, '2026-10-18', '18:10:00', 'D5'),
(384, 350, 1, '2026-10-18', '18:10:00', 'D6'),
(385, 351, 2, '2026-10-19', '16:05:00', 'E3'),
(386, 352, 2, '2026-10-19', '16:05:00', 'E4'),
(387, 353, 2, '2026-10-19', '16:05:00', 'E5'),
(388, 354, 3, '2026-10-17', '14:25:00', 'C5'),
(389, 355, 3, '2026-10-17', '14:25:00', 'C6'),
(390, 356, 7, '2026-10-20', '21:05:00', 'F7'),
(391, 357, 7, '2026-10-20', '21:05:00', 'F8'),
(395, 361, 3, '2026-10-27', '18:50:00', 'E7'),
(396, 362, 2, '2026-10-27', '16:05:00', 'B5'),
(397, 363, 2, '2026-10-30', '16:05:00', 'E5');

-- --------------------------------------------------------

--
-- Table structure for table `booking_snacks`
--

CREATE TABLE `booking_snacks` (
  `booking_id` int(10) UNSIGNED NOT NULL,
  `snack_id` int(10) UNSIGNED NOT NULL,
  `quantity` tinyint(3) UNSIGNED NOT NULL,
  `unit_price` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking_snacks`
--

INSERT INTO `booking_snacks` (`booking_id`, `snack_id`, `quantity`, `unit_price`) VALUES
(360, 1, 1, 110),
(361, 1, 1, 110),
(362, 1, 1, 110);

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(120) NOT NULL,
  `title` varchar(150) NOT NULL,
  `genre` varchar(100) NOT NULL,
  `duration_minutes` smallint(5) UNSIGNED NOT NULL,
  `rating` enum('G','PG','PG-13','R-13','R-16','R-18') NOT NULL,
  `price` int(10) UNSIGNED NOT NULL,
  `status` enum('now_showing','upcoming') NOT NULL,
  `opens_on` date DEFAULT NULL,
  `ends_on` date DEFAULT NULL,
  `poster_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `slug`, `title`, `genre`, `duration_minutes`, `rating`, `price`, `status`, `opens_on`, `ends_on`, `poster_path`, `is_active`, `created_at`) VALUES
(1, 'eternal-sunshine', 'Eternal Sunshine of the Spotless Mind', 'Romance, Drama', 108, 'PG-13', 220, 'now_showing', NULL, NULL, 'assets/img/posters/eternal-sunshine.jpg', 1, '2026-09-28 01:06:42'),
(2, 'pieces-of-us', 'Pieces of Us', 'Comedy, Romance, Drama', 112, 'PG-13', 220, 'now_showing', NULL, NULL, 'assets/img/posters/Pieces-of-us.jpg', 1, '2026-09-28 01:06:42'),
(3, 'the-reckoning', 'The Reckoning', 'Action, Thriller', 122, 'R-16', 220, 'now_showing', NULL, NULL, 'assets/img/posters/The-Reckoning.jpg', 1, '2026-09-28 01:06:42'),
(4, 'movie-test', 'Movie Test', '', 0, 'R-16', 1, 'now_showing', NULL, NULL, '', 0, '2026-09-28 01:06:42'),
(5, 'hush', 'Hush', 'Horror, Thriller', 82, 'R-16', 220, 'upcoming', '2026-11-09', NULL, 'assets/img/posters/Hush.jpg', 1, '2026-09-28 01:06:42'),
(6, 'broken-of-love', 'Broken [of] Love', 'Romance, Drama', 105, 'PG-13', 220, 'upcoming', '2026-11-17', NULL, 'assets/img/posters/Broken-of-Love.jpg', 1, '2026-09-28 01:06:42'),
(7, 'maleficent', 'Maleficent', 'Dark Fantasy, Adventure, Drama', 153, 'PG', 220, 'now_showing', NULL, NULL, 'assets/img/posters/Maleficent.jpg', 1, '2026-10-02 13:34:15');

-- --------------------------------------------------------

--
-- Table structure for table `showtimes`
--

CREATE TABLE `showtimes` (
  `id` int(10) UNSIGNED NOT NULL,
  `movie_id` int(10) UNSIGNED NOT NULL,
  `cinema` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `start_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `showtimes`
--

INSERT INTO `showtimes` (`id`, `movie_id`, `cinema`, `start_time`) VALUES
(36, 2, 1, '12:00:00'),
(37, 2, 1, '16:05:00'),
(38, 2, 1, '20:10:00'),
(39, 5, 1, '22:15:00'),
(43, 3, 2, '10:00:00'),
(44, 3, 2, '14:25:00'),
(45, 3, 2, '18:50:00'),
(46, 4, 2, '12:15:00'),
(47, 4, 2, '16:40:00'),
(48, 4, 2, '21:05:00'),
(146, 1, 1, '10:00:00'),
(147, 1, 1, '14:05:00'),
(148, 1, 1, '18:10:00'),
(149, 6, 2, '12:25:00'),
(150, 6, 2, '16:50:00'),
(151, 6, 2, '21:15:00'),
(153, 7, 2, '12:15:00'),
(154, 7, 2, '16:40:00'),
(155, 7, 2, '21:05:00');

-- --------------------------------------------------------

--
-- Table structure for table `snacks`
--

CREATE TABLE `snacks` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `detail` varchar(150) NOT NULL DEFAULT '',
  `category_id` int(10) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL,
  `sort_order` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `snacks`
--

INSERT INTO `snacks` (`id`, `name`, `detail`, `category_id`, `price`, `sort_order`, `is_active`) VALUES
(1, 'Popcorn, Regular', 'Salted, 64 oz', 1, 110, 1, 1),
(2, 'Popcorn, Large', 'Cheese or Caramel, 85 oz', 1, 145, 2, 1),
(3, 'Soda', '22 oz', 2, 70, 3, 1),
(4, 'Water ', '22 oz', 2, 25, 4, 1),
(5, 'Chocolate Bar', '90 g', 3, 60, 5, 1),
(6, 'Gummy Candy', 'Assorted, 100 g', 3, 55, 6, 1),
(7, 'Solo Combo', 'Regular popcorn and regular soda', 4, 180, 7, 1),
(8, 'Barkada Combo', '2 large popcorn and 2 large sodas', 4, 480, 8, 1),
(9, 'Iced Tea', 'Lemon, 22 oz', 2, 75, 9, 1),
(10, 'Lemonade', 'Fresh, 22 oz', 2, 80, 10, 1),
(11, 'Orange Juice', '16 oz', 2, 85, 11, 1),
(12, 'Hot Coffee', 'Brewed, 12 oz', 2, 90, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `snack_categories`
--

CREATE TABLE `snack_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `sort_order` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `snack_categories`
--

INSERT INTO `snack_categories` (`id`, `name`, `sort_order`, `is_active`, `created_at`) VALUES
(1, 'Popcorn', 1, 1, '2026-10-14 15:35:55'),
(2, 'Drinks', 2, 1, '2026-10-14 15:35:55'),
(3, 'Candy', 3, 1, '2026-10-14 15:35:55'),
(4, 'Combos', 4, 1, '2026-10-14 15:35:55');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(190) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('customer','admin','scanner') NOT NULL DEFAULT 'customer',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `last_login_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `mobile`, `password_hash`, `role`, `created_at`, `last_login_at`) VALUES
(1, 'CSFlix Admin', 'admin@gmail.com', NULL, '$argon2id$v=19$m=65536,t=4,p=1$eUdrZHFzVWg2NTE1WUkzcg$zDo9ZNprzS9DY82fcQ1ll7ln13YKxPJU3HpSk9mh6Gk', 'admin', '2026-09-28 01:06:42', '2026-10-29 00:36:24'),
(248, 'Henmyr Vincent L. Tepacia', 'tepacia18@gmail.com', '09940398477', '$argon2id$v=19$m=65536,t=4,p=1$cWNBR0doR0tid3FNaXFUcA$5JORClpTcx/LNA43z1/a38Z6H0NLmRNjGAPoRtWT3HA', 'customer', '2026-10-10 12:38:04', '2026-10-30 00:34:51'),
(250, 'Samantha May Wenham', 'wsamanthamay@gmail.com', '09069739089', '$argon2id$v=19$m=65536,t=4,p=1$TGpRUldOR3dscWMyM21ENA$g7pReSb6QlZcfteeyEievNU9DS7SLg4QDKk6qC9a36M', 'customer', '2026-10-14 13:04:36', '2026-10-14 13:04:36'),
(251, 'Carl Doro-on', 'carlruizdoroon16@gmail.com', '09565575986', '$argon2id$v=19$m=65536,t=4,p=1$NFNsSHBWZ1RPcmtIQkNUeA$2OhF8lQt0famNr/NCzqe0D4ByUF/XeXx03CiXizk6kc', 'customer', '2026-10-21 20:04:37', '2026-10-21 23:47:37'),
(252, 'Mary Gwen Manos', 'cmarygwenxx@gmail.com', '09750926842', '$argon2id$v=19$m=65536,t=4,p=1$MDV0a0duaGMxaGJxQzk2RQ$b3CxMfBcHql+2TbeHreoaGKbsataDHa2yW5EBxjlP6A', 'customer', '2026-10-21 20:04:38', NULL),
(253, 'Altheo Miguel Ticon', 'altheoticon@gmail.com', '09750926842', '$argon2id$v=19$m=65536,t=4,p=1$SktEWm1HbFVFQ3hlTjJrLg$JewjIVd7M1dFKM0BqEAPLhKbc8gb7EzCSSLXD0GiG10', 'customer', '2026-10-21 20:04:38', NULL),
(254, 'Jay Moen Redula', 'jaysirfilms@gmail.com', '09933915216', '$argon2id$v=19$m=65536,t=4,p=1$NUNPRUFNWFR5N0R2SXYwSg$ZtvpSB6CxIsAOXgXfXhRWZXb8zHHw7cPZZlwlFBqwCE', 'customer', '2026-10-21 20:04:38', NULL),
(255, 'Jan Nina Dalogdog', 'janninadalogdog@gmail.com', '09533176308', '$argon2id$v=19$m=65536,t=4,p=1$UG1pZm1VbHRmdUFPdldtdQ$yQ7qncO7w3rBheO1CufaXeGh+a8b/r5dy9zPaU7+dxA', 'customer', '2026-10-21 20:14:08', NULL),
(256, 'Gem Kristly Go', 'kristlygocadz.gem@gmail.com', '09707218599', '$argon2id$v=19$m=65536,t=4,p=1$ZkFvcllFWWgyZC93UWFaNw$JZCe8Qd3tNa6MJamSZlLhQLAdI3oBSNR8JSrIvxqKWM', 'customer', '2026-10-21 20:14:08', NULL),
(257, 'Cristianery Khim Guzman', 'gzcristian031706@gmail.com', '09702869877', '$argon2id$v=19$m=65536,t=4,p=1$TmhmbVRqUEI2ajZBaTYvVA$nDqzbSnzlQ02idXBjxXGAB/yyjiiU6RfaFomaaZi1es', 'customer', '2026-10-21 20:14:08', NULL),
(258, 'Crist Sean Salac', 'seansalac63@gmail.com', '09690956091', '$argon2id$v=19$m=65536,t=4,p=1$d29XSDYyYmlHWEx1UVZBbg$GceBBupAQwIOk+NAwfwvZ1RmOI64O+K2tzo11XxMBlc', 'customer', '2026-10-21 20:14:08', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_bookings_reference` (`reference`),
  ADD UNIQUE KEY `uq_bookings_checkout` (`paymongo_checkout_id`),
  ADD UNIQUE KEY `uq_bookings_intent` (`paymongo_intent_id`),
  ADD UNIQUE KEY `uq_bookings_card_intent` (`paymongo_card_intent_id`),
  ADD UNIQUE KEY `uq_bookings_wallet_intent` (`paymongo_wallet_intent_id`),
  ADD KEY `idx_bookings_user` (`user_id`,`created_at`),
  ADD KEY `idx_bookings_status` (`status`,`expires_at`),
  ADD KEY `idx_bookings_snacks` (`status`,`snack_status`),
  ADD KEY `fk_bookings_movie` (`movie_id`),
  ADD KEY `fk_bookings_scanned_by` (`scanned_by`),
  ADD KEY `fk_bookings_refunded_by` (`refunded_by`);

--
-- Indexes for table `booking_seats`
--
ALTER TABLE `booking_seats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_seat_per_showing` (`movie_id`,`show_date`,`show_time`,`seat_code`),
  ADD KEY `idx_booking_seats_booking` (`booking_id`);

--
-- Indexes for table `booking_snacks`
--
ALTER TABLE `booking_snacks`
  ADD PRIMARY KEY (`booking_id`,`snack_id`),
  ADD KEY `fk_booking_snacks_snack` (`snack_id`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_movies_slug` (`slug`),
  ADD KEY `idx_movies_listing` (`is_active`,`status`);

--
-- Indexes for table `showtimes`
--
ALTER TABLE `showtimes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_showtimes` (`movie_id`,`start_time`);

--
-- Indexes for table `snacks`
--
ALTER TABLE `snacks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_snacks_category` (`category_id`,`is_active`,`sort_order`);

--
-- Indexes for table `snack_categories`
--
ALTER TABLE `snack_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=364;

--
-- AUTO_INCREMENT for table `booking_seats`
--
ALTER TABLE `booking_seats`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=398;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `showtimes`
--
ALTER TABLE `showtimes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `snacks`
--
ALTER TABLE `snacks`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `snack_categories`
--
ALTER TABLE `snack_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=260;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_bookings_movie` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`),
  ADD CONSTRAINT `fk_bookings_refunded_by` FOREIGN KEY (`refunded_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_bookings_scanned_by` FOREIGN KEY (`scanned_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `booking_seats`
--
ALTER TABLE `booking_seats`
  ADD CONSTRAINT `fk_booking_seats_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_snacks`
--
ALTER TABLE `booking_snacks`
  ADD CONSTRAINT `fk_booking_snacks_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_booking_snacks_snack` FOREIGN KEY (`snack_id`) REFERENCES `snacks` (`id`);

--
-- Constraints for table `showtimes`
--
ALTER TABLE `showtimes`
  ADD CONSTRAINT `fk_showtimes_movie` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `snacks`
--
ALTER TABLE `snacks`
  ADD CONSTRAINT `fk_snacks_category` FOREIGN KEY (`category_id`) REFERENCES `snack_categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
