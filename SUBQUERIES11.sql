CREATE TABLE Employee(
emp_id INT PRIMARY KEY,
name VARCHAR(30),
department_id VARCHAR(10),
salary INT
);
INSERT INTO Employee VALUES(101,'Abhishek','D01',62000),
(102,'Shubham','D01',58000),
(103,'Priya','D02',67000),
(104,'Rohit','D02',64000),
(105,'Neha','D03',72000),
(106,'Aman','D03',55000),
(107,'Ravi','D04',60000),
(108,'Sneha','D04',75000),
(109,'Kiran','D05',70000),
(110,'Tanuja','D05',65000);

CREATE TABLE Department(
department_id VARCHAR(10),
department_name VARCHAR(15),
location VARCHAR(20)
);
INSERT INTO Department VALUES('D01','Sales','Mumbai'),
('D02','Marketing','Delhi'),
('D03','Finance','Pune'),
('D04','HR','Bengaluru'),
('D05','IT','Hyderabad');

CREATE TABLE Sales(
sale_id INT PRIMARY KEY,
emp_id INT,
sale_amount INT,
sale_date DATE
);
INSERT INTO Sales VALUES(201,101,4500,'2025-01-05'),
(202,102,7800,'2025-01-10'),
(203,103,6700,'2025-01-14'),
(204,104,12000,'2025-01-20'),
(205,105,9800,'2025-02-02'),
(206,106,10500,'2025-02-05'),
(207,107,3200,'2025-02-09'),
(208,108,5100,'2025-02-15'),
(209,109,3900,'2025-02-20'),
(210,110,7200,'2025-03-01');
/*
BASIC LEVEL
*/
SELECT name FROM Employee WHERE salary>
(SELECT AVG(salary) FROM Employee);

SELECT * FROM Employee WHERE department_id=(SELECT department_id
FROM Employee GROUP BY department_id ORDER BY AVG(salary) DESC
LIMIT 1);

SELECT name from Employee WHERE EXISTS(
SELECT 1 FROM Sales WHERE Employee.emp_id=Sales.emp_id);

SELECT e.name FROM Employee e JOIN Sales s ON e.emp_id = s.emp_id
WHERE s.sale_amount = (SELECT MAX(sale_amount)FROM Sales);

SELECT name FROM Employee WHERE salary>
(SELECT salary FROM Employee WHERE name='Shubham');

/*
Intermediate level
*/

SELECT name FROM Employee WHERE department_id IN(
SELECT department_id FROM Employee WHERE name='Abhishek');

SELECT  department_name FROM Department WHERE EXISTS(
SELECT department_id FROM Employee WHERE 
Employee.department_id=Department
.department_id AND Employee.salary>60000);

SELECT department_name FROM Department WHERE department_id=(
SELECT department_id FROM Employee WHERE emp_id=(
SELECT emp_id FROM Sales WHERE sale_amount=(SELECT MAX(sale_amount)
FROM Sales)));

SELECT name FROM Employee JOIN Sales ON Employee.emp_id=Sales.emp_id
WHERE sale_amount>(SELECT AVG(sale_amount) FROM Sales);

SELECT SUM(s.sale_amount) AS total_sales FROM Sales s
WHERE s.emp_id IN (SELECT emp_id FROM Employee WHERE salary > (
SELECT AVG(salary)FROM Employee));

/*
Advanced level
*/

SELECT name from Employee WHERE NOT EXISTS(
SELECT 1 FROM Sales WHERE Employee.emp_id=Sales.emp_id);

SELECT department_name FROM Department WHERE department_id 
IN (SELECT department_id FROM Employee GROUP BY 
department_id HAVING AVG(salary) > 55000);

SELECT department_name FROM Department WHERE department_id IN (
SELECT department_id FROM Employee WHERE emp_id IN (SELECT emp_id
FROM Sales GROUP BY emp_id HAVING SUM(sale_amount) > 10000));

SELECT name FROM Employee WHERE emp_id IN( SELECT emp_id FROM Sales
WHERE sale_amount = (SELECT MAX(sale_amount)FROM Sales 
WHERE sale_amount < (SELECT MAX(sale_amount)FROM Sales)));

 SELECT name FROM Employee WHERE salary>
 (SELECT MAX(sale_amount) FROM Sales);






