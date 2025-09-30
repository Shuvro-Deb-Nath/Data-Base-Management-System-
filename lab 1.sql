-- ==========================
-- LAB1: Student and Course Tables
-- ==========================

-- ==========================
-- Exercise 1: Data Definition
-- ==========================

-- 1. Create Database and Use It
CREATE DATABASE lab1;   -- Create a new database named lab1
USE lab1;               -- Switch to lab1 database

-- 2. Create Tables

-- Create Student table
CREATE TABLE Student(
    StudentId INT PRIMARY KEY,    -- Unique identifier for each student
    NAME VARCHAR(50),             -- Student name (text), max 50 chars
    AGE INT,                      -- Student age (integer)
    DEPARTMENT VARCHAR(50)        -- Department name (will drop later)
);

-- Create Course table
CREATE TABLE Course(
    CourseId INT PRIMARY KEY,     -- Unique identifier for each course
    CourseNAME VARCHAR(50),       -- Course name (text)
    credits DECIMAL(5,2)          -- Number of credits (decimal allowed for fractions)
);

-- 3. Alter Tables

-- Add a new column Email to Student table
ALTER TABLE Student
ADD email VARCHAR(100);           -- Email column can store up to 100 characters

-- Ensure credits is decimal (already defined as DECIMAL, safe to enforce)
ALTER TABLE Course
MODIFY credits DECIMAL(5,2);

-- Drop the Department column from Student
ALTER TABLE Student
DROP COLUMN DEPARTMENT;

-- ==========================
-- Exercise 2: Basic SQL Queries
-- ==========================

-- 1. Insert at least 5 records into Student table
INSERT INTO Student (StudentId, NAME, AGE, email) VALUES
(1, 'Alice Johnson', 20, 'alice.johnson@example.com'),
(2, 'Bob Smith', 22, 'bob.smith@example.com'),
(3, 'Charlie Brown', 21, 'charlie.brown@example.com'),
(4, 'Diana Prince', 23, 'diana.prince@example.com'),
(5, 'Ethan Hunt', 24, 'ethan.hunt@example.com');

-- Insert at least 5 records into Course table
INSERT INTO Course (CourseId, CourseNAME, credits) VALUES
(101, 'Mathematics', 3.50),
(102, 'Physics', 4.00),
(103, 'Chemistry', 3.75),
(104, 'Computer Science', 4.25),
(105, 'English Literature', 2.50);

-- 2. Retrieve all student records
SELECT * FROM Student;

-- 3. Display names of students older than 21
SELECT NAME
FROM Student
WHERE AGE > 21;

-- 4. Show all courses with more than 3 credits
SELECT *
FROM Course
WHERE credits > 3;

-- ==========================
-- Exercise 3: Constraints and Data Types
-- ==========================

-- 1. Add NOT NULL constraint to Name column in Student
ALTER TABLE Student
MODIFY NAME VARCHAR(50) NOT NULL;

-- 2. Add CHECK constraint to ensure credits are between 1 and 5
ALTER TABLE Course
ADD CONSTRAINT chk_credits_range
CHECK (credits >= 1 AND credits <= 5);

-- 3. Justification of data types:
-- - INT for IDs and AGE: whole numbers, primary keys, no decimals needed.
-- - VARCHAR for names, email, and course names: flexible text storage.
-- - DECIMAL(5,2) for credits: allows fractional credit values like 3.50.
