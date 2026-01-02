# Day 11: Database Fundamentals & MySQL on AWS EC2

## 📚 Learning Objectives
- Understand database concepts and types
- Learn relational vs non-relational databases
- Install and configure MySQL on EC2
- Master CRUD operations (Create, Read, Update, Delete)
- Implement database security best practices

## 🎯 Database Fundamentals

### What is a Database?
A database is an organized collection of structured information stored electronically in a computer system. It's managed by a Database Management System (DBMS).

### Types of Databases

#### 1. Relational Databases (SQL)
- **Structure**: Tables with rows and columns
- **Relationships**: Foreign keys link tables
- **ACID Properties**: Atomicity, Consistency, Isolation, Durability
- **Examples**: MySQL, PostgreSQL, Oracle, SQL Server

#### 2. Non-Relational Databases (NoSQL)
- **Document**: MongoDB, CouchDB
- **Key-Value**: Redis, DynamoDB
- **Column-Family**: Cassandra, HBase
- **Graph**: Neo4j, Amazon Neptune

### Database Comparison

| Feature | SQL Databases | NoSQL Databases |
|---------|---------------|-----------------|
| **Schema** | Fixed schema | Flexible schema |
| **Scaling** | Vertical (scale up) | Horizontal (scale out) |
| **ACID** | Full ACID compliance | Eventually consistent |
| **Queries** | Complex SQL queries | Simple queries |
| **Use Cases** | Financial, CRM | Big data, real-time web |

## 🛠️ Practical Lab: MySQL on EC2

### Prerequisites
- AWS EC2 instance (t2.micro)
- Security group allowing SSH (22) and MySQL (3306)
- Basic Linux command knowledge

### Lab Architecture
```
Internet → Security Group → EC2 Instance → MySQL Server
                ↓
        Database: company_db
        Tables: employees, departments
        CRUD Operations
```

## 🚀 Step-by-Step Implementation

### Step 1: Launch EC2 Instance

```bash
# Instance Configuration
AMI: Amazon Linux 2023
Instance Type: t2.micro
Security Group: Allow SSH (22) and MySQL (3306)
Key Pair: your-key-pair
Storage: 8GB gp3
```

**Security Group Rules:**
```
Type: SSH, Port: 22, Source: Your IP
Type: MySQL/Aurora, Port: 3306, Source: Your IP
```

### Step 2: Connect to EC2 and Update System

```bash
# Connect via SSH
ssh -i your-key.pem ec2-user@your-ec2-ip

# Update system packages
sudo yum update -y

# Install MySQL server
sudo yum install mysql-server -y

# Start MySQL service
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Check MySQL status
sudo systemctl status mysqld
```

### Step 3: Secure MySQL Installation

```bash
# Run MySQL secure installation
sudo mysql_secure_installation

# Follow prompts:
# - Set root password: MySecurePass123!
# - Remove anonymous users: Y
# - Disallow root login remotely: Y
# - Remove test database: Y
# - Reload privilege tables: Y
```

### Step 4: Connect to MySQL

```bash
# Connect as root
mysql -u root -p
# Enter password: MySecurePass123!

# Check MySQL version
SELECT VERSION();

# Show databases
SHOW DATABASES;
```

### Step 5: Create Database and User

```sql
-- Create database
CREATE DATABASE company_db;

-- Use the database
USE company_db;

-- Create a new user
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'AppPass123!';

-- Grant privileges
GRANT ALL PRIVILEGES ON company_db.* TO 'app_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show current user
SELECT USER();
```

### Step 6: Create Tables (DDL Operations)

```sql
-- Create departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    salary DECIMAL(10,2),
    dept_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Show tables
SHOW TABLES;

-- Describe table structure
DESCRIBE employees;
DESCRIBE departments;
```

## 🔧 CRUD Operations Practice

### CREATE Operations (INSERT)

```sql
-- Insert departments
INSERT INTO departments (dept_name, location) VALUES
('Engineering', 'New York'),
('Marketing', 'Los Angeles'),
('Sales', 'Chicago'),
('HR', 'Boston'),
('Finance', 'Miami');

-- Insert employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, dept_id) VALUES
('John', 'Doe', 'john.doe@company.com', '555-0101', '2023-01-15', 75000.00, 1),
('Jane', 'Smith', 'jane.smith@company.com', '555-0102', '2023-02-20', 68000.00, 2),
('Mike', 'Johnson', 'mike.johnson@company.com', '555-0103', '2023-03-10', 72000.00, 1),
('Sarah', 'Wilson', 'sarah.wilson@company.com', '555-0104', '2023-04-05', 65000.00, 3),
('David', 'Brown', 'david.brown@company.com', '555-0105', '2023-05-12', 70000.00, 4);

-- Verify insertions
SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM employees;
```

### READ Operations (SELECT)

```sql
-- Basic SELECT queries
SELECT * FROM departments;
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, email FROM employees;

-- WHERE clause
SELECT * FROM employees WHERE salary > 70000;
SELECT * FROM employees WHERE dept_id = 1;

-- JOIN operations
SELECT 
    e.first_name, 
    e.last_name, 
    e.salary, 
    d.dept_name 
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Aggregate functions
SELECT COUNT(*) as total_employees FROM employees;
SELECT AVG(salary) as average_salary FROM employees;
SELECT MAX(salary) as highest_salary FROM employees;
SELECT MIN(salary) as lowest_salary FROM employees;

-- GROUP BY
SELECT 
    d.dept_name, 
    COUNT(e.emp_id) as employee_count,
    AVG(e.salary) as avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY hire_date ASC;
```

### UPDATE Operations

```sql
-- Update single record
UPDATE employees 
SET salary = 80000.00 
WHERE emp_id = 1;

-- Update multiple records
UPDATE employees 
SET salary = salary * 1.05 
WHERE dept_id = 1;

-- Update with JOIN
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.10
WHERE d.dept_name = 'Engineering';

-- Verify updates
SELECT emp_id, first_name, last_name, salary FROM employees;
```

### DELETE Operations

```sql
-- Delete specific record
DELETE FROM employees WHERE emp_id = 5;

-- Delete with condition
DELETE FROM employees WHERE salary < 60000;

-- Verify deletions
SELECT COUNT(*) FROM employees;
SELECT * FROM employees;

-- Note: Cannot delete department if employees exist (foreign key constraint)
-- DELETE FROM departments WHERE dept_id = 1; -- This would fail
```

## 🔍 Advanced Database Operations

### Indexes for Performance

```sql
-- Create indexes
CREATE INDEX idx_employee_email ON employees(email);
CREATE INDEX idx_employee_dept ON employees(dept_id);
CREATE INDEX idx_employee_salary ON employees(salary);

-- Show indexes
SHOW INDEX FROM employees;

-- Analyze query performance
EXPLAIN SELECT * FROM employees WHERE email = 'john.doe@company.com';
```

### Views for Data Abstraction

```sql
-- Create view
CREATE VIEW employee_details AS
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) as full_name,
    e.email,
    e.salary,
    d.dept_name,
    d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Use view
SELECT * FROM employee_details;
SELECT * FROM employee_details WHERE dept_name = 'Engineering';
```

### Stored Procedures

```sql
-- Create stored procedure
DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(50))
BEGIN
    SELECT 
        e.first_name,
        e.last_name,
        e.email,
        e.salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
END //
DELIMITER ;

-- Call stored procedure
CALL GetEmployeesByDepartment('Engineering');
```

## 🔐 Database Security Best Practices

### User Management

```sql
-- Create application user with limited privileges
CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'ReadPass123!';
GRANT SELECT ON company_db.* TO 'readonly_user'@'%';

-- Create backup user
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'BackupPass123!';
GRANT SELECT, LOCK TABLES ON company_db.* TO 'backup_user'@'localhost';

-- Show users
SELECT User, Host FROM mysql.user;
```

### Backup and Restore

```bash
# Create database backup
mysqldump -u root -p company_db > company_db_backup.sql

# Restore database
mysql -u root -p company_db < company_db_backup.sql

# Backup specific table
mysqldump -u root -p company_db employees > employees_backup.sql
```

## 📊 Database Monitoring

### Performance Monitoring

```sql
-- Show running processes
SHOW PROCESSLIST;

-- Show database status
SHOW STATUS LIKE 'Connections';
SHOW STATUS LIKE 'Queries';
SHOW STATUS LIKE 'Uptime';

-- Show variables
SHOW VARIABLES LIKE 'max_connections';
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
```

### Log Analysis

```bash
# Check MySQL error log
sudo tail -f /var/log/mysqld.log

# Check slow query log (if enabled)
sudo tail -f /var/log/mysql/slow.log
```

## 🎯 Common Database Scenarios

### Scenario 1: Employee Management System

```sql
-- Add new employee
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, dept_id)
VALUES ('Alice', 'Cooper', 'alice.cooper@company.com', '555-0106', CURDATE(), 73000.00, 2);

-- Promote employee (salary increase)
UPDATE employees 
SET salary = salary * 1.15 
WHERE emp_id = 1;

-- Transfer employee to different department
UPDATE employees 
SET dept_id = 2 
WHERE emp_id = 3;

-- Get department statistics
SELECT 
    d.dept_name,
    COUNT(e.emp_id) as total_employees,
    AVG(e.salary) as avg_salary,
    MAX(e.salary) as max_salary,
    MIN(e.salary) as min_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
```

### Scenario 2: Salary Analysis

```sql
-- Employees earning above average
SELECT 
    first_name, 
    last_name, 
    salary,
    (SELECT AVG(salary) FROM employees) as avg_salary
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Top 3 highest paid employees
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- Salary distribution by department
SELECT 
    d.dept_name,
    CASE 
        WHEN AVG(e.salary) > 75000 THEN 'High'
        WHEN AVG(e.salary) > 65000 THEN 'Medium'
        ELSE 'Low'
    END as salary_category
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;
```

## 🔧 Troubleshooting Common Issues

### Connection Issues

```bash
# Check MySQL service status
sudo systemctl status mysqld

# Restart MySQL service
sudo systemctl restart mysqld

# Check MySQL port
sudo netstat -tlnp | grep 3306

# Test connection
mysql -u root -p -h localhost
```

### Permission Issues

```sql
-- Check user privileges
SHOW GRANTS FOR 'app_user'@'localhost';

-- Reset user password
ALTER USER 'app_user'@'localhost' IDENTIFIED BY 'NewPassword123!';

-- Grant additional privileges
GRANT CREATE, DROP ON company_db.* TO 'app_user'@'localhost';
FLUSH PRIVILEGES;
```

## 📝 Key Commands Summary

```sql
-- Database Operations
CREATE DATABASE database_name;
USE database_name;
DROP DATABASE database_name;

-- Table Operations
CREATE TABLE table_name (...);
ALTER TABLE table_name ADD COLUMN ...;
DROP TABLE table_name;

-- CRUD Operations
INSERT INTO table_name VALUES (...);
SELECT * FROM table_name WHERE ...;
UPDATE table_name SET ... WHERE ...;
DELETE FROM table_name WHERE ...;

-- User Management
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
GRANT privileges ON database.* TO 'username'@'host';
FLUSH PRIVILEGES;
```

## 🏆 Lab Completion Checklist

- [ ] EC2 instance launched with proper security groups
- [ ] MySQL server installed and configured
- [ ] Database and tables created successfully
- [ ] Sample data inserted (departments and employees)
- [ ] All CRUD operations performed and tested
- [ ] JOIN queries executed successfully
- [ ] Indexes and views created
- [ ] User management implemented
- [ ] Backup and restore tested
- [ ] Performance monitoring queries executed

## 🎤 Interview Questions & Answers

### Fresher Level Questions

**Q1: What is a Database?**
**A:** A database is an organized collection of structured information stored electronically in a computer system, managed by a Database Management System (DBMS).

**Q2: What is the difference between SQL and NoSQL databases?**
**A:** 
- **SQL**: Structured, fixed schema, ACID compliant, complex queries (MySQL, PostgreSQL)
- **NoSQL**: Flexible schema, horizontally scalable, eventually consistent (MongoDB, DynamoDB)

**Q3: What are CRUD operations?**
**A:** 
- **Create**: INSERT - Add new data
- **Read**: SELECT - Retrieve data
- **Update**: UPDATE - Modify existing data
- **Delete**: DELETE - Remove data

**Q4: What is a Primary Key?**
**A:** A primary key is a unique identifier for each record in a table. It cannot be NULL and must be unique across all rows.

**Q5: What is a Foreign Key?**
**A:** A foreign key is a field that links two tables together. It refers to the primary key of another table, establishing relationships between tables.

### Intermediate Level Questions

**Q6: Explain ACID properties in databases.**
**A:** 
- **Atomicity**: All operations in a transaction succeed or fail together
- **Consistency**: Database remains in valid state after transactions
- **Isolation**: Concurrent transactions don't interfere with each other
- **Durability**: Committed transactions persist even after system failure

**Q7: What are different types of JOINs in SQL?**
**A:** 
- **INNER JOIN**: Returns matching records from both tables
- **LEFT JOIN**: Returns all records from left table, matching from right
- **RIGHT JOIN**: Returns all records from right table, matching from left
- **FULL OUTER JOIN**: Returns all records when there's a match in either table

**Q8: What is database normalization?**
**A:** Process of organizing data to reduce redundancy and improve data integrity. Common forms:
- **1NF**: Eliminate duplicate columns
- **2NF**: Remove partial dependencies
- **3NF**: Remove transitive dependencies

**Q9: What are database indexes and why are they important?**
**A:** Indexes are data structures that improve query performance by creating shortcuts to data. They speed up SELECT operations but can slow down INSERT/UPDATE/DELETE operations.

**Q10: How do you optimize database performance?**
**A:** 
- Create appropriate indexes
- Optimize queries (avoid SELECT *)
- Use proper data types
- Normalize database design
- Regular maintenance (ANALYZE, OPTIMIZE)
- Monitor slow queries

### Advanced Level Questions

**Q11: Explain database transactions and isolation levels.**
**A:** Transactions ensure data integrity. Isolation levels:
- **READ UNCOMMITTED**: Lowest isolation, dirty reads possible
- **READ COMMITTED**: Prevents dirty reads
- **REPEATABLE READ**: Prevents dirty and non-repeatable reads
- **SERIALIZABLE**: Highest isolation, prevents all phenomena

**Q12: What is the difference between clustered and non-clustered indexes?**
**A:** 
- **Clustered**: Physical order of data matches index order, one per table
- **Non-clustered**: Separate structure pointing to data rows, multiple allowed

**Q13: How would you handle database backup and recovery?**
**A:** 
- **Full Backup**: Complete database backup
- **Incremental Backup**: Only changed data since last backup
- **Point-in-time Recovery**: Restore to specific timestamp
- **Test Recovery**: Regular testing of backup restoration

**Q14: What are stored procedures and their advantages?**
**A:** Pre-compiled SQL code stored in database. Advantages:
- Better performance (pre-compiled)
- Code reusability
- Enhanced security
- Centralized business logic
- Reduced network traffic

**Q15: How do you secure a MySQL database?**
**A:** 
- Use strong passwords
- Create specific user accounts (avoid root)
- Grant minimum required privileges
- Enable SSL/TLS encryption
- Regular security updates
- Monitor access logs
- Use firewalls and security groups

## 📚 Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [SQL Tutorial](https://www.w3schools.com/sql/)
- [Database Design Best Practices](https://www.vertabelo.com/blog/database-design-best-practices/)
- [AWS RDS MySQL](https://aws.amazon.com/rds/mysql/)

## 🎯 Key Takeaways

1. **Database Types**: SQL for structured data, NoSQL for flexibility
2. **CRUD Operations**: Foundation of all database interactions
3. **ACID Properties**: Ensure data integrity and consistency
4. **Normalization**: Reduces redundancy and improves integrity
5. **Indexes**: Critical for query performance optimization
6. **JOINs**: Enable data retrieval from multiple related tables
7. **Security**: User management and access control essential
8. **Backup**: Regular backups prevent data loss
9. **Monitoring**: Performance tracking for optimization
10. **Transactions**: Ensure data consistency in multi-step operations

---

**Next Day Preview**: Day 12 will cover AWS RDS (Relational Database Service) - Managed database services and migration strategies.

**Instructor**: Neeraj Kumar  
**Date**: Day 11 - AWS DevOps Batch 4  
**Duration**: 3 hours (Theory: 1 hour, Practical: 2 hours)

## 🎉 Congratulations!

You've successfully mastered database fundamentals and MySQL implementation on AWS EC2. These skills are essential for any application development and data management in the cloud!