-- ==========================
-- 1. Create Database
-- ==========================

CREATE DATABASE lab4;
USE lab4;

-- ==========================
-- 1. Create Tables (Sample Schema)
-- ==========================
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE SalaryLog (
    LogID INT PRIMARY KEY,
    EmpID INT,
    Amount DECIMAL(10,2),
    LogDate DATE,
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

-- ==========================
-- 2. Insert Sample Data
-- ==========================
INSERT INTO Department VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

INSERT INTO Employee VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 3);

INSERT INTO SalaryLog VALUES
(1, 101, 5000.00, '2025-09-01'),
(2, 102, 6000.00, '2025-09-02'),
(3, 103, 7000.00, '2025-09-03');

-- ==========================
-- Lab Exercises
-- ==========================

-- 🔹 Exercise 1: Join Expressions

-- 1. Retrieve employee names with their department names (INNER JOIN)
SELECT E.Name AS Employee, D.DeptName AS Department
FROM Employee E
INNER JOIN Department D ON E.DeptID = D.DeptID;

-- 2. List all departments and their employees (LEFT JOIN)
SELECT D.DeptName, E.Name AS Employee
FROM Department D
LEFT JOIN Employee E ON D.DeptID = E.DeptID;

-- 3. Show employees with their salary logs (JOIN)
SELECT E.Name, S.Amount, S.LogDate
FROM Employee E
JOIN SalaryLog S ON E.EmpID = S.EmpID;

-- 4. Display departments with no employees (RIGHT JOIN)
SELECT D.DeptName
FROM Employee E
RIGHT JOIN Department D ON E.DeptID = D.DeptID
WHERE E.EmpID IS NULL;

-- 🔹 Exercise 2: Views

-- 1. Create a view: EmpDetails (employee, department, latest salary)
CREATE VIEW EmpDetails AS
SELECT E.Name AS Employee,
       D.DeptName AS Department,
       S.Amount AS LatestSalary
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
JOIN SalaryLog S ON E.EmpID = S.EmpID;

-- 2. Query the view to find employees in the 'IT' department
SELECT *
FROM EmpDetails
WHERE Department = 'IT';

-- 3. Update the view to include only employees with salary above 6000
CREATE OR REPLACE VIEW EmpDetails AS
SELECT E.Name AS Employee,
       D.DeptName AS Department,
       S.Amount AS LatestSalary
FROM Employee E
JOIN Department D ON E.DeptID = D.DeptID
JOIN SalaryLog S ON E.EmpID = S.EmpID
WHERE S.Amount > 6000;

-- 🔹 Exercise 3: Transactions

-- 1. Begin a transaction to insert a new employee and salary log
START TRANSACTION;

INSERT INTO Employee VALUES (104, 'Diana', 1);
INSERT INTO SalaryLog VALUES (4, 104, 5500.00, '2025-09-04');

-- 2. Use ROLLBACK to undo insertion
ROLLBACK;

-- 3. Use SAVEPOINT and partial rollback
START TRANSACTION;

INSERT INTO Employee VALUES (105, 'Edward', 2);
SAVEPOINT sp1;

INSERT INTO SalaryLog VALUES (5, 105, 6500.00, '2025-09-05');

-- Rolling back only the salary log insertion
ROLLBACK TO sp1;

-- 4. COMMIT to finalize changes (only employee remains)
COMMIT;

-- ==========================
-- Final Data Check
-- ==========================
SELECT * FROM Employee;
SELECT * FROM SalaryLog;
SELECT * FROM EmpDetails;