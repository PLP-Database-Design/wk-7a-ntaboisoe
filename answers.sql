/*

Question 1 Achieving 1NF (First Normal Form) 🛠️
Task:

You are given the following table ProductDetail:
OrderID  CustomerName  Products
101      John Doe      Laptop, Mouse
102      Jane Smith    Tablet, Keyboard, Mouse
103      Emily Clark   Phone
In the table above, the Products column contains multiple values, which violates 1NF.
Write an SQL query to transform this table into 1NF, ensuring that each row represents a single product for an order
*/

CREATE TABLE ProductDetail(
	OrderID int PRIMARY KEY,
	CustomerName varchar,
	Products varchar
	)
;
INSERT INTO ProductDetail(OrderID, CustomerName, Products)
VALUES 
	(101,'John Doe','Laptop,Mouse'),
	(102,'Jane Smith','Tablet,Keyboard,Mouse'),
	(103,'Emily Clark','Phone')
;
SELECT
*
FROM ProductDetail
;


CREATE TABLE ProductDetailUpdated(
	OrderID int,
	CustomerName varchar,
	Products varchar
)
;

INSERT INTO ProductDetailUpdated(OrderID, CustomerName, Products)
VALUES 
	(101,'John Doe','Laptop'),
	(101,'John Doe','Mouse'),
	(102,'Jane Smith','Tablet'),
	(102,'Jane Smith','Keyboard'),
	(102,'Jane Smith','Mouse'),
	(103,'Emily Clark','Phone')
;

/*
You are given the following table OrderDetails, which is already in 1NF but still contains partial dependencies:
OrderID  CustomerName  Product    Quantity
101      John Doe      Laptop     2
101      John Doe      Mouse      1
102      Jane Smith    Tablet     3
102      Jane Smith    Keyboard   1
102      Jane Smith    Mouse      2
103      Emily Clark   Phone      1
In the table above, the CustomerName column depends on OrderID (a partial dependency), which violates 2NF.

Write an SQL query to transform this table into 2NF by removing partial dependencies. Ensure that each non-key column fully depends on the entire primary key.
*/
-- Create the Orders table to remove the partial dependency on CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR
)
;
-- Insert unique records from the original table into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails
;

-- Create the OrderDetails table with a composite primary key (OrderID, Product)
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
)
;

-- Insert the remaining details into the OrderDetails table
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails
;
