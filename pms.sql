-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR2(50) NOT NULL,
    Description VARCHAR2(255)
);

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR2(100) NOT NULL,
    ContactName VARCHAR2(50),
    Address VARCHAR2(255),
    City VARCHAR2(50),
    PostalCode VARCHAR2(20),
    Country VARCHAR2(50),
    Phone VARCHAR2(20)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR2(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR2(50),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued CHAR(1),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR2(100) NOT NULL,
    ContactName VARCHAR2(50),
    Address VARCHAR2(255),
    City VARCHAR2(50),
    PostalCode VARCHAR2(20),
    Country VARCHAR2(50),
    Phone VARCHAR2(20)
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR2(50),
    LastName VARCHAR2(50),
    Title VARCHAR2(50),
    BirthDate DATE,
    HireDate DATE
);

-- Create Shippers table
CREATE TABLE Shippers (
    ShipperID INT PRIMARY KEY,
    ShipperName VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(20)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    EmployeeID INT,
    OrderDate DATE,
    ShipperID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID)
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    Discount DECIMAL(5, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Warehouses table
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR2(100) NOT NULL,
    Location VARCHAR2(255)
);

-- Create Discounts table
CREATE TABLE Discounts (
    DiscountID INT PRIMARY KEY,
    ProductID INT,
    DiscountPercentage DECIMAL(5, 2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Inventory table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    WarehouseID INT,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- Create Reviews table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating DECIMAL(2, 1),
    ReviewText VARCHAR2(1000),
    ReviewDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create ProductImages table
CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY,
    ProductID INT,
    ImageURL VARCHAR2(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create ShipmentDetails table
CREATE TABLE ShipmentDetails (
    ShipmentID INT PRIMARY KEY,
    OrderID INT,
    ShipperID INT,
    ShipmentDate DATE,
    DeliveryDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID)
);

CREATE TABLE PaymentMethods (
    PaymentMethodID INT PRIMARY KEY,
    CustomerID INT,
    CardType VARCHAR2(50),
    CardNumber VARCHAR2(20),
    ExpiryDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    OrderID INT,
    PaymentMethodID INT,
    TransactionDate DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);


select * from Categories ;
select * from Suppliers ;
select * from Products ;
select * from Customers ;
select * from Employees;
select * from Shippers;
select * from Orders;
select * from OrderDetails;
select * from Warehouses;
select * from Discounts;
select * from Inventory;
select * from Reviews;
select * from  ProductImages;
select * from ShipmentDetails;
select * from PaymentMethods;
select * from Transactions;



--Retrieve all products and their suppliers

SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;


--Calculate total sales amount per customer:
SELECT Customers.CustomerName, SUM(Transactions.Amount) AS TotalAmount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Transactions ON Orders.OrderID = Transactions.OrderID
GROUP BY Customers.CustomerName;


--Retrieve All Orders with Customer and Shipper Information
SELECT 
    Orders.OrderID, 
    Customers.CustomerName, 
    Shippers.ShipperName, 
    Orders.OrderDate
FROM 
    Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
ORDER BY 
    Orders.OrderDate DESC;


--List Products with Their Category and Supplier Information
SELECT 
    Products.ProductName, 
    Categories.CategoryName, 
    Suppliers.SupplierName, 
    Products.UnitPrice, 
    Products.UnitsInStock
FROM 
    Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
ORDER BY 
    Products.ProductName ASC;


-- update supplier information
UPDATE Suppliers
SET ContactName = 'Pritam Saha',
    Phone = '01647185767'
WHERE SupplierID = 5;

SELECT * 
FROM Suppliers 
WHERE SupplierID = 5;

-- filtering 
SELECT p.ProductName, p.UnitPrice, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 'Y'
AND p.UnitPrice <5;

--aggregate function
SELECT p.ProductID, p.ProductName, p.UnitPrice, COUNT(*) AS TotalOrders
FROM OrderDetails od
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.UnitPrice
ORDER BY p.UnitPrice DESC
FETCH FIRST 5 ROWS ONLY;  

--review
SELECT c.CustomerName, p.ProductName, r.ReviewText, r.Rating, r.ReviewDate
FROM Reviews r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Products p ON r.ProductID = p.ProductID;

-- add new column using alter query
ALTER TABLE Products
ADD StockStatus VARCHAR2(20);
select * from Products ;





