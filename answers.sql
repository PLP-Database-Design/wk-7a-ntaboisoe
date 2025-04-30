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
  OrderID INT NOT NULL,
  CustomerName VARCHAR(50),
  Products VARCHAR(50)
)
;
INSERT INTO ProductDetail (OrderID, CustomerName, Products)
VALUES
  (101,'John Doe','Laptop, Mouse'),
  (102,'Jane Smith','Tablet, Keyboard, Mouse'),
  (103,'Emily Clark','Phone')
;


CREATE TABLE ProductDetailsUpdated (
  OrderID        INT,
  CustomerName   VARCHAR(255),
  Product        VARCHAR(255)
);

INSERT INTO ProductDetailsUpdated (OrderID, CustomerName, Product)
-- 1st product
SELECT
  OrderID,
  CustomerName,
  TRIM(REGEXP_SUBSTR(Products, '[^,]+', 1, 1))
FROM ProductDetail

UNION ALL

-- 2nd product (only if at least one comma)
SELECT
  OrderID,
  CustomerName,
  TRIM(REGEXP_SUBSTR(Products, '[^,]+', 1, 2))
FROM ProductDetail
WHERE Products LIKE '%,%'

UNION ALL

-- 3rd product (only if at least two commas)
SELECT
  OrderID,
  CustomerName,
  TRIM(REGEXP_SUBSTR(Products, '[^,]+', 1, 3))
FROM ProductDetail
WHERE Products LIKE '%,%,%'
;

SELECT --Verify all ok
*
FROM productdetailsupdated
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
/*Step 0: Create the original table*/
CREATE TABLE OrderDetails(
  OrderID INT,
  CustomerName VARCHAR(50),
  Product VARCHAR(50),
  Quantity INT
);
INSERT INTO OrderDetails (OrderID,CustomerName,Product, Quantity)
VALUES
  (101,'John Doe','Laptop',2),
  (101,'John Doe','Mouse',1),
  (102,'Jane Smith','Tablet',3),
  (102,'Jane Smith','Keyboard',1),
  (102,'Jane Smith','Mouse',2),
  (103,'Emily Clark','Phone',1)
 ;
 SELECT
 * 
 FROM OrderDetails
 ;

 /*Step 1: Create a Orders table of unique values*/
 CREATE TABLE Orders(
   OrderID INT,
   CustomerName VARCHAR(50)
 );
 INSERT INTO Orders (OrderID, CustomerName)
 SELECT DISTINCT 
  OrderID, 
  CustomerName 
FROM OrderDetails
;
SELECT
* 
FROM Orders
;

/*Step 1: Create a Orders table of unique values*/
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

/*Step2: Create an updated OrderDetails table*/
CREATE TABLE OrderDetailsUpdated (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
)
;

-- Insert the remaining details into the OrderDetails table
INSERT INTO OrderDetailsUpdated (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails
;


SELECT --verify all ok
*
FROM orderdetailsupdated
;
