CREATE TABLE Customers(
CustomerID INT  PRIMARY KEY,
CustomerName VARCHAR(40),
City VARCHAR(30)
);
INSERT INTO Customers VALUES
(1,'John Smith','New York'),
(2,'Mary Johnson','Chicago'),
(3,'Peter Adams','Los Angeles'),
(4,'Nancy Miller','Houston'),
(5,'Robert White','Miami');

CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
Amount INT
);
INSERT INTO Orders VALUES
(101,1,'2024-10-01',250),
(102,2,'2024-10-05',300),
(103,1,'2024-10-07',150),
(104,3,'2024-10-10',450),
(105,6,'2024-10-12',400);

CREATE TABLE Payments(
PaymentID VARCHAR(30) PRIMARY KEY,
CustomerID INT,
PaymentDate DATE,
Amount INT
);
INSERT INTO Payments VALUES
('P001',1,'2024-10-02',250),
('P002',2,'2024-10-06',300),
('P003',3,'2024-10-11',450),
('P004',4,'2024-10-15',200);

CREATE TABLE Employees(
EmployeeID INT PRIMARY KEY,
EmployeeName VARCHAR(40),
ManagerID INT
);
INSERT INTO Employees VALUES
(1,'Alex Green',NULL),
(2,'Brian Lee',1),
(3,'Carol Ray',1),
(4,'David Kim',2),
(5,'Eva Smith',2);

SELECT DISTINCT Customers.CustomerName FROM Customers INNER JOIN
Orders ON Customers.CustomerID=Orders.CustomerID;

SELECT  Customers.*,Orders.* FROM Customers LEFT JOIN
Orders ON Customers.CustomerID=Orders.CustomerID;

SELECT  Orders.*,Customers.* FROM Orders LEFT JOIN
Customers ON Orders.CustomerID=Customers.CustomerID;

SELECT  Customers.*,Orders.* FROM Customers LEFT JOIN
Orders ON Customers.CustomerID=Orders.CustomerID
UNION
SELECT  Customers.*,Orders.* FROM Customers RIGHT JOIN
Orders ON Customers.CustomerID=Orders.CustomerID;

SELECT  Customers.* FROM Customers LEFT JOIN
Orders ON Customers.CustomerID=Orders.CustomerID
WHERE Orders.CustomerID IS NULL;

SELECT  Customers.* FROM Customers INNER JOIN
Payments ON Customers.CustomerID=Payments.CustomerID
LEFT JOIN Orders ON Customers.CustomerID=Orders.CustomerID 
WHERE Orders.OrderID IS NULL;

SELECT  Customers.*,Orders.* FROM Customers CROSS JOIN
Orders;

SELECT  Customers.*,Payments.PaymentID,Payments.PaymentDate,
Orders.OrderID,Orders.OrderDate,Orders.Amount
FROM Customers LEFT JOIN
Payments ON Customers.CustomerID=Payments.CustomerID
LEFT JOIN  Orders ON Customers.CustomerID=Orders.CustomerID;

SELECT  Customers.*,Payments.PaymentID,Payments.PaymentDate,
Orders.OrderID,Orders.OrderDate,Orders.Amount
FROM Customers INNER JOIN
Payments ON Customers.CustomerID=Payments.CustomerID
INNER JOIN Orders ON Customers.CustomerID=Orders.CustomerID;








