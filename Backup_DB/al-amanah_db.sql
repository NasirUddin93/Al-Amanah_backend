-- =====================================================
-- Database: al_amanah_db
-- System: Al-Amanah Society Management System
-- DB Type: MySQL 8+ / MariaDB
-- =====================================================

CREATE DATABASE IF NOT EXISTS al_amanah_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE al_amanah_db;

-- =====================================================
-- 1) roles
-- =====================================================
CREATE TABLE roles (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL
) ENGINE = InnoDB;

-- =====================================================
-- 2) users
-- =====================================================
CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_id INT UNSIGNED NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  designation VARCHAR(100) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_users_role
    FOREIGN KEY (role_id) REFERENCES roles (id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =====================================================
-- 3) permissions
-- =====================================================
CREATE TABLE permissions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  module VARCHAR(50) NOT NULL,
  action VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  UNIQUE KEY uq_permissions_module_action (module, action)
) ENGINE = InnoDB;

-- =====================================================
-- 4) role_permissions (roles <-> permissions)
-- =====================================================
CREATE TABLE role_permissions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  role_id INT UNSIGNED NOT NULL,
  permission_id INT UNSIGNED NOT NULL,
  UNIQUE KEY uq_role_permission (role_id, permission_id),

  CONSTRAINT fk_role_permissions_role
    FOREIGN KEY (role_id) REFERENCES roles (id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_role_permissions_permission
    FOREIGN KEY (permission_id) REFERENCES permissions (id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

-- =====================================================
-- 5) admin_payment_permissions
--    Super Admin decides which Admin can change payment values
-- =====================================================
CREATE TABLE admin_payment_permissions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  admin_user_id INT UNSIGNED NOT NULL UNIQUE,
  assigned_by INT UNSIGNED NOT NULL,
  can_change_payment TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_app_admin
    FOREIGN KEY (admin_user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_app_assigned_by
    FOREIGN KEY (assigned_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =====================================================
-- 6) members_profiles (one profile per user)
-- =====================================================
CREATE TABLE members_profiles (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL UNIQUE,
  member_no VARCHAR(50) NOT NULL UNIQUE,
  phone VARCHAR(30) NULL,
  address TEXT NULL,
  share_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_members_profiles_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =====================================================
-- 7) transactions
-- =====================================================
CREATE TABLE transactions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  member_id INT UNSIGNED NOT NULL,
  created_by INT UNSIGNED NOT NULL,
  updated_by INT UNSIGNED NULL,
  transaction_no VARCHAR(50) NOT NULL UNIQUE,
  type ENUM('payment','share','fdr','expense','other') NOT NULL DEFAULT 'payment',
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  transaction_date DATE NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_transactions_member
    FOREIGN KEY (member_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_transactions_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_transactions_updated_by
    FOREIGN KEY (updated_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  INDEX idx_transactions_member (member_id),
  INDEX idx_transactions_date (transaction_date)
) ENGINE = InnoDB;

-- =====================================================
-- 8) receipts (one receipt per transaction)
-- =====================================================
CREATE TABLE receipts (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  transaction_id INT UNSIGNED NOT NULL UNIQUE,
  member_id INT UNSIGNED NOT NULL,
  created_by INT UNSIGNED NOT NULL,
  receipt_no VARCHAR(50) NOT NULL UNIQUE,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  payment_method ENUM('cash','bank','mobile_banking','other') NOT NULL DEFAULT 'cash',
  receipt_date DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_receipts_transaction
    FOREIGN KEY (transaction_id) REFERENCES transactions (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_receipts_member
    FOREIGN KEY (member_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_receipts_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  INDEX idx_receipts_member (member_id)
) ENGINE = InnoDB;

-- =====================================================
-- 9) meeting_expenses
-- =====================================================
CREATE TABLE meeting_expenses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  created_by INT UNSIGNED NOT NULL,
  title VARCHAR(150) NOT NULL,
  expense_date DATE NOT NULL,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  description TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_meeting_expenses_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- =====================================================
-- 10) fdrs
-- =====================================================
CREATE TABLE fdrs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  member_id INT UNSIGNED NOT NULL,
  created_by INT UNSIGNED NOT NULL,
  fdr_no VARCHAR(50) NOT NULL UNIQUE,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  start_date DATE NOT NULL,
  maturity_date DATE NULL,
  status ENUM('active','closed','cancelled') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL DEFAULT NULL,

  CONSTRAINT fk_fdrs_member
    FOREIGN KEY (member_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  CONSTRAINT fk_fdrs_created_by
    FOREIGN KEY (created_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,

  INDEX idx_fdrs_member (member_id)
) ENGINE = InnoDB;

-- =====================================================
-- 11) notifications
-- =====================================================
CREATE TABLE notifications (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  title VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL DEFAULT 'system',
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_notifications_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  INDEX idx_notifications_user_read (user_id, is_read)
) ENGINE = InnoDB;

-- =====================================================
-- 12) activity_logs
-- =====================================================
CREATE TABLE activity_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NULL,
  action VARCHAR(50) NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id INT UNSIGNED NULL,
  old_values JSON NULL,
  new_values JSON NULL,
  ip_address VARCHAR(45) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT fk_activity_logs_user
    FOREIGN KEY (user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  INDEX idx_activity_logs_user (user_id),
  INDEX idx_activity_logs_table (table_name, record_id)
) ENGINE = InnoDB;

-- =====================================================
-- 13) settings
-- =====================================================
CREATE TABLE settings (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  updated_by INT UNSIGNED NULL,
  setting_key VARCHAR(100) NOT NULL UNIQUE,
  setting_value VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_settings_updated_by
    FOREIGN KEY (updated_by) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = InnoDB;

-- =====================================================
-- 14) profile_shares (husband / wife shared profiles)
-- =====================================================
CREATE TABLE profile_shares (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  primary_user_id INT UNSIGNED NOT NULL,
  shared_user_id INT UNSIGNED NOT NULL,
  relation VARCHAR(50) NOT NULL,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_profile_share (primary_user_id, shared_user_id),

  CONSTRAINT fk_profile_shares_primary
    FOREIGN KEY (primary_user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE CASCADE,

  CONSTRAINT fk_profile_shares_shared
    FOREIGN KEY (shared_user_id) REFERENCES users (id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;


-- =====================================================
-- SEED DATA (starter records)
-- =====================================================

-- Roles
INSERT INTO roles (name, description) VALUES
('super_admin', 'Full control. Assigns roles, designations, and payment permissions.'),
('admin', 'Views all transactions, prints reports, receives notifications.'),
('accountant', 'Views and manages member receipts.'),
('member', 'Views own profile, own transactions, and own notifications.');

-- Basic permissions
INSERT INTO permissions (module, action, description) VALUES
('transactions', 'view', 'View all transactions'),
('transactions', 'update_payment', 'Change payment values'),
('receipts', 'manage', 'Create and manage member receipts'),
('reports', 'print', 'Print transaction and receipt reports'),
('settings', 'manage', 'Manage system settings and payment values'),
('users', 'manage', 'Create and manage users and roles');

-- Give Super Admin all permissions (role id 1)
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Give Admin view + reports permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions WHERE (module = 'transactions' AND action = 'view')
   OR (module = 'reports' AND action = 'print');

-- Give Accountant receipt management
INSERT INTO role_permissions (role_id, permission_id)
SELECT 3, id FROM permissions WHERE module = 'receipts' AND action = 'manage';

-- Default payment settings (2000, 3000)
INSERT INTO settings (setting_key, setting_value, description) VALUES
('payment_amount_1', '2000', 'Default payment amount option 1'),
('payment_amount_2', '3000', 'Default payment amount option 2');