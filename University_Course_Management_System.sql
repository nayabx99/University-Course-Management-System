-- =========================================
-- UNIVERSITY COURSE MANAGEMENT SYSTEM
-- Assignment 1: SQL Queries (Q1–Q16)
-- Database: PostgreSQL
-- Tool: pgAdmin 4
-- =========================================


-- Q1: Perform CRUD Operations on all tables

-- Departments Table
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (99, 'Test Department');

SELECT *
FROM Departments
WHERE DepartmentID = 99;

UPDATE Departments
SET DepartmentName = 'Practice Department'
WHERE DepartmentID = 99;

DELETE FROM Departments
WHERE DepartmentID = 99;


-- Students Table
INSERT INTO Students
    (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
    (99, 'Test', 'Student', 'test.student@example.com',
     '2001-01-01', '2024-08-01');

SELECT *
FROM Students
WHERE StudentID = 99;

UPDATE Students
SET FirstName = 'Practice'
WHERE StudentID = 99;

DELETE FROM Students
WHERE StudentID = 99;


-- Courses Table
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits)
VALUES (99, 'Practice Course', 1, 3);

SELECT *
FROM Courses
WHERE CourseID = 99;

UPDATE Courses
SET CourseName = 'Updated Course'
WHERE CourseID = 99;

DELETE FROM Courses
WHERE CourseID = 99;


-- Instructors Table
INSERT INTO Instructors
    (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
    (99, 'Test', 'Instructor', 'test.instructor@example.com', 1);

SELECT *
FROM Instructors
WHERE InstructorID = 99;

UPDATE Instructors
SET FirstName = 'Practice'
WHERE InstructorID = 99;

DELETE FROM Instructors
WHERE InstructorID = 99;


-- Enrollments Table
INSERT INTO Enrollments
    (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
    (99, 1, 101, '2024-08-01');

SELECT *
FROM Enrollments
WHERE EnrollmentID = 99;

UPDATE Enrollments
SET EnrollmentDate = '2024-09-01'
WHERE EnrollmentID = 99;

DELETE FROM Enrollments
WHERE EnrollmentID = 99;
-- Q2: Retrieve students who enrolled after 2022

SELECT *
FROM Students
WHERE EnrollmentDate >= '2023-01-01';
-- Q3: Retrieve courses offered by the Mathematics department with a limit of 5 courses

SELECT Courses.*
FROM Courses
JOIN Departments
ON Courses.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Mathematics'
LIMIT 5;
-- Q4: Count students in courses with more than 5 students

SELECT Courses.CourseName, COUNT(Enrollments.StudentID) AS TotalStudents
FROM Courses
JOIN Enrollments
ON Courses.CourseID = Enrollments.CourseID
GROUP BY Courses.CourseName
HAVING COUNT(Enrollments.StudentID) > 5;
-- Q5: Find students enrolled in both courses

SELECT Students.StudentID, Students.FirstName, Students.LastName
FROM Students
JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
JOIN Courses
ON Enrollments.CourseID = Courses.CourseID
WHERE Courses.CourseName IN ('Introduction to SQL', 'Data Structures')
GROUP BY Students.StudentID, Students.FirstName, Students.LastName
HAVING COUNT(DISTINCT Courses.CourseName) = 2;
-- Q6: Find students enrolled in either course

SELECT DISTINCT Students.StudentID, Students.FirstName, Students.LastName
FROM Students
JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
JOIN Courses
ON Enrollments.CourseID = Courses.CourseID
WHERE Courses.CourseName = 'Introduction to SQL'
OR Courses.CourseName = 'Data Structures';
-- Q7: Calculate the average credits for all courses

SELECT AVG(Credits) AS AverageCredits
FROM Courses;
-- Q8: Find the maximum salary in Computer Science

SELECT MAX(Instructors.Salary) AS MaximumSalary
FROM Instructors
JOIN Departments
ON Instructors.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Computer Science';
-- Q9: Count students in each department

SELECT Departments.DepartmentName,
       COUNT(DISTINCT Enrollments.StudentID) AS TotalStudents
FROM Departments
JOIN Courses
ON Departments.DepartmentID = Courses.DepartmentID
JOIN Enrollments
ON Courses.CourseID = Enrollments.CourseID
GROUP BY Departments.DepartmentName;
-- Q10: Retrieve students and their corresponding courses

SELECT Students.FirstName, Students.LastName, Courses.CourseName
FROM Students
INNER JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
INNER JOIN Courses
ON Enrollments.CourseID = Courses.CourseID;
-- Q11: Retrieve all students and their courses, if any

SELECT Students.FirstName, Students.LastName, Courses.CourseName
FROM Students
LEFT JOIN Enrollments
ON Students.StudentID = Enrollments.StudentID
LEFT JOIN Courses
ON Enrollments.CourseID = Courses.CourseID;
-- Q12: Find students enrolled in courses with more than 10 students

SELECT *
FROM Students
WHERE StudentID IN (
SELECT StudentID
FROM Enrollments
WHERE CourseID IN (
SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 10
    )
);
-- Q13: Extract the year from EnrollmentDate

SELECT FirstName, LastName,
       EXTRACT(YEAR FROM EnrollmentDate) AS EnrollmentYear
FROM Students;
-- Q14: Concatenate the instructor's first and last name

SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;
-- Q15: Calculate the running total of students enrolled in courses

SELECT EnrollmentID, StudentID, CourseID, EnrollmentDate,
       COUNT(*) OVER (ORDER BY EnrollmentID) AS RunningTotal
FROM Enrollments
ORDER BY EnrollmentID;
-- Q16: Label students as Senior or Junior

SELECT FirstName, LastName, EnrollmentDate,
CASE
WHEN EnrollmentDate < CURRENT_DATE - INTERVAL '4 years'
THEN 'Senior'
ELSE 'Junior'
END AS StudentLevel
FROM Students;