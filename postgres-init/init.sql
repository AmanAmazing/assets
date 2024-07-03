-- Manufacturers Table
CREATE TABLE manufacturers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Categories Table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Locations Table
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Status Labels Table
CREATE TABLE status_labels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Models Table
CREATE TABLE models (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    manufacturer_id INT REFERENCES manufacturers(id),
    category_id INT REFERENCES categories(id),
    model_number VARCHAR(255),
    eol_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Assets Table
CREATE TABLE assets (
    id SERIAL PRIMARY KEY,
    tag VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    model_id INT REFERENCES models(id),
    serial VARCHAR(255),
    status_id INT REFERENCES status_labels(id),
    purchase_date DATE,
    warranty_expiration DATE,
    cost DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Custom Fields Table
CREATE TABLE custom_fields (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    field_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Custom Field Values Table
CREATE TABLE custom_field_values (
    id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES assets(id),
    custom_field_id INT REFERENCES custom_fields(id),
    value VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Companies Table
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Departments Table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Users Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    company_id INT REFERENCES companies(id),
    primary_department_id INT REFERENCES departments(id),
    role_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Roles Table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Permissions Table
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Role Permissions Table
CREATE TABLE role_permissions (
    role_id INT REFERENCES roles(id),
    permission_id INT REFERENCES permissions(id),
    PRIMARY KEY (role_id, permission_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- User Roles Table
CREATE TABLE user_roles (
    user_id INT REFERENCES users(id),
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- User Departments Table
CREATE TABLE user_departments (
    user_id INT REFERENCES users(id),
    department_id INT REFERENCES departments(id),
    PRIMARY KEY (user_id, department_id)
);

-- Asset Assignments Table
CREATE TABLE asset_assignments (
    id SERIAL PRIMARY KEY,
    asset_id INT REFERENCES assets(id),
    user_id INT REFERENCES users(id),
    location_id INT REFERENCES locations(id),
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    return_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    CHECK (user_id IS NOT NULL OR location_id IS NOT NULL),
    CHECK (NOT (user_id IS NOT NULL AND location_id IS NOT NULL))
);

-- Insert Manufacturers
INSERT INTO manufacturers (name) VALUES ('Dell'), ('HP'), ('Apple');

-- Insert Categories
INSERT INTO categories (name) VALUES ('Laptop'), ('Monitor'), ('Phone'), ('Tablet'), ('Printer');

-- Insert Locations
INSERT INTO locations (name) VALUES ('Headquarters'), ('Branch Office'), ('Warehouse');

-- Insert Status Labels
INSERT INTO status_labels (name) VALUES ('In Use'), ('In Storage'), ('Under Maintenance'), ('Retired');

-- Insert Models
INSERT INTO models (name, manufacturer_id, category_id, model_number, eol_date) 
VALUES ('Latitude 5400', 1, 1, 'LAT5400', '2025-12-31'), 
       ('EliteBook 840', 2, 1, 'EB840', '2024-12-31'), 
       ('iPhone 12', 3, 3, 'IP12', '2026-12-31');

-- Insert Assets
INSERT INTO assets (tag, name, model_id, serial, status_id, purchase_date, warranty_expiration, cost) 
VALUES ('A1001', 'Dell Latitude 5400', 1, 'SN123456', 1, '2023-01-01', '2025-01-01', 1200.00),
       ('A1002', 'HP EliteBook 840', 2, 'SN123457', 1, '2023-01-15', '2024-01-15', 1500.00),
       ('A1003', 'Apple iPhone 12', 3, 'SN123458', 1, '2023-02-01', '2026-02-01', 1000.00);

-- Insert Custom Fields
INSERT INTO custom_fields (name, field_type) VALUES ('IMEI Number', 'string'), ('Screen Size', 'string'), ('Color', 'string');

-- Insert Custom Field Values
INSERT INTO custom_field_values (asset_id, custom_field_id, value) 
VALUES (3, 1, '123456789012345'),  -- IMEI Number for iPhone 12
       (3, 2, '6.1 inches'),       -- Screen Size for iPhone 12
       (2, 3, 'Silver'),           -- Color for HP EliteBook 840
       (1, 3, 'Black');            -- Color for Dell Latitude 5400

-- Insert Companies
INSERT INTO companies (name) VALUES ('Tech Corp'), ('Biz Solutions');

-- Insert Departments
INSERT INTO departments (name) VALUES ('IT'), ('HR'), ('Finance');

-- Insert Users
INSERT INTO users (first_name, last_name, email, password, company_id, primary_department_id, role_id) 
VALUES ('John', 'Doe', 'john.doe@techcorp.com', 'hashed_password', 1, 1, 1),
       ('Jane', 'Smith', 'jane.smith@bizsolutions.com', 'hashed_password', 2, 2, 2);

-- Insert Roles
INSERT INTO roles (name, description) VALUES ('Admin', 'Full access to all features and settings'),
                                            ('Manager', 'Can manage assets and users with some restrictions'),
                                            ('User', 'Basic access, limited to viewing and updating own assigned assets'),
                                            ('Limited User', 'Restricted access, mainly for viewing purposes');

-- Insert Permissions
INSERT INTO permissions (name, description) VALUES ('view_assets', 'Ability to view asset details'),
                                                   ('create_assets', 'Ability to add new assets'),
                                                   ('update_assets', 'Ability to modify existing assets'),
                                                   ('delete_assets', 'Ability to delete assets'),
                                                   ('manage_users', 'Ability to add, update, or delete users'),
                                                   ('view_reports', 'Ability to access and view reports');

-- Assign Permissions to Roles
-- Admin role gets all permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES 
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6);

-- Manager role gets a subset of permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES 
(2, 1), (2, 2), (2, 3), (2, 6);

-- User role gets basic permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES 
(3, 1), (3, 3);

-- Limited User role gets view-only permissions
