CREATE DATABASE lab3;
USE lab3;
-- ==========================
-- 1. Create Database
-- ==========================

CREATE DATABASE lab3;
USE lab3;lab2lab2customer
-- ==========================
-- 2. Create Tables
-- ==========================
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    Amount DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- ==========================
-- 3. Insert Sample Data
-- ==========================
INSERT INTO Customer VALUES
(1, 'Alice', 'Dhaka'),
(2, 'Bob', 'Chittagong'),
(3, 'Charlie', 'Sylhet');

INSERT INTO Sales VALUES
(101, 1, 5000.00, '2025-09-01'),
(102, 2, 3000.00, '2025-09-02'),
(103, 1, 7000.00, '2025-09-03'),
(104, 3, 2000.00, '2025-09-04');

-- ==========================
-- Lab Exercises
-- ==========================

-- 🔹 Exercise 1: Aggregate Functions

-- 1. Total sales amount
SELECT SUM(Amount) AS TotalSales
FROM Sales;

-- 2. Average sale amount per customer
SELECT CustomerID, AVG(Amount) AS AvgSale
FROM Sales
GROUP BY CustomerID;

-- 3. Highest and lowest sale amounts
SELECT MAX(Amount) AS HighestSale, MIN(Amount) AS LowestSale
FROM Sales;

-- 4. Number of sales made by each customer
SELECT CustomerID, COUNT(*) AS NumSales
FROM Sales
GROUP BY CustomerID;

-- 🔹 Exercise 2: Nested Subqueries

-- 1. Customers who made sales above the average sale amount
SELECT Name
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales
    WHERE Amount > (SELECT AVG(Amount) FROM Sales)
);

-- 2. Customer(s) with the highest total sales
SELECT Name
FROM Customer
WHERE CustomerID = (
    SELECT CustomerID
    FROM (
        SELECT CustomerID, SUM(Amount) AS TotalSales
        FROM Sales
        GROUP BY CustomerID
        ORDER BY TotalSales DESC
        LIMIT 1
    ) AS SubQuery
);

-- 3. Customers who have not made any sales
SELECT Name
FROM Customer
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales);

-- 🔹 Exercise 3: Modification of Database

-- 1. Insert a new customer and a corresponding sale
INSERT INTO Customer VALUES (4, 'Diana', 'Rajshahi');
INSERT INTO Sales VALUES (105, 4, 4000.00, '2025-09-05');

-- 2. Update the sale amount for a specific sale ID
UPDATE Sales
SET Amount = 7500.00
WHERE SaleID = 103;

-- 3. Delete a sale record older than a given date
DELETE FROM Sales
WHERE SaleDate < '2025-09-03';

-- 4. Check final data
SELECT * FROM Customer;
SELECT * FROM Sales;
