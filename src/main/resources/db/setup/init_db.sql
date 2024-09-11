-- File: init_db.sql

-- Create the databases if they do not exist
CREATE DATABASE IF NOT EXISTS saleApp_dev;
CREATE DATABASE IF NOT EXISTS saleApp_test;
CREATE DATABASE IF NOT EXISTS saleApp_prod;

-- Development User
CREATE USER IF NOT EXISTS 'devUser'@'localhost' IDENTIFIED BY 'devPass';
GRANT ALL PRIVILEGES ON saleApp_dev.* TO 'devUser'@'localhost';

-- Test User
CREATE USER IF NOT EXISTS 'testUser'@'localhost' IDENTIFIED BY 'testPass';
GRANT CREATE, DROP, INSERT, UPDATE, DELETE, SELECT ON saleApp_test.* TO 'testUser'@'localhost';

-- Production User
CREATE USER IF NOT EXISTS 'prodUser'@'localhost' IDENTIFIED BY 'prodPass';
GRANT INSERT, UPDATE, DELETE, SELECT ON saleApp_prod.* TO 'prodUser'@'localhost';

-- Reload privilege tables to apply changes
FLUSH PRIVILEGES;
