-- ==========================
-- LAB2: Employee & FormerEmployee Exercises
-- ==========================

-- 1. Create Database and use it
CREATE DATABASE lab2;
USE lab2;

-- ==========================
-- Create Employee table
-- ==========================
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,        -- Employee ID as primary key
    Name VARCHAR(50),             -- Employee name
    Department VARCHAR(50),       -- Department name
    Salary DECIMAL(10,2),         -- Employee salary
    Bonus DECIMAL(10,2)           -- Employee bonus (can be NULL)
);

-- Insert sample employee data
INSERT INTO Employee VALUES
(101, 'Alice', 'HR', 50000, NULL),
(102, 'Bob', 'Finance', 60000, 5000),
(103, 'Charlie', 'IT', NULL, NULL),
(104, 'Diana', 'IT', 70000, 7000),
(105, 'Eve', 'HR', 55000, NULL);

-- ==========================
-- Exercise 1: Basic SQL Queries
-- ==========================

-- 1. Retrieve all employee records
SELECT * FROM Employee;

-- 2. Display names and salaries of employees in the IT department
SELECT Name, Salary
FROM Employee
WHERE Department = 'IT';

-- 3. Show employees with salary greater than 55000
SELECT * FROM Employee
WHERE Salary > 55000;

-- ==========================
-- Exercise 2: Set Operations
-- ==========================

-- Create FormerEmployee table
CREATE TABLE FormerEmployee (
    EmpID INT,        -- Employee ID
    Name VARCHAR(50)  -- Employee name
);

-- Insert sample former employees
INSERT INTO FormerEmployee VALUES
(103, 'Charlie'),
(106, 'Frank');

-- 1. List all employees (current and former) using UNION
SELECT EmpID, Name
FROM Employee
UNION
SELECT EmpID, Name
FROM FormerEmployee;

-- 2. Find employees who are both current and former using INTERSECT
SELECT EmpID, Name
FROM Employee
INTERSECT
SELECT EmpID, Name
FROM FormerEmployee;

-- 3. Show current employees who are not former using EXCEPT
SELECT EmpID, Name
FROM Employee
EXCEPT
SELECT EmpID, Name
FROM FormerEmployee;

-- ==========================
-- Exercise 3: Handling NULL Values
-- ==========================

-- 1. List employees whose bonus is not assigned (NULL)
SELECT EmpID, Name, Department, Salary
FROM Employee
WHERE Bonus IS NULL;

-- 2. Replace NULL bonuses and salaries with 0 using COALESCE (temporary in query)

SELECT EmpID, Name, Department, 
       COALESCE(Salary, 0) AS Salary,
       COALESCE(Bonus, 0) AS Bonus
FROM Employee;

-- 3. Compare salary and bonus using NULLIF
-- NULLIF returns NULL if Salary and Bonus are equal, otherwise returns Salary
SELECT EmpID, Name, Salary, Bonus,
       NULLIF(Salary, Bonus) AS SalaryVsBonus
FROM Employee;
