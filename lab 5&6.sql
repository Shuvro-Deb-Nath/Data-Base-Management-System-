-- ==========================
-- 1. Create Database
-- ==========================
CREATE DATABASE lab5and6;
USE lab5and6;

-- ==========================
-- 1. Create Tables
-- ==========================

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(50) UNIQUE
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    CHECK (LENGTH(Password) >= 6)
);

CREATE TABLE AccessLog (
    LogID INT PRIMARY KEY,
    UserID INT,
    AccessTime TIMESTAMP,
    Action VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ==========================
-- 2. Insert Sample Data
-- ==========================

INSERT INTO Roles VALUES
(1, 'Admin'),
(2, 'Editor'),
(3, 'Viewer');

INSERT INTO Users VALUES
(101, 'alice', 'alice123', 1),
(102, 'bob', 'bob789', 2),
(103, 'charlie', 'charlie12', 3);

INSERT INTO AccessLog VALUES
(1, 101, CURRENT_TIMESTAMP, 'Login'),
(2, 102, CURRENT_TIMESTAMP, 'Viewed Report'),
(3, 103, CURRENT_TIMESTAMP, 'Logout');

-- ==========================
-- Lab Exercises
-- ==========================

-- 🔹 Exercise 1: Integrity Constraints & Data Types

-- 1. Create the tables above with appropriate constraints
-- (Already completed in section 1)

-- 2. Insert valid sample data
-- (Already completed in section 2)

-- 3. Attempt to insert invalid data

-- Duplicate RoleName (UNIQUE violation)
INSERT INTO Roles VALUES (4, 'Admin');

-- Password too short (CHECK violation)
INSERT INTO Users VALUES (104, 'diana', '123', 2);

-- NULL Username (NOT NULL violation)
INSERT INTO Users (UserID, Username, Password) VALUES (105, NULL, 'validpass');

-- 🔹 Exercise 2: Join Expressions & Views

-- 1. INNER JOIN: Display usernames with their roles
SELECT U.Username, R.RoleName
FROM Users U
INNER JOIN Roles R ON U.RoleID = R.RoleID;

-- 2. Create a view: UserAccessSummary (username + last access time)
CREATE VIEW UserAccessSummary AS
SELECT U.Username,
       MAX(A.AccessTime) AS LastAccess
FROM Users U
LEFT JOIN AccessLog A ON U.UserID = A.UserID
GROUP BY U.Username;

-- 3. Query the view to find users who performed a specific action
SELECT U.Username, A.Action, A.AccessTime
FROM Users U
JOIN AccessLog A ON U.UserID = A.UserID
WHERE A.Action = 'Login';

-- 🔹 Exercise 3: Transactions & Authorization

-- 1. Begin a transaction to insert a new user and access log
START TRANSACTION;
INSERT INTO Users VALUES (106, 'david', 'david456', 2);
INSERT INTO AccessLog VALUES (4, 106, CURRENT_TIMESTAMP, 'Login');

-- 2. Undo the transaction
ROLLBACK;

-- 3. GRANT SELECT access on Users to a new role
CREATE ROLE ReadOnlyRole;
GRANT SELECT ON Users TO ReadOnlyRole;

-- 4. REVOKE SELECT access from that role
REVOKE SELECT ON Users FROM ReadOnlyRole;

-- ==========================
-- Final Data Check
-- ==========================

SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM AccessLog;
SELECT * FROM UserAccessSummary;
