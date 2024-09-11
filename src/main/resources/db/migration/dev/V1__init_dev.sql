-- Tạo database
CREATE DATABASE IF NOT EXISTS saleApp_dev;
USE saleApp_dev;

-- Bảng users (Người dùng - bao gồm cả khách hàng và quản trị viên)
CREATE TABLE users (
                       user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       role ENUM('ADMIN', 'CUSTOMER', 'EMPLOYEE') NOT NULL,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_username (username),
                       INDEX idx_email (email)
);

-- Bảng customer_accounts (Thông tin chi tiết của khách hàng)
CREATE TABLE customer_accounts (
                                   customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                   user_id BIGINT,
                                   phone VARCHAR(20),
                                   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                   INDEX idx_user_id (user_id)
);

-- Bảng addresses (Địa chỉ của khách hàng)
CREATE TABLE addresses (
                           address_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           customer_id BIGINT,
                           address_type ENUM('billing', 'shipping'),
                           address TEXT,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (customer_id) REFERENCES customer_accounts(customer_id) ON DELETE CASCADE,
                           INDEX idx_customer_id (customer_id)
);

-- Bảng categories (Danh mục sản phẩm)
CREATE TABLE categories (
                            category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            name VARCHAR(255) NOT NULL,
                            INDEX idx_name (name)
);

-- Bảng products (Sản phẩm)
CREATE TABLE products (
                          product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          description TEXT,
                          price DECIMAL(10, 2) NOT NULL,
                          stock INT UNSIGNED DEFAULT 0,
                          sku VARCHAR(50) UNIQUE,
                          category_id BIGINT,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
                          INDEX idx_name (name),
                          INDEX idx_sku (sku)
);

CREATE TABLE images (
                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        file_name VARCHAR(255) NOT NULL,
                        file_type VARCHAR(255) NOT NULL,
                        image MEDIUMBLOB NOT NULL,
                        download_url VARCHAR(255),
                        product_id BIGINT,
                        FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Bảng order_status (Trạng thái đơn hàng)
CREATE TABLE order_status (
                              status_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                              status_name ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL UNIQUE
);

-- Bảng orders (Đơn hàng)
CREATE TABLE orders (
                        order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        customer_id BIGINT,
                        status_id BIGINT,
                        total_price DECIMAL(10, 2) NOT NULL,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (customer_id) REFERENCES customer_accounts(customer_id) ON DELETE CASCADE,
                        FOREIGN KEY (status_id) REFERENCES order_status(status_id) ON DELETE SET NULL,
                        INDEX idx_customer_id (customer_id),
                        INDEX idx_status_id (status_id)
);

-- Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
                             order_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             order_id BIGINT,
                             product_id BIGINT,
                             quantity INT UNSIGNED NOT NULL,
                             price DECIMAL(10, 2) NOT NULL,
                             FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                             INDEX idx_order_id (order_id),
                             INDEX idx_product_id (product_id)
);

-- Bảng payment_methods (Phương thức thanh toán)
CREATE TABLE payment_methods (
                                 method_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 method_name ENUM('Credit Card', 'PayPal', 'Bank Transfer') NOT NULL,
                                 description TEXT
);

-- Bảng payments (Thanh toán)
CREATE TABLE payments (
                          payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          order_id BIGINT,
                          method_id BIGINT,
                          payment_status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
                          payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                          FOREIGN KEY (method_id) REFERENCES payment_methods(method_id) ON DELETE CASCADE,
                          INDEX idx_order_id (order_id),
                          INDEX idx_method_id (method_id)
);

-- Bảng shopping_carts (Giỏ hàng)
CREATE TABLE shopping_carts (
                                cart_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                customer_id BIGINT,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (customer_id) REFERENCES customer_accounts(customer_id) ON DELETE CASCADE,
                                INDEX idx_customer_id (customer_id)
);

-- Bảng cart_items (Chi tiết giỏ hàng)
CREATE TABLE cart_items (
                            cart_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            cart_id BIGINT,
                            product_id BIGINT,
                            quantity INT UNSIGNED NOT NULL,
                            FOREIGN KEY (cart_id) REFERENCES shopping_carts(cart_id) ON DELETE CASCADE,
                            FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                            INDEX idx_cart_id (cart_id),
                            INDEX idx_product_id (product_id)
);

-- Bảng discounts (Giảm giá)
CREATE TABLE discounts (
                           discount_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           code VARCHAR(50) NOT NULL UNIQUE,
                           discount_type ENUM('percentage', 'fixed_amount') NOT NULL,
                           value DECIMAL(10, 2) NOT NULL,
                           start_date TIMESTAMP,
                           end_date TIMESTAMP,
                           INDEX idx_code (code)
);

-- Bảng order_discounts (Mã giảm giá áp dụng cho đơn hàng)
CREATE TABLE order_discounts (
                                 order_id BIGINT,
                                 discount_id BIGINT,
                                 PRIMARY KEY (order_id, discount_id),
                                 FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                                 FOREIGN KEY (discount_id) REFERENCES discounts(discount_id) ON DELETE CASCADE
);

-- Bảng audit_logs (Ghi lại các thay đổi trong hệ thống)
CREATE TABLE audit_logs (
                            log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            user_id BIGINT,
                            action VARCHAR(255),
                            table_name VARCHAR(255),
                            record_id BIGINT,
                            description TEXT,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
                            INDEX idx_user_id (user_id)
);

-- Bảng oauth_users (Người dùng xác thực OAuth)
CREATE TABLE oauth_users (
                             oauth_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             user_id BIGINT,
                             provider ENUM('Google', 'Facebook') NOT NULL,
                             provider_user_id VARCHAR(255),
                             FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                             INDEX idx_user_id (user_id)
);

-- Bảng refresh_tokens (Lưu trữ refresh token)
CREATE TABLE refresh_tokens (
                                token_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                user_id BIGINT,
                                token VARCHAR(500) NOT NULL,
                                expires_at TIMESTAMP NOT NULL,
                                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                INDEX idx_user_id (user_id)
);

-- Bảng token_blacklist (Lưu trữ các token bị thu hồi)
CREATE TABLE token_blacklist (
                                 token_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                 token VARCHAR(500) NOT NULL,
                                 blacklisted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 INDEX idx_token (token)
);
