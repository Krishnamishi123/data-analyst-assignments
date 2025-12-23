-/* QUESTION-1 What is a Common Table Expression (CTE), and how does it improve SQL query readability?
- ANSWER-1 A Common Table Expression (CTE) is a temporary result set that a user can reference
  within another SQL statement (e.g., SELECT, INSERT, UPDATE, or DELETE). It is defined using the WITH clause and
  exists only for the duration of the query in which it is used.
  Key ways in which a CTE enhances readability:
  1. Simplifying Complex Joins and Subqueries
  2. Breaking Down Logic into Logical Steps
  3. Enhancing Code Maintainability
  4. Improving the Structure of Recursive Queries
 ----------------------------------------------------------------------------------------------------------------------- 
  QUESTION-2 Why are some views updatable while others are read-only? Explain with an example.
  ANSWER--2 Views in SQL are updatable only if there is a clear, unambiguous mapping between the rows in the view and the rows in the base table. 
        When this mapping is complex or absent, the view becomes read-only.
       
       A view cannot be modified if it contains any of the following elements,
       as these maintain the direct relationship to the source data. 
      1. Aggregate functions: Using SUM(), AVG(), COUNT(), MIN(), or MAX() 
         means that a single row in the view corresponds to multiple rows in the base table(s), making a specific update impossible. 
	  2. GROUP BY or HAVING clauses
      3. JOIN operations (in certain cases): Views based on a join of two or more tables may be read-only if the update would affect more than one table, 
         depending on the database management system (DBMS) and the complexity of the join.
	  4. UNION, UNION ALL, INTERSECT, or EXCEPT operators.
      5.DISTINCT keyword
----------------------------------------------------------------------------------------------------------------------------------------------------------------

 QUESTION-3 What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
 ANSWER--3 Stored procedures offer several advantages over repeatedly writing raw SQL queries, 
          primarily centered around performance, security, and maintenance
          1.Performance-- Reduced Network Traffic: Stored procedures are compiled and stored on the database server, so only the 
           procedure's name and parameters are sent over the network, rather than the entire query text. This minimizes network load.
		  2.Security-- Defense Against SQL Injection: Stored procedures inherently parameterize inputs, 
          which is a powerful defense against SQL injection attacks. The inputs are treated as data, not executable code.
          3. Maintainance-- Easier Maintenance: If the underlying database schema changes (e.g., a column name is altered), only the stored 
            procedure needs to be updated, rather than searching and modifying raw SQL queries scattered throughout different application codebases

-------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION-4 What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
ANSWER--4 Database triggers automate actions (like logging, validation, or enforcing rules) when specific events (INSERT, UPDATE, DELETE) occur, essential for maintaining data integrity,
         enforcing complex business logic, and auditing without needing application-level code. An essential use case is auditing/logging, where a trigger automatically records who changed what and 
         when in a separate log table, providing accountability that applications might miss.  

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION-5  Explain the need for data modelling and normalization when designing a database.
ANSWER--5  Data modeling provides the blueprint for database structure, defining entities and relationships, while normalization refines this blueprint by organizing data into tables to eliminate 
          redundancy, ensure data integrity, and prevent update anomalies, making the database efficient, consistent, and easier to manage. Together, they create a logical, scalable foundation,
          reducing errors and improving performance by structuring data properly and avoiding duplicate or inconsistent entries. 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

CREATE TABLE Products(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10,2)
);
INSERT INTO Products VALUES(1,'Keyboard','Electronics',1200),
(2,'Mouse','Electronics',800),
(3,'Chair','Furniture',2500),
(4,'Desk','Furniture',5500);
CREATE TABLE Sales(
SaleID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
SaleDate DATE,
FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);
INSERT INTO Sales VALUES(1,1,4,'2024-01-05'),
(2,2,10,'2024-01-06'),
(3,3,2,'2024-01-10'),
(4,4,1,'2024-01-11');

-- QUESTION-6
WITH product_revenue AS (SELECT p.ProductID,p.ProductName,
(p.Price * s.Quantity) AS total_revenue FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID
)
SELECT ProductID,ProductName,total_revenue
FROM product_revenue WHERE total_revenue > 3000;

-- QUESTION-7
CREATE VIEW vw_CategorySummary  AS SELECT Category,
COUNT(ProductID) AS TotalProducts,AVG(Price) AS AveragePrice
FROM Products GROUP BY Category;
SELECT * FROM vw_CategorySummary;

-- QUESTION-8
CREATE VIEW product_view AS SELECT ProductID,ProductName,
Price FROM Products;
UPDATE product_view SET Price=2200 WHERE ProductID=1;
SELECT * FROM product_view;

-- QUESTION-9

DELIMITER //
CREATE PROCEDURE products_by_category (
    IN Category VARCHAR(50)
)
BEGIN
    SELECT
        ProductID,
        ProductName,
        category,
        Price
    FROM Products
    WHERE category = Category;
END //
CALL products_by_category('Electronics');

-- QUESTION-10

CREATE TABLE Product_Archive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt DATETIME
);
DELIMITER $$
CREATE TRIGGER after_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Product_Archive (
        ProductID,
        ProductName,
        Category,
        Price,
        DeletedAt
    )
    VALUES (
        OLD.ProductID,
        OLD.ProductName,
        OLD.Category,
        OLD.Price,
        NOW()
    );
END $$




