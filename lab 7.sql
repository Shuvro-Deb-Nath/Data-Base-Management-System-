-- ==========================
-- 1. Create Database
-- ==========================
CREATE DATABASE lab7;
USE lab7;

-- ==========================
-- 1. Create Tables
-- ==========================

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    HolderName VARCHAR(50) NOT NULL,
    Balance DECIMAL(10,2) CHECK (Balance >= 0)
);

CREATE TABLE Transactions (
    TransID INT PRIMARY KEY,
    AccountID INT,
    Amount DECIMAL(10,2),
    TransType VARCHAR(10),
    TransDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- ==========================
-- 2. Insert Sample Data
-- ==========================

INSERT INTO Accounts VALUES
(1, 'Alice', 1200.00),
(2, 'Bob', 2500.00);

INSERT INTO Transactions VALUES
(101, 1, 200.00, 'Deposit', '2025-01-05'),
(102, 2, 300.00, 'Withdraw', '2025-01-06');

-- ==========================
-- Lab Exercises
-- ==========================


-- 🔹 Exercise 1: Accessing SQL from Python
-- ----------------------------------------

-- 1. Python script to connect to the database

-- import mysql.connector
-- conn = mysql.connector.connect(
--     host="localhost",
--     user="root",
--     password="yourpassword",
--     database="lab7"
-- )
-- cursor = conn.cursor()


-- 2. Insert a new account and transaction using Python

-- cursor.execute("INSERT INTO Accounts VALUES (3, 'Charlie', 1800.00)")
-- cursor.execute("INSERT INTO Transactions VALUES (103, 3, 600.00, 'Deposit', '2025-01-10')")
-- conn.commit()


-- 3. Retrieve and display account balances

-- cursor.execute("SELECT HolderName, Balance FROM Accounts")
-- rows = cursor.fetchall()
-- for row in rows:
--     print(row)

-- conn.close();


-- 🔹 Exercise 2: Functions and Procedures
-- ---------------------------------------

-- 1. Create stored procedure AddTransaction

DELIMITER $$
CREATE PROCEDURE AddTransaction(
    IN accID INT,
    IN amt DECIMAL(10,2),
    IN ttype VARCHAR(10),
    IN tdate DATE
)
BEGIN
    INSERT INTO Transactions (TransID, AccountID, Amount, TransType, TransDate)
    VALUES ((SELECT COALESCE(MAX(TransID), 100) + 1 FROM Transactions),
             accID, amt, ttype, tdate);

    IF ttype = 'Deposit' THEN
        UPDATE Accounts SET Balance = Balance + amt WHERE AccountID = accID;
    ELSEIF ttype = 'Withdraw' THEN
        UPDATE Accounts SET Balance = Balance - amt WHERE AccountID = accID;
    END IF;
END$$
DELIMITER ;


-- 2. Create function GetBalance

DELIMITER $$
CREATE FUNCTION GetBalance(acc INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bal DECIMAL(10,2);
    SELECT Balance INTO bal FROM Accounts WHERE AccountID = acc;
    RETURN bal;
END$$
DELIMITER ;


-- 3. Calling procedure and function from Python

-- cursor.callproc("AddTransaction", [1, 300.00, 'Deposit', '2025-01-15'])
-- conn.commit()

-- cursor.execute("SELECT GetBalance(1)")
-- print(cursor.fetchone()[0])


-- 🔹 Exercise 3: Constraints, Schemas, and Authorization
-- ------------------------------------------------------

-- 1. Attempt invalid transaction (CHECK constraint violation: negative balance)

INSERT INTO Accounts VALUES (4, 'David', -200.00);


-- 2. Grant permission to execute AddTransaction

GRANT EXECUTE ON PROCEDURE AddTransaction TO 'bankuser'@'localhost';


-- 3. Revoke permission

REVOKE EXECUTE ON PROCEDURE AddTransaction FROM 'bankuser'@'localhost';


-- ==========================
-- Final Data Check
-- ==========================

SELECT * FROM Accounts;
SELECT * FROM Transactions;
SELECT GetBalance(1) AS BalanceCheck;
