-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 28, 2026 at 04:15 PM
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
-- Database: `al_amanah_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` int(10) UNSIGNED DEFAULT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `created_at`) VALUES
(1, 1, 'create', 'users', 2, NULL, '{\"name\":\"AAA\",\"email\":\"A@g.com\",\"role_id\":4,\"designation\":null,\"updated_at\":\"2026-08-22T02:06:34.000000Z\",\"created_at\":\"2026-08-22T02:06:34.000000Z\",\"id\":2}', '127.0.0.1', '2026-08-22 02:06:34'),
(2, 1, 'create', 'users', 3, NULL, '{\"name\":\"AAAAAAAAA\",\"email\":\"AA@g.com\",\"role_id\":2,\"designation\":\"ASCC\",\"updated_at\":\"2026-08-22T02:13:13.000000Z\",\"created_at\":\"2026-08-22T02:13:13.000000Z\",\"id\":3}', '127.0.0.1', '2026-08-22 02:13:13'),
(3, 1, 'update', 'users', 3, '{\"id\":3,\"role_id\":2,\"name\":\"AAAAAAAAA\",\"email\":\"AA@g.com\",\"designation\":\"ASCC\",\"is_active\":true,\"created_at\":\"2026-08-22T02:13:13.000000Z\",\"updated_at\":\"2026-08-22T02:13:13.000000Z\",\"deleted_at\":null}', '{\"id\":3,\"role_id\":2,\"name\":\"AAAAAAAAA\",\"email\":\"AA@g.com\",\"designation\":\"ASCC\",\"is_active\":true,\"created_at\":\"2026-08-22T02:13:13.000000Z\",\"updated_at\":\"2026-08-22T02:13:13.000000Z\",\"deleted_at\":null}', '127.0.0.1', '2026-08-22 02:13:21'),
(4, 1, 'update', 'users', 3, '{\"id\":3,\"role_id\":2,\"name\":\"AAAAAAAAA\",\"email\":\"AA@g.com\",\"designation\":\"ASCC\",\"is_active\":true,\"created_at\":\"2026-08-22T02:13:13.000000Z\",\"updated_at\":\"2026-08-22T02:13:13.000000Z\",\"deleted_at\":null}', '{\"id\":3,\"role_id\":2,\"name\":\"AAAAAAAAA\",\"email\":\"AA@g.com\",\"designation\":\"ASCC\",\"is_active\":true,\"created_at\":\"2026-08-22T02:13:13.000000Z\",\"updated_at\":\"2026-08-22T02:13:13.000000Z\",\"deleted_at\":null}', '127.0.0.1', '2026-08-22 02:20:48'),
(5, 1, 'create', 'users', 4, NULL, '{\"name\":\"ACC\",\"email\":\"AC@g.com\",\"role_id\":3,\"designation\":null,\"updated_at\":\"2026-08-22T02:30:31.000000Z\",\"created_at\":\"2026-08-22T02:30:31.000000Z\",\"id\":4}', '127.0.0.1', '2026-08-22 02:30:31'),
(6, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":1,\"amount\":2000}', '127.0.0.1', '2026-08-22 14:10:52'),
(7, 1, 'collect_payment', 'transactions', 2, '{\"status\":\"pending\"}', '{\"id\":2,\"member_id\":2,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260823-00002\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"paid\",\"month\":\"January 2026\",\"transaction_date\":\"2026-08-23T00:00:00.000000Z\",\"description\":\"hi - Ref: sdvsdvs | Note: sdvdsvsd\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_2_1787463390_6a8a86de4fcc7.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-23 05:36:30\",\"member_paid_amount\":\"2000.00\",\"member_trx_reference\":\"sdvsdvs\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"sdvdsvsd\",\"rejection_reason\":null,\"created_at\":\"2026-08-23T05:21:08.000000Z\",\"updated_at\":\"2026-08-23T05:37:11.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":2}', '127.0.0.1', '2026-08-23 05:37:11'),
(8, 1, 'update', 'users', 2, '{\"id\":2,\"role_id\":4,\"name\":\"AAA\",\"email\":\"A@g.com\",\"designation\":null,\"is_active\":true,\"created_at\":\"2026-08-22T03:01:10.000000Z\",\"updated_at\":\"2026-08-22T03:14:49.000000Z\",\"deleted_at\":null}', '{\"id\":2,\"role_id\":4,\"name\":\"A Member\",\"email\":\"A@g.com\",\"designation\":null,\"is_active\":true,\"created_at\":\"2026-08-22T03:01:10.000000Z\",\"updated_at\":\"2026-08-23T06:51:09.000000Z\",\"deleted_at\":null}', '127.0.0.1', '2026-08-23 06:51:09'),
(9, 1, 'create', 'users', 5, NULL, '{\"name\":\"B Member\",\"email\":\"B@g.com\",\"role_id\":4,\"designation\":null,\"updated_at\":\"2026-08-23T06:51:59.000000Z\",\"created_at\":\"2026-08-23T06:51:59.000000Z\",\"id\":5}', '127.0.0.1', '2026-08-23 06:51:59'),
(10, 1, 'collect_payment', 'transactions', 9, '{\"status\":\"pending\"}', '{\"id\":9,\"member_id\":6,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260823-00009\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"paid\",\"month\":\"January 2026\",\"transaction_date\":\"2026-08-23T00:00:00.000000Z\",\"description\":\"hi - Ref: dsvsvedsv | Note: dsvsdvsdv\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_9_1787494123_6a8afeeb94fd4.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-23 14:08:43\",\"member_paid_amount\":\"2000.00\",\"member_trx_reference\":\"dsvsvedsv\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"dsvsdvsdv\",\"rejection_reason\":null,\"created_at\":\"2026-08-23T13:57:33.000000Z\",\"updated_at\":\"2026-08-23T14:10:03.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":6}', '127.0.0.1', '2026-08-23 14:10:03'),
(11, 1, 'partial_payment', 'transactions', 6, '{\"id\":6,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260823-00006\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"January 2026\",\"transaction_date\":\"2026-01-22T00:00:00.000000Z\",\"description\":\"hi\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_6_1787496965_6a8b0a053e409.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-23 14:56:05\",\"member_paid_amount\":\"1000.00\",\"member_trx_reference\":\"asdadwqdw\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"wadadwadaw\",\"rejection_reason\":null,\"created_at\":\"2026-08-23T07:33:16.000000Z\",\"updated_at\":\"2026-08-23T14:56:05.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":8}', '{\"paid_amount\":1000,\"remaining_due\":1000,\"remaining_trx\":\"TRX-20260823-00011\"}', '127.0.0.1', '2026-08-23 15:08:57'),
(12, 1, 'partial_payment', 'transactions', 7, '{\"id\":7,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260823-00007\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"January 2026\",\"transaction_date\":\"2026-01-22T00:00:00.000000Z\",\"description\":\"hi\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_7_1787548255_6a8bd25fb6fb3.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-24 05:10:55\",\"member_paid_amount\":\"500.00\",\"member_trx_reference\":\"asdsvsdvfdvbdf\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"sdvdfvdfbd\",\"rejection_reason\":null,\"created_at\":\"2026-08-23T07:33:16.000000Z\",\"updated_at\":\"2026-08-24T05:10:55.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":9}', '{\"paid_amount\":500,\"remaining_due\":1500,\"remaining_trx\":\"TRX-20260824-00012\"}', '127.0.0.1', '2026-08-24 05:13:27'),
(13, 1, 'partial_payment', 'transactions', 12, '{\"id\":12,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260824-00012\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"1500.00\",\"status\":\"pending\",\"month\":\"January 2026\",\"transaction_date\":\"2026-08-24T00:00:00.000000Z\",\"description\":\"Remaining due for Subscription for January 2026 (Due: BDT 1500) - Note: Ref: asdsvsdvfdvbdf | Note: sdvdfvdfbd\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_12_1787548514_6a8bd362ada4b.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-24 05:15:14\",\"member_paid_amount\":\"1000.00\",\"member_trx_reference\":\"vsdvsvsv\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"sdvsvsfb\",\"rejection_reason\":null,\"created_at\":\"2026-08-24T05:13:27.000000Z\",\"updated_at\":\"2026-08-24T05:15:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":9}', '{\"paid_amount\":1000,\"remaining_due\":500,\"remaining_trx\":\"TRX-20260824-00013\"}', '127.0.0.1', '2026-08-24 05:16:02'),
(14, 1, 'collect_payment', 'transactions', 13, '{\"status\":\"pending\"}', '{\"id\":13,\"member_id\":9,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260824-00013\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"500.00\",\"status\":\"paid\",\"month\":\"January 2026\",\"transaction_date\":\"2026-08-24T00:00:00.000000Z\",\"description\":\"Remaining due for Subscription for January 2026 (Due: BDT 500) - Note: Ref: vsdvsvsv | Note: sdvsvsfb - Ref: zv xvdfbdfb | Note: xxbfdbdfb\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_13_1787549607_6a8bd7a7c793d.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-24 05:33:27\",\"member_paid_amount\":\"500.00\",\"member_trx_reference\":\"zv xvdfbdfb\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"xxbfdbdfb\",\"rejection_reason\":null,\"created_at\":\"2026-08-24T05:16:02.000000Z\",\"updated_at\":\"2026-08-24T09:17:04.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":9}', '127.0.0.1', '2026-08-24 09:17:04'),
(15, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-25 05:21:10'),
(16, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":1,\"amount\":2000}', '127.0.0.1', '2026-08-27 08:36:20'),
(17, 1, 'update', 'transactions', 20, '{\"id\":20,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00020\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"xz xczxc\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:36:20.000000Z\",\"updated_at\":\"2026-08-27T08:36:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', '{\"id\":20,\"member_id\":2,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260827-00020\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"33333.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"xz xczxc\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:36:20.000000Z\",\"updated_at\":\"2026-08-27T08:38:49.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', '127.0.0.1', '2026-08-27 08:38:49'),
(18, 1, 'delete', 'transactions', 20, '{\"id\":20,\"member_id\":2,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260827-00020\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"33333.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"xz xczxc\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:36:20.000000Z\",\"updated_at\":\"2026-08-27T08:38:49.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:39:14'),
(19, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 08:46:57'),
(20, 1, 'delete', 'transactions', 21, '{\"id\":21,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-001\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:17'),
(21, 1, 'delete', 'transactions', 22, '{\"id\":22,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-002\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:18'),
(22, 1, 'delete', 'transactions', 23, '{\"id\":23,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-003\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:18'),
(23, 1, 'delete', 'transactions', 24, '{\"id\":24,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-004\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:18'),
(24, 1, 'delete', 'transactions', 25, '{\"id\":25,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-005\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:19'),
(25, 1, 'delete', 'transactions', 26, '{\"id\":26,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-7974-006\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:46:57.000000Z\",\"updated_at\":\"2026-08-27T08:46:57.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:47:19'),
(26, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 08:47:29'),
(27, 1, 'delete', 'transactions', 27, '{\"id\":27,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-001\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:00'),
(28, 1, 'delete', 'transactions', 28, '{\"id\":28,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-002\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:00'),
(29, 1, 'delete', 'transactions', 29, '{\"id\":29,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-003\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:01'),
(30, 1, 'delete', 'transactions', 30, '{\"id\":30,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-004\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:01'),
(31, 1, 'delete', 'transactions', 31, '{\"id\":31,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-005\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:01'),
(32, 1, 'delete', 'transactions', 32, '{\"id\":32,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2980-006\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:47:29.000000Z\",\"updated_at\":\"2026-08-27T08:47:29.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 08:49:01'),
(33, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 08:51:14'),
(34, 1, 'delete', 'transactions', 41, '{\"id\":41,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-1\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(35, 1, 'delete', 'transactions', 42, '{\"id\":42,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-2\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(36, 1, 'delete', 'transactions', 43, '{\"id\":43,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-3\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(37, 1, 'delete', 'transactions', 44, '{\"id\":44,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-4\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(38, 1, 'delete', 'transactions', 45, '{\"id\":45,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-5\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(39, 1, 'delete', 'transactions', 46, '{\"id\":46,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-4706-6\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"vsdvsd\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T08:51:14.000000Z\",\"updated_at\":\"2026-08-27T08:51:14.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:55:21'),
(40, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 14:55:31'),
(41, 1, 'delete', 'transactions', 47, '{\"id\":47,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-1\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:59:59'),
(42, 1, 'delete', 'transactions', 48, '{\"id\":48,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-2\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 14:59:59'),
(43, 1, 'delete', 'transactions', 49, '{\"id\":49,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-3\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:00'),
(44, 1, 'delete', 'transactions', 50, '{\"id\":50,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-4\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:00'),
(45, 1, 'delete', 'transactions', 51, '{\"id\":51,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-5\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:00'),
(46, 1, 'delete', 'transactions', 52, '{\"id\":52,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-2207-6\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T14:55:31.000000Z\",\"updated_at\":\"2026-08-27T14:55:31.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:00'),
(47, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 15:00:10'),
(48, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 15:00:42'),
(49, 1, 'delete', 'transactions', 53, '{\"id\":53,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00045\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(50, 1, 'delete', 'transactions', 54, '{\"id\":54,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00046\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(51, 1, 'delete', 'transactions', 55, '{\"id\":55,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00047\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(52, 1, 'delete', 'transactions', 56, '{\"id\":56,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00048\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(53, 1, 'delete', 'transactions', 57, '{\"id\":57,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00049\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(54, 1, 'delete', 'transactions', 58, '{\"id\":58,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00050\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:10.000000Z\",\"updated_at\":\"2026-08-27T15:00:10.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:00:59'),
(55, 1, 'delete', 'transactions', 59, '{\"id\":59,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00051\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:06'),
(56, 1, 'delete', 'transactions', 60, '{\"id\":60,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00052\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:06'),
(57, 1, 'delete', 'transactions', 61, '{\"id\":61,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00053\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:06'),
(58, 1, 'delete', 'transactions', 62, '{\"id\":62,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00054\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:07'),
(59, 1, 'delete', 'transactions', 63, '{\"id\":63,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00055\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:07'),
(60, 1, 'delete', 'transactions', 64, '{\"id\":64,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00056\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for November 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:00:42.000000Z\",\"updated_at\":\"2026-08-27T15:00:42.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:01:07'),
(61, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 15:46:20'),
(62, 1, 'delete', 'transactions', 65, '{\"id\":65,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00057\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:30'),
(63, 1, 'delete', 'transactions', 66, '{\"id\":66,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00058\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:30'),
(64, 1, 'delete', 'transactions', 67, '{\"id\":67,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00059\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:30'),
(65, 1, 'delete', 'transactions', 68, '{\"id\":68,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00060\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:30'),
(66, 1, 'delete', 'transactions', 69, '{\"id\":69,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00061\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:31'),
(67, 1, 'delete', 'transactions', 70, '{\"id\":70,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-00062\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:20.000000Z\",\"updated_at\":\"2026-08-27T15:46:20.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-27 15:46:31'),
(68, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-27 15:46:38'),
(69, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-28 04:24:56'),
(70, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":1,\"amount\":2000}', '127.0.0.1', '2026-08-28 04:25:24'),
(71, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":4000}', '127.0.0.1', '2026-08-28 04:32:44'),
(72, 1, 'collect_payment', 'transactions', 19, '{\"status\":\"pending\"}', '{\"id\":19,\"member_id\":9,\"created_by\":1,\"updated_by\":1,\"transaction_no\":\"TRX-20260825-00019\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"paid\",\"month\":\"March 2026\",\"transaction_date\":\"2026-08-28T00:00:00.000000Z\",\"description\":\"acascsdv - Ref: fbfbfb | Note: fbfbfb\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_19_1787891907_6a9110c3eeef0.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-28 04:38:27\",\"member_paid_amount\":\"2000.00\",\"member_trx_reference\":\"fbfbfb\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"fbfbfb\",\"rejection_reason\":null,\"created_at\":\"2026-08-25T05:21:10.000000Z\",\"updated_at\":\"2026-08-28T04:40:36.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":9}', '127.0.0.1', '2026-08-28 04:40:36'),
(73, 1, 'partial_payment', 'transactions', 89, '{\"id\":89,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-4395\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"4000.00\",\"status\":\"pending\",\"month\":\"November 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"dvdvdvd\",\"receipt_photo\":\"http:\\/\\/localhost:8000\\/storage\\/receipts\\/receipt_89_1787892155_6a9111bb13e78.jpeg\",\"receipt_photo_uploaded_at\":\"2026-08-28 04:42:35\",\"member_paid_amount\":\"1000.00\",\"member_trx_reference\":\"dfbvdfbdfb\",\"member_payment_method\":\"mobile_banking\",\"member_comment\":\"dfbdfbdfb\",\"rejection_reason\":null,\"created_at\":\"2026-08-28T04:32:44.000000Z\",\"updated_at\":\"2026-08-28T04:42:35.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":9}', '{\"paid_amount\":1000,\"remaining_due\":3000,\"remaining_trx\":\"TRX-20260828-00082\"}', '127.0.0.1', '2026-08-28 04:43:18'),
(74, 1, 'delete', 'transactions', 71, '{\"id\":71,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1095\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:08'),
(75, 1, 'delete', 'transactions', 72, '{\"id\":72,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1096\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:09'),
(76, 1, 'delete', 'transactions', 73, '{\"id\":73,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1097\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:09');
INSERT INTO `activity_logs` (`id`, `user_id`, `action`, `table_name`, `record_id`, `old_values`, `new_values`, `ip_address`, `created_at`) VALUES
(77, 1, 'delete', 'transactions', 74, '{\"id\":74,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1098\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:09'),
(78, 1, 'delete', 'transactions', 75, '{\"id\":75,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1099\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:09'),
(79, 1, 'delete', 'transactions', 76, '{\"id\":76,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260827-1100\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"August 2026\",\"transaction_date\":\"2026-08-27T00:00:00.000000Z\",\"description\":\"Monthly subscription for August 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-27T15:46:38.000000Z\",\"updated_at\":\"2026-08-27T15:46:38.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 05:35:09'),
(80, 1, 'delete', 'transactions', 83, '{\"id\":83,\"member_id\":6,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"scscscsc\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T04:25:24.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:01'),
(81, 1, 'delete', 'transactions', 91, '{\"id\":91,\"member_id\":2,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T07:16:15.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:02'),
(82, 1, 'delete', 'transactions', 92, '{\"id\":92,\"member_id\":5,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T07:16:15.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:02'),
(83, 1, 'delete', 'transactions', 93, '{\"id\":93,\"member_id\":7,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T07:16:15.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:02'),
(84, 1, 'delete', 'transactions', 94, '{\"id\":94,\"member_id\":8,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T07:16:15.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:03'),
(85, 1, 'delete', 'transactions', 95, '{\"id\":95,\"member_id\":9,\"created_by\":1,\"updated_by\":null,\"transaction_no\":\"TRX-20260828-8301\",\"type\":\"payment\",\"payment_category\":\"monthly_payment\",\"amount\":\"2000.00\",\"status\":\"pending\",\"month\":\"December 2026\",\"transaction_date\":\"2026-08-31T00:00:00.000000Z\",\"description\":\"Monthly subscription for December 2026\",\"receipt_photo\":null,\"receipt_photo_uploaded_at\":null,\"member_paid_amount\":null,\"member_trx_reference\":null,\"member_payment_method\":null,\"member_comment\":null,\"rejection_reason\":null,\"created_at\":\"2026-08-28T07:16:15.000000Z\",\"updated_at\":\"2026-08-28T07:16:15.000000Z\",\"deleted_at\":null,\"receipt_photo_uploaded_by\":null}', NULL, '127.0.0.1', '2026-08-28 07:52:03'),
(86, 1, 'generate_payments', 'users', 1, NULL, '{\"type\":\"monthly_payment\",\"count\":6,\"amount\":2000}', '127.0.0.1', '2026-08-28 07:52:16'),
(87, 1, 'create', 'meeting_expenses', 1, NULL, '{\"title\":\"aaaaaaaaa\",\"expense_date\":\"2026-08-28T00:00:00.000000Z\",\"amount\":\"222.00\",\"description\":\"{\\\"items\\\":[{\\\"label\\\":\\\"aaa\\\",\\\"value\\\":111},{\\\"label\\\":\\\"A\\\",\\\"value\\\":111}],\\\"voucher_no\\\":\\\"EXP-20260828-517\\\",\\\"notes\\\":\\\"\\\",\\\"prepared_by\\\":\\\"Super Admin\\\"}\",\"created_by\":1,\"id\":1,\"creator\":{\"id\":1,\"role_id\":1,\"name\":\"Super Admin\",\"email\":\"superadmin@alamanah.com\",\"designation\":null,\"is_active\":true,\"created_at\":\"2026-08-22T00:29:03.000000Z\",\"updated_at\":\"2026-08-22T03:14:49.000000Z\",\"deleted_at\":null,\"member_profile\":{\"id\":3,\"user_id\":1,\"member_no\":\"AMN-0001\",\"phone\":null,\"address\":null,\"share_amount\":\"0.00\",\"created_at\":\"2026-08-22T08:17:42.000000Z\",\"deleted_at\":null},\"role\":{\"id\":1,\"name\":\"super_admin\",\"description\":\"Full control. Assigns roles, designations, and payment permissions.\",\"created_at\":\"2026-08-22 05:53:14\",\"deleted_at\":null}}}', '127.0.0.1', '2026-08-28 14:02:05');

-- --------------------------------------------------------

--
-- Table structure for table `admin_payment_permissions`
--

CREATE TABLE `admin_payment_permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_user_id` int(10) UNSIGNED NOT NULL,
  `assigned_by` int(10) UNSIGNED NOT NULL,
  `can_change_payment` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_payment_permissions`
--

INSERT INTO `admin_payment_permissions` (`id`, `admin_user_id`, `assigned_by`, `can_change_payment`, `created_at`) VALUES
(2, 3, 1, 0, '2026-08-22 03:01:10');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fdrs`
--

CREATE TABLE `fdrs` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` int(10) UNSIGNED NOT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `fdr_no` varchar(50) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `start_date` date NOT NULL,
  `maturity_date` date DEFAULT NULL,
  `status` enum('active','closed','cancelled') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meeting_expenses`
--

CREATE TABLE `meeting_expenses` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `expense_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meeting_expenses`
--

INSERT INTO `meeting_expenses` (`id`, `created_by`, `title`, `expense_date`, `amount`, `description`, `created_at`, `deleted_at`) VALUES
(1, 1, 'aaaaaaaaa', '2026-08-28', 222.00, '{\"items\":[{\"label\":\"aaa\",\"value\":111},{\"label\":\"A\",\"value\":111}],\"voucher_no\":\"EXP-20260828-517\",\"notes\":\"\",\"prepared_by\":\"Super Admin\"}', '2026-08-28 14:02:05', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2026_08_22_002104_create_personal_access_tokens_table', 1),
(2, '0001_01_01_000001_create_cache_table', 2),
(3, '0001_01_01_000002_create_jobs_table', 2),
(4, '2026_08_22_012147_create_sessions_table', 3),
(5, '2024_01_01_000001_create_al_amanah_schema', 1),
(6, '2026_08_22_211500_add_receipt_photo_to_transactions_table', 4),
(7, '2026_08_22_214000_add_member_proof_details_to_transactions_table', 5),
(8, '2026_08_23_001000_add_rejection_reason_to_transactions_table', 6),
(9, '2026_08_28_071510_make_transactions_transaction_no_non_unique', 7);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'system',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `created_at`) VALUES
(4, 2, 'Monthly Payment Due: January 2026', 'A monthly subscription payment of $2000 for January 2026 has been assigned to your account and is pending payment.', 'payment_due', 1, '2026-08-22 14:10:52'),
(5, 2, 'Payment Proof Slip Rejected', 'Your payment proof for TRX-20260822-00001 (January 2026) was rejected by admin. Reason: Amount mismatch between slip and bank record. A new pending due (TRX-20260823-00002) has been generated for you to submit a valid slip.', 'alert', 1, '2026-08-23 05:21:08'),
(6, 2, 'Payment Cleared', 'Payment of BDT 2000 for January 2026 has been cleared in full.', 'payment', 1, '2026-08-23 05:37:11'),
(7, 5, 'Welcome', 'Your account has been created.', 'account', 1, '2026-08-23 06:51:59'),
(8, 6, 'Payment Proof Slip Rejected', 'Your payment proof for TRX-20260823-00004 (January 2026) was rejected by admin. Reason: dcdcdc. A new pending due (TRX-20260823-00008) has been generated for you to submit a valid slip.', 'alert', 1, '2026-08-23 13:47:36'),
(9, 6, 'Payment Proof Slip Rejected', 'Your payment proof for TRX-20260823-00008 (January 2026) was rejected by admin. Reason: dvdbdfb. A new pending due (TRX-20260823-00009) has been generated for you to submit a valid slip.', 'alert', 0, '2026-08-23 13:57:33'),
(10, 6, 'Payment Cleared', 'Payment of BDT 2000 for January 2026 has been cleared in full.', 'payment', 0, '2026-08-23 14:10:03'),
(11, 7, 'Payment Proof Slip Rejected', 'Your payment proof for TRX-20260823-00005 (January 2026) was rejected by admin. Reason: sdds. A new pending due (TRX-20260823-00010) has been generated for you to submit a valid slip.', 'alert', 0, '2026-08-23 14:34:15'),
(12, 8, 'Partial Payment Received', 'Received BDT 1000. BDT 1000 remains due for January 2026.', 'payment', 0, '2026-08-23 15:08:57'),
(13, 9, 'Partial Payment Received', 'Received BDT 500. BDT 1500 remains due for January 2026.', 'payment', 0, '2026-08-24 05:13:27'),
(14, 9, 'Partial Payment Received', 'Received BDT 1000. BDT 500 remains due for January 2026.', 'payment', 0, '2026-08-24 05:16:02'),
(15, 9, 'Payment Cleared', 'Payment of BDT 500 for January 2026 has been cleared in full.', 'payment', 0, '2026-08-24 09:17:04'),
(16, 2, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(17, 5, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(18, 6, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(19, 7, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(20, 8, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(21, 9, 'Monthly Payment Due: March 2026', 'A monthly subscription payment of $2000 for March 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-25 05:21:10'),
(22, 2, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:36:20'),
(23, 1, 'Transaction Updated', 'Transaction TRX-20260827-00020 was updated.', 'transaction', 0, '2026-08-27 02:38:49'),
(24, 3, 'Transaction Updated', 'Transaction TRX-20260827-00020 was updated.', 'transaction', 0, '2026-08-27 02:38:49'),
(25, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00020 was deleted.', 'transaction', 0, '2026-08-27 02:39:14'),
(26, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00020 was deleted.', 'transaction', 0, '2026-08-27 02:39:14'),
(27, 2, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(28, 5, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(29, 6, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(30, 7, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(31, 8, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(32, 9, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:46:57'),
(33, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-001 was deleted.', 'transaction', 0, '2026-08-27 02:47:17'),
(34, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-001 was deleted.', 'transaction', 0, '2026-08-27 02:47:17'),
(35, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-002 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(36, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-002 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(37, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-003 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(38, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-003 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(39, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-004 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(40, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-004 was deleted.', 'transaction', 0, '2026-08-27 02:47:18'),
(41, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-005 was deleted.', 'transaction', 0, '2026-08-27 02:47:19'),
(42, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-005 was deleted.', 'transaction', 0, '2026-08-27 02:47:19'),
(43, 1, 'Transaction Deleted', 'Transaction TRX-20260827-7974-006 was deleted.', 'transaction', 0, '2026-08-27 02:47:19'),
(44, 3, 'Transaction Deleted', 'Transaction TRX-20260827-7974-006 was deleted.', 'transaction', 0, '2026-08-27 02:47:19'),
(45, 2, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(46, 5, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(47, 6, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(48, 7, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(49, 8, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(50, 9, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:47:29'),
(51, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-001 was deleted.', 'transaction', 0, '2026-08-27 02:49:00'),
(52, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-001 was deleted.', 'transaction', 0, '2026-08-27 02:49:00'),
(53, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-002 was deleted.', 'transaction', 0, '2026-08-27 02:49:00'),
(54, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-002 was deleted.', 'transaction', 0, '2026-08-27 02:49:00'),
(55, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-003 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(56, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-003 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(57, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-004 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(58, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-004 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(59, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-005 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(60, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-005 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(61, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2980-006 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(62, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2980-006 was deleted.', 'transaction', 0, '2026-08-27 02:49:01'),
(67, 2, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(68, 5, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(69, 6, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(70, 7, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(71, 8, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(72, 9, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 08:51:14'),
(73, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-1 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(74, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-1 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(75, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-2 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(76, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-2 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(77, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-3 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(78, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-3 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(79, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-4 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(80, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-4 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(81, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-5 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(82, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-5 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(83, 1, 'Transaction Deleted', 'Transaction TRX-20260827-4706-6 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(84, 3, 'Transaction Deleted', 'Transaction TRX-20260827-4706-6 was deleted.', 'transaction', 0, '2026-08-27 08:55:21'),
(85, 2, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(86, 5, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(87, 6, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(88, 7, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(89, 8, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(90, 9, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 14:55:31'),
(91, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-1 was deleted.', 'transaction', 0, '2026-08-27 08:59:59'),
(92, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-1 was deleted.', 'transaction', 0, '2026-08-27 08:59:59'),
(93, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-2 was deleted.', 'transaction', 0, '2026-08-27 08:59:59'),
(94, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-2 was deleted.', 'transaction', 0, '2026-08-27 08:59:59'),
(95, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-3 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(96, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-3 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(97, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-4 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(98, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-4 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(99, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-5 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(100, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-5 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(101, 1, 'Transaction Deleted', 'Transaction TRX-20260827-2207-6 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(102, 3, 'Transaction Deleted', 'Transaction TRX-20260827-2207-6 was deleted.', 'transaction', 0, '2026-08-27 09:00:00'),
(103, 2, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(104, 5, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(105, 6, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(106, 7, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(107, 8, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(108, 9, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:10'),
(109, 2, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(110, 5, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(111, 6, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(112, 7, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(113, 8, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(114, 9, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $2000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:00:42'),
(115, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00045 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(116, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00045 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(117, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00046 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(118, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00046 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(119, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00047 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(120, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00047 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(121, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00048 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(122, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00048 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(123, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00049 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(124, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00049 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(125, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00050 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(126, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00050 was deleted.', 'transaction', 0, '2026-08-27 09:00:59'),
(127, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00051 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(128, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00051 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(129, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00052 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(130, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00052 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(131, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00053 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(132, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00053 was deleted.', 'transaction', 0, '2026-08-27 09:01:06'),
(133, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00054 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(134, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00054 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(135, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00055 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(136, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00055 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(137, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00056 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(138, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00056 was deleted.', 'transaction', 0, '2026-08-27 09:01:07'),
(139, 2, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(140, 5, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(141, 6, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(142, 7, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(143, 8, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(144, 9, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:20'),
(145, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00057 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(146, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00057 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(147, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00058 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(148, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00058 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(149, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00059 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(150, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00059 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(151, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00060 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(152, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00060 was deleted.', 'transaction', 0, '2026-08-27 09:46:30'),
(153, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00061 was deleted.', 'transaction', 0, '2026-08-27 09:46:31'),
(154, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00061 was deleted.', 'transaction', 0, '2026-08-27 09:46:31'),
(155, 1, 'Transaction Deleted', 'Transaction TRX-20260827-00062 was deleted.', 'transaction', 0, '2026-08-27 09:46:31'),
(156, 3, 'Transaction Deleted', 'Transaction TRX-20260827-00062 was deleted.', 'transaction', 0, '2026-08-27 09:46:31'),
(157, 2, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(158, 5, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(159, 6, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(160, 7, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(161, 8, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(162, 9, 'Monthly Payment Due: August 2026', 'A monthly subscription payment of $2000 for August 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-27 15:46:38'),
(163, 2, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(164, 5, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(165, 6, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(166, 7, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(167, 8, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(168, 9, 'Monthly Payment Due: October 2026', 'A monthly subscription payment of $2000 for October 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:24:56'),
(169, 6, 'Monthly Payment Due: December 2026', 'A monthly subscription payment of $2000 for December 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:25:24'),
(170, 2, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(171, 5, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(172, 6, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(173, 7, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(174, 8, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(175, 9, 'Monthly Payment Due: November 2026', 'A monthly subscription payment of $4000 for November 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 04:32:44'),
(176, 9, 'Payment Cleared', 'Payment of BDT 2000 for March 2026 has been cleared in full.', 'payment', 0, '2026-08-28 04:40:36'),
(177, 9, 'Partial Payment Received', 'Received BDT 1000. BDT 3000 remains due for November 2026.', 'payment', 0, '2026-08-28 04:43:18'),
(178, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1095 was deleted.', 'transaction', 0, '2026-08-27 23:35:08'),
(179, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1095 was deleted.', 'transaction', 0, '2026-08-27 23:35:08'),
(180, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1096 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(181, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1096 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(182, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1097 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(183, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1097 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(184, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1098 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(185, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1098 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(186, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1099 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(187, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1099 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(188, 1, 'Transaction Deleted', 'Transaction TRX-20260827-1100 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(189, 3, 'Transaction Deleted', 'Transaction TRX-20260827-1100 was deleted.', 'transaction', 0, '2026-08-27 23:35:09'),
(190, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:01'),
(191, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:01'),
(192, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(193, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(194, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(195, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(196, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(197, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:02'),
(198, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:03'),
(199, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:03'),
(200, 1, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:03'),
(201, 3, 'Transaction Deleted', 'Transaction TRX-20260828-8301 was deleted.', 'transaction', 0, '2026-08-28 01:52:03'),
(202, 2, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16'),
(203, 5, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16'),
(204, 6, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16'),
(205, 7, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16'),
(206, 8, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16'),
(207, 9, 'Monthly Payment Due: February 2026', 'A monthly subscription payment of $2000 for February 2026 has been assigned to your account and is pending payment.', 'payment_due', 0, '2026-08-28 07:52:16');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `module` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `module`, `action`, `description`) VALUES
(1, 'transactions', 'view', 'View all transactions'),
(2, 'transactions', 'update_payment', 'Change payment values'),
(3, 'receipts', 'manage', 'Create and manage member receipts'),
(4, 'reports', 'print', 'Print transaction and receipt reports'),
(5, 'settings', 'manage', 'Manage system settings and payment values'),
(6, 'users', 'manage', 'Create and manage users and roles'),
(7, 'transactions', 'manage', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'api', '5971af854e90533125fcef530d0b3d8e44bcf281e9912bdb46ed5b9077aec6cc', '[\"*\"]', NULL, NULL, '2026-08-21 18:29:09', '2026-08-21 18:29:09'),
(2, 'App\\Models\\User', 1, 'api', 'a29bf5acd13a76c6a0591081fb57392d8f8416f3d7dc6bc7ca75ed4c2d2f5394', '[\"*\"]', NULL, NULL, '2026-08-21 19:20:51', '2026-08-21 19:20:51'),
(3, 'App\\Models\\User', 1, 'api', 'fd012a1460144527a3dbd967210b473ea1001f6f5cfbb1ac5ba4b8dcec3bf931', '[\"*\"]', '2026-08-21 19:24:31', NULL, '2026-08-21 19:24:22', '2026-08-21 19:24:31'),
(4, 'App\\Models\\User', 1, 'api', 'fb2da9f36db0f3aa9e3ea1cdb4870c8870fb31c042ab1dc3f5b2d9c03c227910', '[\"*\"]', '2026-08-21 19:29:57', NULL, '2026-08-21 19:29:49', '2026-08-21 19:29:57'),
(5, 'App\\Models\\User', 1, 'api', 'e6f574a064227e5e23c5bdcd1c425e4997c8f0a6a9409980eca848aa3746cfdd', '[\"*\"]', '2026-08-21 21:15:19', NULL, '2026-08-21 19:37:41', '2026-08-21 21:15:19'),
(6, 'App\\Models\\User', 1, 'test', '823322b0f397062e17fe9ddff74bc4eeb30abec453343aadd1da7e9b1514e918', '[\"*\"]', '2026-08-21 21:03:32', NULL, '2026-08-21 21:03:32', '2026-08-21 21:03:32'),
(7, 'App\\Models\\User', 1, 'test', 'bfcabf51a8144f3a596ac4e8de5eba949a01044532191ec5500c830f5c4b3dae', '[\"*\"]', '2026-08-21 21:03:56', NULL, '2026-08-21 21:03:55', '2026-08-21 21:03:56'),
(8, 'App\\Models\\User', 2, 'api', '1bad0f05383f5b182253bcb1a26ebff1205f20a28499f9dadfa488affe784983', '[\"*\"]', '2026-08-21 21:22:33', NULL, '2026-08-21 21:15:55', '2026-08-21 21:22:33'),
(9, 'App\\Models\\User', 1, 'api', '84ee8cefc51f4aa46c624442ddc2788a74262ae331adcec7cd0c284d808ed3a4', '[\"*\"]', '2026-08-22 12:33:20', NULL, '2026-08-22 07:38:25', '2026-08-22 12:33:20'),
(10, 'App\\Models\\User', 2, 'api', 'e276ef27321166a32426a433f1e446710c73373732cb717da3015f5534a26565', '[\"*\"]', '2026-08-22 10:39:34', NULL, '2026-08-22 09:29:27', '2026-08-22 10:39:34'),
(11, 'App\\Models\\User', 1, 'api', '1f4709952aca2de8cc3c319fa9ec56aa74514b8c6883c1d86761e811c3fc9450', '[\"*\"]', '2026-08-23 03:06:13', NULL, '2026-08-22 23:16:35', '2026-08-23 03:06:13'),
(13, 'App\\Models\\User', 5, 'api', '6f63dd2b9648c148d77ce80279c938c6c95c5aa77e536d92a586cfd804fb1e4a', '[\"*\"]', '2026-08-23 02:16:01', NULL, '2026-08-23 01:27:13', '2026-08-23 02:16:01'),
(14, 'App\\Models\\User', 1, 'api', '18536a7832645948abeaabaa43c0594fb49ce5150b9e00135d1ac50ea1c05ba9', '[\"*\"]', '2026-08-23 03:39:20', NULL, '2026-08-23 03:06:28', '2026-08-23 03:39:20'),
(15, 'App\\Models\\User', 6, 'api', '0ac4c08e8ce29b625002b98fc7751b779b6b504b4f9ba9e5bc8974a25872af60', '[\"*\"]', '2026-08-23 03:39:22', NULL, '2026-08-23 03:07:18', '2026-08-23 03:39:22'),
(16, 'App\\Models\\User', 1, 'api', '0998f8df433aab459045001105972b00f2aadabefc5cd6f82c7beddc11c28191', '[\"*\"]', '2026-08-23 11:48:37', NULL, '2026-08-23 07:36:47', '2026-08-23 11:48:37'),
(19, 'App\\Models\\User', 8, 'api', 'b89b4feb7dd42450b4326688fa57481f41038991884ef10fe12affdc843fed99', '[\"*\"]', '2026-08-23 11:48:35', NULL, '2026-08-23 08:55:37', '2026-08-23 11:48:35'),
(20, 'App\\Models\\User', 1, 'api', '95d12791b114d3f4707cb82979fb36dce61d13028bcf1dd461ae8cfcf3e719bf', '[\"*\"]', '2026-08-23 23:46:56', NULL, '2026-08-23 22:19:25', '2026-08-23 23:46:56'),
(21, 'App\\Models\\User', 9, 'api', '4f02756bece6acc288b3b2bfcd027e7055f7a8169b0ebaa5fb79bf34a5d9916b', '[\"*\"]', '2026-08-23 23:20:53', NULL, '2026-08-23 23:09:31', '2026-08-23 23:20:53'),
(22, 'App\\Models\\User', 9, 'api', 'd606a5717666e952fe9a6620be40d21424fb14e55159a7e9f2af150e52237d90', '[\"*\"]', '2026-08-23 23:35:27', NULL, '2026-08-23 23:21:11', '2026-08-23 23:35:27'),
(23, 'App\\Models\\User', 9, 'api', '68a57d667ac25aeb401b54f53a4508ea646a3c5b8cb2669a463541f218c1e338', '[\"*\"]', '2026-08-24 10:22:19', NULL, '2026-08-23 23:35:45', '2026-08-24 10:22:19'),
(24, 'App\\Models\\User', 1, 'api', 'b5dd974cb8b6fdd177bfbe9a536e643f0768dd3dc72afead7853f808f4c5bb97', '[\"*\"]', '2026-08-24 12:00:28', NULL, '2026-08-23 23:47:07', '2026-08-24 12:00:28'),
(25, 'App\\Models\\User', 1, 'api', '7c19980d6300f3f0ffa70c6a66815e3551a6be46ec663d3b7eb170e1e9d62efa', '[\"*\"]', '2026-08-25 01:25:37', NULL, '2026-08-24 22:48:46', '2026-08-25 01:25:37'),
(26, 'App\\Models\\User', 1, 'api', '44b0c8ebf7508cb23024080cb435b95aed90bae96a7ecb5a71a75142b2aa637b', '[\"*\"]', '2026-08-25 02:39:14', NULL, '2026-08-25 01:25:50', '2026-08-25 02:39:14'),
(27, 'App\\Models\\User', 1, 'api', '77573ec0100313bd4e11f6f384030dec7e1e9c9822821e15d4596cd90105674e', '[\"*\"]', '2026-08-25 02:39:37', NULL, '2026-08-25 02:39:31', '2026-08-25 02:39:37'),
(28, 'App\\Models\\User', 1, 'api', '19e6cad3b051842fa00d0fa76a6a22c9a1340e07141ba29ad8b09f0813471dbd', '[\"*\"]', '2026-08-25 04:58:25', NULL, '2026-08-25 02:53:16', '2026-08-25 04:58:25'),
(29, 'App\\Models\\User', 1, 'api', 'd08d83881865e63b93807dd88c4adeaef25016c0d8a1f9753d483ea86605daec', '[\"*\"]', '2026-08-26 23:49:31', NULL, '2026-08-26 23:18:07', '2026-08-26 23:49:31'),
(30, 'App\\Models\\User', 1, 'api', '7b1dc7f266438277315fab233ce5fb0c40cb348c61c5d893ce70fda5357c86eb', '[\"*\"]', '2026-08-27 03:09:34', NULL, '2026-08-26 23:49:40', '2026-08-27 03:09:34'),
(31, 'App\\Models\\User', 9, 'api', '435165fcc33c5fbca2834d5526221178d4252906819a27d1f8547edb8ebfc5e6', '[\"*\"]', '2026-08-27 03:09:37', NULL, '2026-08-27 01:28:31', '2026-08-27 03:09:37'),
(32, 'App\\Models\\User', 1, 'api', '87752f4995f2c7784898a0f241bb967204c4a38fc4f51b433a6455abc39f7e4c', '[\"*\"]', '2026-08-27 07:54:23', NULL, '2026-08-27 07:19:22', '2026-08-27 07:54:23'),
(33, 'App\\Models\\User', 1, 'api', '322c221b8c0cc57a3834d9a04a60559823dcea9c40a4b2793c6cf33dec4f53bb', '[\"*\"]', '2026-08-27 11:38:32', NULL, '2026-08-27 08:04:49', '2026-08-27 11:38:32'),
(35, 'App\\Models\\User', 1, 'api', '9f1be5b674a8fec5550cbeb7393a642f6b5c85aa2aab316097968fdbd4942afe', '[\"*\"]', '2026-08-28 01:04:47', NULL, '2026-08-27 22:31:12', '2026-08-28 01:04:47'),
(36, 'App\\Models\\User', 9, 'api', 'b1f4e537d435331507fb8d9132e39b529c96fd9a8c51f701a7faf51cee93ca27', '[\"*\"]', '2026-08-28 01:17:05', NULL, '2026-08-27 22:36:59', '2026-08-28 01:17:05'),
(37, 'App\\Models\\User', 1, 'api', '836cc7c76e4b16fb87ba6f7943986ed58915415fb863bf5b6ec5e684f83e49d0', '[\"*\"]', '2026-08-28 01:17:02', NULL, '2026-08-28 01:04:56', '2026-08-28 01:17:02'),
(38, 'App\\Models\\User', 1, 'api', '4978ce8a1f0058ca5fb68b819545b1cb5d9ed7dae63a212fd2dea87c3d8b59f1', '[\"*\"]', '2026-08-28 05:06:20', NULL, '2026-08-28 01:51:05', '2026-08-28 05:06:20'),
(39, 'App\\Models\\User', 1, 'api', '92df1e8ede7c063cd6971afe83130bd45ab62dc214ab0f1b6fa18b5c57321ae6', '[\"*\"]', '2026-08-28 08:13:25', NULL, '2026-08-28 05:06:50', '2026-08-28 08:13:25'),
(40, 'App\\Models\\User', 9, 'api', 'a8f420d2a97feb0b17edaf474a6b7cf7d256f89a1591a4d06d068018f249faed', '[\"*\"]', '2026-08-28 07:15:21', NULL, '2026-08-28 06:58:36', '2026-08-28 07:15:21'),
(41, 'App\\Models\\User', 9, 'api', '2df1dc9ee0608a9667fae26b677c8e294df332a470293ba64167d0a5142bf5f8', '[\"*\"]', '2026-08-28 08:13:56', NULL, '2026-08-28 07:15:31', '2026-08-28 08:13:56');

-- --------------------------------------------------------

--
-- Table structure for table `profile_shares`
--

CREATE TABLE `profile_shares` (
  `id` int(10) UNSIGNED NOT NULL,
  `primary_user_id` int(10) UNSIGNED NOT NULL,
  `shared_user_id` int(10) UNSIGNED NOT NULL,
  `relation` varchar(50) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `receipts`
--

CREATE TABLE `receipts` (
  `id` int(10) UNSIGNED NOT NULL,
  `transaction_id` int(10) UNSIGNED NOT NULL,
  `member_id` int(10) UNSIGNED NOT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `receipt_no` varchar(50) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payment_method` enum('cash','bank','mobile_banking','other') NOT NULL DEFAULT 'cash',
  `receipt_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receipts`
--

INSERT INTO `receipts` (`id`, `transaction_id`, `member_id`, `created_by`, `receipt_no`, `amount`, `payment_method`, `receipt_date`, `created_at`, `deleted_at`) VALUES
(1, 2, 2, 1, 'RCT-20260823-00001', 2000.00, 'mobile_banking', '2026-08-23', '2026-08-23 05:37:11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `deleted_at`) VALUES
(1, 'super_admin', 'Full control. Assigns roles, designations, and payment permissions.', '2026-08-21 23:53:14', NULL),
(2, 'admin', 'Views all transactions, prints reports, receives notifications.', '2026-08-21 23:53:14', NULL),
(3, 'accountant', 'Views and manages member receipts.', '2026-08-21 23:53:14', NULL),
(4, 'member', 'Views own profile, own transactions, and own notifications.', '2026-08-21 23:53:14', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `permission_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `role_id`, `permission_id`) VALUES
(5, 1, 1),
(1, 1, 3),
(2, 1, 4),
(3, 1, 5),
(6, 1, 6),
(12, 1, 7),
(9, 2, 1),
(8, 2, 4),
(13, 2, 7),
(11, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('7XYJenWTFjv00Xog2Xoj1s6y6nZkIaDWPmWG2quu', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 OPR/134.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiblNKMXVaYjRZaE1qRVVERzFsakVkU1N5ejVYc3l4NHhpTXNERVlnQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787365172),
('FQEJgnGxqfSIdSpsa2LrzPOxhLdLQQvpjy83M2p8', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 OPR/134.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSmhYTEpOempRV3J3MmRERFl3WmZETk1DSDhVYWxkUzdCdlczUG5zSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787405847),
('jtrHtmxlljg4sWXxzv2Ob21yWlvadixQ8K71L7TZ', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.9168', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM1FlODRaNUxLR3FCYVplcDZjcHZQQjFCWWhPODBINDhjM2lYZnpJQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787362971),
('qYU91ikLR52dh2Sfxk3ILy0E6zSMXw4CcbGyydx6', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.9168', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiem5MOVpPUE5kYlpFd3VZNXpxaWlqb0FaUm9IYkt6RGZyd0NKcmg5VSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787361731),
('RpBWsHFqsY6nMxOG4m70DzlTz3hklz91EZ8J4yK1', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.9168', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT1hNd3hVYW01dExkVHY0VmU2T0F4R1J4VlhXa0ROUXpkTlBlMUc5QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787362965),
('xnqpiC47uFrG8WZKApc8CZceeUCT8bfvKhgALwqV', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 OPR/134.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiejB4b0U5Z1JzeHk4a3JxYVdBS3V6M21MWHkyU2JyTHRJRUoyS0c3cyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1787818291);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `updated_by`, `setting_key`, `setting_value`, `description`, `updated_at`) VALUES
(1, NULL, 'payment_amount_1', '2000', 'Default payment amount option 1', '2026-08-21 23:53:14'),
(2, NULL, 'payment_amount_2', '3000', 'Default payment amount option 2', '2026-08-21 23:53:14');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `member_id` int(10) UNSIGNED NOT NULL,
  `created_by` int(10) UNSIGNED NOT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `transaction_no` varchar(50) NOT NULL,
  `type` enum('payment','share','fdr','expense','other') NOT NULL DEFAULT 'payment',
  `payment_category` varchar(50) NOT NULL DEFAULT 'general',
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) NOT NULL DEFAULT 'paid',
  `month` varchar(50) DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `description` text DEFAULT NULL,
  `receipt_photo` longtext DEFAULT NULL,
  `receipt_photo_uploaded_at` timestamp NULL DEFAULT NULL,
  `member_paid_amount` decimal(12,2) DEFAULT NULL,
  `member_trx_reference` varchar(100) DEFAULT NULL,
  `member_payment_method` varchar(50) DEFAULT NULL,
  `member_comment` text DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `receipt_photo_uploaded_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `member_id`, `created_by`, `updated_by`, `transaction_no`, `type`, `payment_category`, `amount`, `status`, `month`, `transaction_date`, `description`, `receipt_photo`, `receipt_photo_uploaded_at`, `member_paid_amount`, `member_trx_reference`, `member_payment_method`, `member_comment`, `rejection_reason`, `created_at`, `updated_at`, `deleted_at`, `receipt_photo_uploaded_by`) VALUES
(1, 2, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'rejected', 'January 2026', '2026-01-22', 'hi', 'http://localhost:8000/storage/receipts/receipt_1_1787415950_6a89cd8e39252.jpeg', '2026-08-22 10:25:50', 2000.00, 'sdvsdv', 'mobile_banking', 'sdvdfvdvfd', 'Amount mismatch between slip and bank record', '2026-08-22 08:10:52', '2026-08-28 01:16:15', NULL, 2),
(2, 2, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'paid', 'January 2026', '2026-08-23', 'hi - Ref: sdvsdvs | Note: sdvdsvsd', 'http://localhost:8000/storage/receipts/receipt_2_1787463390_6a8a86de4fcc7.jpeg', '2026-08-22 23:36:30', 2000.00, 'sdvsdvs', 'mobile_banking', 'sdvdsvsd', NULL, '2026-08-22 23:21:08', '2026-08-28 01:16:15', NULL, 2),
(3, 5, 1, NULL, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'pending', 'January 2026', '2026-01-22', 'hi', 'http://localhost:8000/storage/receipts/receipt_3_1787470612_6a8aa314e5393.jpeg', '2026-08-23 01:36:52', 2000.00, 'dcvsvsdv', 'mobile_banking', 'sdvsdvsv', NULL, '2026-08-23 01:33:16', '2026-08-28 01:16:15', NULL, 5),
(4, 6, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'rejected', 'January 2026', '2026-01-22', 'hi', 'http://localhost:8000/storage/receipts/receipt_4_1787476062_6a8ab85e212d0.jpeg', '2026-08-23 03:07:42', 2000.00, 'gsfbsfhdgn', 'mobile_banking', 'dvsdvsfdbfdsb', 'dcdcdc', '2026-08-23 01:33:16', '2026-08-28 01:16:15', NULL, 6),
(5, 7, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'rejected', 'January 2026', '2026-01-22', 'hi', 'http://localhost:8000/storage/receipts/receipt_5_1787495635_6a8b04d3e3b28.jpeg', '2026-08-23 08:33:55', 2000.00, 'sadasd', 'mobile_banking', 'sadasd', 'sdds', '2026-08-23 01:33:16', '2026-08-28 01:16:15', NULL, 7),
(6, 8, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 1000.00, 'paid', 'January 2026', '2026-08-23', 'Subscription for January 2026 (Partial payment: BDT 1000 of BDT 2000) - Ref: asdadwqdw | Note: wadadwadaw', 'http://localhost:8000/storage/receipts/receipt_6_1787496965_6a8b0a053e409.jpeg', '2026-08-23 08:56:05', 1000.00, 'asdadwqdw', 'mobile_banking', 'wadadwadaw', NULL, '2026-08-23 01:33:16', '2026-08-28 01:16:15', NULL, 8),
(7, 9, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 500.00, 'paid', 'January 2026', '2026-08-24', 'Subscription for January 2026 (Partial payment: BDT 500 of BDT 2000) - Ref: asdsvsdvfdvbdf | Note: sdvdfvdfbd', 'http://localhost:8000/storage/receipts/receipt_7_1787548255_6a8bd25fb6fb3.jpeg', '2026-08-23 23:10:55', 500.00, 'asdsvsdvfdvbdf', 'mobile_banking', 'sdvdfvdfbd', NULL, '2026-08-23 01:33:16', '2026-08-28 01:16:15', NULL, 9),
(8, 6, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'rejected', 'January 2026', '2026-01-22', 'hi', 'http://localhost:8000/storage/receipts/receipt_8_1787493404_6a8afc1cf160a.jpeg', '2026-08-23 07:56:44', 2000.00, 'vdsfvdvsdfv', 'mobile_banking', 'dfsvdfbdfb', 'dvdbdfb', '2026-08-23 07:47:36', '2026-08-28 01:16:15', NULL, 6),
(9, 6, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'paid', 'January 2026', '2026-08-23', 'hi - Ref: dsvsvedsv | Note: dsvsdvsdv', 'http://localhost:8000/storage/receipts/receipt_9_1787494123_6a8afeeb94fd4.jpeg', '2026-08-23 08:08:43', 2000.00, 'dsvsvedsv', 'mobile_banking', 'dsvsdvsdv', NULL, '2026-08-23 07:57:33', '2026-08-28 01:16:15', NULL, 6),
(10, 7, 1, NULL, 'TRX-20260823-00003', 'payment', 'monthly_payment', 2000.00, 'pending', 'January 2026', '2026-01-22', 'hi', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-23 08:34:15', '2026-08-28 01:16:15', NULL, NULL),
(11, 8, 1, NULL, 'TRX-20260823-00003', 'payment', 'monthly_payment', 1000.00, 'pending', 'January 2026', '2026-08-23', 'Remaining due for Subscription for January 2026 (Due: BDT 1000) - Note: Ref: asdadwqdw | Note: wadadwadaw', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-23 09:08:57', '2026-08-28 01:16:15', NULL, NULL),
(12, 9, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 1000.00, 'paid', 'January 2026', '2026-08-24', 'Subscription for January 2026 (Partial payment: BDT 1000 of BDT 1500) - Ref: vsdvsvsv | Note: sdvsvsfb', 'http://localhost:8000/storage/receipts/receipt_12_1787548514_6a8bd362ada4b.jpeg', '2026-08-23 23:15:14', 1000.00, 'vsdvsvsv', 'mobile_banking', 'sdvsvsfb', NULL, '2026-08-23 23:13:27', '2026-08-28 01:16:15', NULL, 9),
(13, 9, 1, 1, 'TRX-20260823-00003', 'payment', 'monthly_payment', 500.00, 'paid', 'January 2026', '2026-08-24', 'Remaining due for Subscription for January 2026 (Due: BDT 500) - Note: Ref: vsdvsvsv | Note: sdvsvsfb - Ref: zv xvdfbdfb | Note: xxbfdbdfb', 'http://localhost:8000/storage/receipts/receipt_13_1787549607_6a8bd7a7c793d.jpeg', '2026-08-23 23:33:27', 500.00, 'zv xvdfbdfb', 'mobile_banking', 'xxbfdbdfb', NULL, '2026-08-23 23:16:02', '2026-08-28 01:16:15', NULL, 9),
(14, 2, 1, NULL, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'pending', 'March 2026', '2026-04-10', 'acascsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, NULL),
(15, 5, 1, NULL, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'pending', 'March 2026', '2026-04-10', 'acascsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, NULL),
(16, 6, 1, NULL, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'pending', 'March 2026', '2026-04-10', 'acascsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, NULL),
(17, 7, 1, NULL, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'pending', 'March 2026', '2026-04-10', 'acascsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, NULL),
(18, 8, 1, NULL, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'pending', 'March 2026', '2026-04-10', 'acascsdv', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, NULL),
(19, 9, 1, 1, 'TRX-20260825-00014', 'payment', 'monthly_payment', 2000.00, 'paid', 'March 2026', '2026-08-28', 'acascsdv - Ref: fbfbfb | Note: fbfbfb', 'http://localhost:8000/storage/receipts/receipt_19_1787891907_6a9110c3eeef0.jpeg', '2026-08-27 22:38:27', 2000.00, 'fbfbfb', 'mobile_banking', 'fbfbfb', NULL, '2026-08-24 23:21:10', '2026-08-28 01:16:15', NULL, 9),
(20, 2, 1, 1, 'TRX-20260827-00020', 'payment', 'monthly_payment', 33333.00, 'pending', 'December 2026', '2026-08-31', 'xz xczxc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:36:20', '2026-08-27 02:39:14', '2026-08-27 02:39:14', NULL),
(21, 2, 1, NULL, 'TRX-20260827-7974-001', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:17', '2026-08-27 02:47:17', NULL),
(22, 5, 1, NULL, 'TRX-20260827-7974-002', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:18', '2026-08-27 02:47:18', NULL),
(23, 6, 1, NULL, 'TRX-20260827-7974-003', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:18', '2026-08-27 02:47:18', NULL),
(24, 7, 1, NULL, 'TRX-20260827-7974-004', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:18', '2026-08-27 02:47:18', NULL),
(25, 8, 1, NULL, 'TRX-20260827-7974-005', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:19', '2026-08-27 02:47:19', NULL),
(26, 9, 1, NULL, 'TRX-20260827-7974-006', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:46:57', '2026-08-27 02:47:19', '2026-08-27 02:47:19', NULL),
(27, 2, 1, NULL, 'TRX-20260827-2980-001', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:00', '2026-08-27 02:49:00', NULL),
(28, 5, 1, NULL, 'TRX-20260827-2980-002', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:00', '2026-08-27 02:49:00', NULL),
(29, 6, 1, NULL, 'TRX-20260827-2980-003', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:01', '2026-08-27 02:49:01', NULL),
(30, 7, 1, NULL, 'TRX-20260827-2980-004', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:01', '2026-08-27 02:49:01', NULL),
(31, 8, 1, NULL, 'TRX-20260827-2980-005', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:01', '2026-08-27 02:49:01', NULL),
(32, 9, 1, NULL, 'TRX-20260827-2980-006', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:47:29', '2026-08-27 02:49:01', '2026-08-27 02:49:01', NULL),
(41, 2, 1, NULL, 'TRX-20260827-4706-1', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(42, 5, 1, NULL, 'TRX-20260827-4706-2', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(43, 6, 1, NULL, 'TRX-20260827-4706-3', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(44, 7, 1, NULL, 'TRX-20260827-4706-4', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(45, 8, 1, NULL, 'TRX-20260827-4706-5', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(46, 9, 1, NULL, 'TRX-20260827-4706-6', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-27', 'vsdvsd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 02:51:14', '2026-08-27 08:55:21', '2026-08-27 08:55:21', NULL),
(47, 2, 1, NULL, 'TRX-20260827-2207-1', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 08:59:59', '2026-08-27 08:59:59', NULL),
(48, 5, 1, NULL, 'TRX-20260827-2207-2', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 08:59:59', '2026-08-27 08:59:59', NULL),
(49, 6, 1, NULL, 'TRX-20260827-2207-3', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 09:00:00', '2026-08-27 09:00:00', NULL),
(50, 7, 1, NULL, 'TRX-20260827-2207-4', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 09:00:00', '2026-08-27 09:00:00', NULL),
(51, 8, 1, NULL, 'TRX-20260827-2207-5', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 09:00:00', '2026-08-27 09:00:00', NULL),
(52, 9, 1, NULL, 'TRX-20260827-2207-6', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 08:55:31', '2026-08-27 09:00:00', '2026-08-27 09:00:00', NULL),
(53, 2, 1, NULL, 'TRX-20260827-00045', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(54, 5, 1, NULL, 'TRX-20260827-00046', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(55, 6, 1, NULL, 'TRX-20260827-00047', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(56, 7, 1, NULL, 'TRX-20260827-00048', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(57, 8, 1, NULL, 'TRX-20260827-00049', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(58, 9, 1, NULL, 'TRX-20260827-00050', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:10', '2026-08-27 09:00:59', '2026-08-27 09:00:59', NULL),
(59, 2, 1, NULL, 'TRX-20260827-00051', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:06', '2026-08-27 09:01:06', NULL),
(60, 5, 1, NULL, 'TRX-20260827-00052', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:06', '2026-08-27 09:01:06', NULL),
(61, 6, 1, NULL, 'TRX-20260827-00053', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:06', '2026-08-27 09:01:06', NULL),
(62, 7, 1, NULL, 'TRX-20260827-00054', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:07', '2026-08-27 09:01:07', NULL),
(63, 8, 1, NULL, 'TRX-20260827-00055', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:07', '2026-08-27 09:01:07', NULL),
(64, 9, 1, NULL, 'TRX-20260827-00056', 'payment', 'monthly_payment', 2000.00, 'pending', 'November 2026', '2026-08-27', 'Monthly subscription for November 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:00:42', '2026-08-27 09:01:07', '2026-08-27 09:01:07', NULL),
(65, 2, 1, NULL, 'TRX-20260827-00057', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:30', '2026-08-27 09:46:30', NULL),
(66, 5, 1, NULL, 'TRX-20260827-00058', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:30', '2026-08-27 09:46:30', NULL),
(67, 6, 1, NULL, 'TRX-20260827-00059', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:30', '2026-08-27 09:46:30', NULL),
(68, 7, 1, NULL, 'TRX-20260827-00060', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:30', '2026-08-27 09:46:30', NULL),
(69, 8, 1, NULL, 'TRX-20260827-00061', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:31', '2026-08-27 09:46:31', NULL),
(70, 9, 1, NULL, 'TRX-20260827-00062', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:20', '2026-08-27 09:46:31', '2026-08-27 09:46:31', NULL),
(71, 2, 1, NULL, 'TRX-20260827-1095', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:08', '2026-08-27 23:35:08', NULL),
(72, 5, 1, NULL, 'TRX-20260827-1096', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:09', '2026-08-27 23:35:09', NULL),
(73, 6, 1, NULL, 'TRX-20260827-1097', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:09', '2026-08-27 23:35:09', NULL),
(74, 7, 1, NULL, 'TRX-20260827-1098', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:09', '2026-08-27 23:35:09', NULL),
(75, 8, 1, NULL, 'TRX-20260827-1099', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:09', '2026-08-27 23:35:09', NULL),
(76, 9, 1, NULL, 'TRX-20260827-1100', 'payment', 'monthly_payment', 2000.00, 'pending', 'August 2026', '2026-08-27', 'Monthly subscription for August 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 09:46:38', '2026-08-27 23:35:09', '2026-08-27 23:35:09', NULL),
(77, 2, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(78, 5, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(79, 6, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(80, 7, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(81, 8, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(82, 9, 1, NULL, 'TRX-20260828-9167', 'payment', 'monthly_payment', 2000.00, 'pending', 'October 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:24:56', '2026-08-28 01:16:15', NULL, NULL),
(83, 6, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'scscscsc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:25:24', '2026-08-28 01:52:01', '2026-08-28 01:52:01', NULL),
(84, 2, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 4000.00, 'pending', 'November 2026', '2026-08-31', 'dvdvdvd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, NULL),
(85, 5, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 4000.00, 'pending', 'November 2026', '2026-08-31', 'dvdvdvd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, NULL),
(86, 6, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 4000.00, 'pending', 'November 2026', '2026-08-31', 'dvdvdvd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, NULL),
(87, 7, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 4000.00, 'pending', 'November 2026', '2026-08-31', 'dvdvdvd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, NULL),
(88, 8, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 4000.00, 'pending', 'November 2026', '2026-08-31', 'dvdvdvd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, NULL),
(89, 9, 1, 1, 'TRX-20260828-4390', 'payment', 'monthly_payment', 1000.00, 'paid', 'November 2026', '2026-08-28', 'Subscription for November 2026 (Partial payment: BDT 1000 of BDT 4000) - Ref: dfbvdfbdfb | Note: dfbdfbdfb', 'http://localhost:8000/storage/receipts/receipt_89_1787892155_6a9111bb13e78.jpeg', '2026-08-27 22:42:35', 1000.00, 'dfbvdfbdfb', 'mobile_banking', 'dfbdfbdfb', NULL, '2026-08-27 22:32:44', '2026-08-28 01:16:15', NULL, 9),
(90, 9, 1, NULL, 'TRX-20260828-4390', 'payment', 'monthly_payment', 3000.00, 'pending', 'November 2026', '2026-08-28', 'Remaining due for Subscription for November 2026 (Due: BDT 3000) - Note: Ref: dfbvdfbdfb | Note: dfbdfbdfb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-27 22:43:18', '2026-08-28 01:16:15', NULL, NULL),
(91, 2, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:16:15', '2026-08-28 01:52:02', '2026-08-28 01:52:02', NULL),
(92, 5, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:16:15', '2026-08-28 01:52:02', '2026-08-28 01:52:02', NULL),
(93, 7, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:16:15', '2026-08-28 01:52:02', '2026-08-28 01:52:02', NULL),
(94, 8, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:16:15', '2026-08-28 01:52:03', '2026-08-28 01:52:03', NULL),
(95, 9, 1, NULL, 'TRX-20260828-8301', 'payment', 'monthly_payment', 2000.00, 'pending', 'December 2026', '2026-08-31', 'Monthly subscription for December 2026', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:16:15', '2026-08-28 01:52:03', '2026-08-28 01:52:03', NULL),
(96, 2, 1, NULL, 'hrthrhrh', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL),
(97, 5, 1, NULL, 'hrthrhrh-2', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL),
(98, 6, 1, NULL, 'hrthrhrh-3', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL),
(99, 7, 1, NULL, 'hrthrhrh-4', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL),
(100, 8, 1, NULL, 'hrthrhrh-5', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL),
(101, 9, 1, NULL, 'hrthrhrh-6', 'payment', 'monthly_payment', 2000.00, 'pending', 'February 2026', '2026-08-28', 'rgerg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-08-28 01:52:16', '2026-08-28 01:52:16', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `password`, `designation`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Super Admin', 'superadmin@alamanah.com', '$2y$12$.tODpI1pz/Tf1LDhS6DLLOtCZLm31RB3azAK9qpphx/YiIj3qArI2', NULL, 1, '2026-08-21 18:29:03', '2026-08-21 21:14:49', NULL),
(2, 4, 'A Member', 'A@g.com', '$2y$12$5ZMO5WZZk/bwskgIDyJjoeRs4CCKvqaOVu8tqRmTwqBssbbwn2HW6', NULL, 1, '2026-08-21 21:01:10', '2026-08-23 00:55:23', NULL),
(3, 2, 'AAAAAAAAA', 'AA@g.com', '$2y$12$.tODpI1pz/Tf1LDhS6DLLOtCZLm31RB3azAK9qpphx/YiIj3qArI2', 'ASCC', 1, '2026-08-21 21:01:10', '2026-08-21 21:14:49', NULL),
(4, 3, 'ACC', 'AC@g.com', '$2y$12$.tODpI1pz/Tf1LDhS6DLLOtCZLm31RB3azAK9qpphx/YiIj3qArI2', NULL, 1, '2026-08-21 21:01:10', '2026-08-21 21:14:49', NULL),
(5, 4, 'B Member', 'B@g.com', '$2y$12$gjLD5tRcipyptRupPMkvveApTTbLIapJPeeVN1Y6tQcf/6b6hX9oi', NULL, 1, '2026-08-23 00:51:59', '2026-08-23 00:55:23', NULL),
(6, 4, 'C Member', 'c@g.com', '$2y$12$ud2QWNiqHodshfoRe/stfuFljpOX8tcyIuVfwgHCuhwSfw7Qc5Qe6', NULL, 1, '2026-08-23 00:55:07', '2026-08-23 00:55:23', NULL),
(7, 4, 'D Member', 'd@g.com', '$2y$12$CaXbEoMCmARj9RVIsi.AlONLqFVSyQ12BO.tjZxT.YHacSd8REdNm', NULL, 1, '2026-08-23 00:55:24', '2026-08-23 00:55:24', NULL),
(8, 4, 'E Member', 'e@g.com', '$2y$12$uiX9S4lc7ubUqHTKKFBaeu1adpOcojTBRsnn2LEpo0EGxWnWt.jGW', NULL, 1, '2026-08-23 00:55:24', '2026-08-23 00:55:24', NULL),
(9, 4, 'F Member', 'f@g.com', '$2y$12$PHkH5igyXsIQj10s2LfrNODWe.McJbygj1QderxQnZhxbu8YkiVOm', NULL, 1, '2026-08-23 00:55:24', '2026-08-23 00:55:24', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_profiles`
--

CREATE TABLE `user_profiles` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `member_no` varchar(50) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `share_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `member_no`, `phone`, `address`, `share_amount`, `created_at`, `deleted_at`) VALUES
(3, 1, 'AMN-0001', NULL, NULL, 0.00, '2026-08-22 02:17:42', NULL),
(4, 2, 'www-6445', '21312414234', NULL, 0.00, '2026-08-22 03:01:10', NULL),
(5, 3, 'AMN-4265', '23525235235', NULL, 0.00, '2026-08-22 03:01:10', NULL),
(6, 4, 'ACC-8948', '35645436346', NULL, 0.00, '2026-08-22 03:01:10', NULL),
(7, 5, 'MEM-9785', '1w222343434', NULL, 0.00, '2026-08-23 06:51:59', NULL),
(8, 6, 'AMN-0008', '01700000003', 'Dhaka, Bangladesh', 5000.00, '2026-08-23 06:55:07', NULL),
(9, 7, 'AMN-0009', '01700000002', 'Dhaka, Bangladesh', 5000.00, '2026-08-23 06:55:24', NULL),
(10, 8, 'AMN-0010', '01700000005', 'Dhaka, Bangladesh', 5000.00, '2026-08-23 06:55:24', NULL),
(11, 9, 'AMN-0011', '01700000006', 'Dhaka, Bangladesh', 5000.00, '2026-08-23 06:55:24', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_logs_user` (`user_id`),
  ADD KEY `idx_activity_logs_table` (`table_name`,`record_id`);

--
-- Indexes for table `admin_payment_permissions`
--
ALTER TABLE `admin_payment_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_user_id` (`admin_user_id`),
  ADD KEY `fk_app_assigned_by` (`assigned_by`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `fdrs`
--
ALTER TABLE `fdrs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fdr_no` (`fdr_no`),
  ADD KEY `fk_fdrs_created_by` (`created_by`),
  ADD KEY `idx_fdrs_member` (`member_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `meeting_expenses`
--
ALTER TABLE `meeting_expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_meeting_expenses_created_by` (`created_by`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_user_read` (`user_id`,`is_read`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_permissions_module_action` (`module`,`action`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `profile_shares`
--
ALTER TABLE `profile_shares`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_profile_share` (`primary_user_id`,`shared_user_id`),
  ADD KEY `fk_profile_shares_shared` (`shared_user_id`);

--
-- Indexes for table `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_id` (`transaction_id`),
  ADD UNIQUE KEY `receipt_no` (`receipt_no`),
  ADD KEY `fk_receipts_created_by` (`created_by`),
  ADD KEY `idx_receipts_member` (`member_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_role_permission` (`role_id`,`permission_id`),
  ADD KEY `fk_role_permissions_permission` (`permission_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`),
  ADD KEY `fk_settings_updated_by` (`updated_by`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_transactions_created_by` (`created_by`),
  ADD KEY `fk_transactions_updated_by` (`updated_by`),
  ADD KEY `idx_transactions_member` (`member_id`),
  ADD KEY `idx_transactions_date` (`transaction_date`),
  ADD KEY `idx_transactions_trx_no` (`transaction_no`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_users_role` (`role_id`);

--
-- Indexes for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `member_no` (`member_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `admin_payment_permissions`
--
ALTER TABLE `admin_payment_permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fdrs`
--
ALTER TABLE `fdrs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meeting_expenses`
--
ALTER TABLE `meeting_expenses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `profile_shares`
--
ALTER TABLE `profile_shares`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `receipts`
--
ALTER TABLE `receipts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `user_profiles`
--
ALTER TABLE `user_profiles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `admin_payment_permissions`
--
ALTER TABLE `admin_payment_permissions`
  ADD CONSTRAINT `fk_app_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_app_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `fdrs`
--
ALTER TABLE `fdrs`
  ADD CONSTRAINT `fk_fdrs_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_fdrs_member` FOREIGN KEY (`member_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `meeting_expenses`
--
ALTER TABLE `meeting_expenses`
  ADD CONSTRAINT `fk_meeting_expenses_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `profile_shares`
--
ALTER TABLE `profile_shares`
  ADD CONSTRAINT `fk_profile_shares_primary` FOREIGN KEY (`primary_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_profile_shares_shared` FOREIGN KEY (`shared_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `fk_receipts_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receipts_member` FOREIGN KEY (`member_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receipts_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `fk_settings_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transactions_member` FOREIGN KEY (`member_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transactions_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_members_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
