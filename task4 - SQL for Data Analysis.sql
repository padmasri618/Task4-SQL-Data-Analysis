create schema ecommerce;
CREATE TABLE ecommerce_orders (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(50)
);

INSERT INTO ecommerce_orders 
(InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
VALUES 
('536365', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 6, '2010-12-01 08:26:00', 2.55, '17850', 'United Kingdom'),
('536365', '71053', 'WHITE METAL LANTERN', 6, '2010-12-01 08:26:00', 3.39, '17850', 'United Kingdom'),
('536366', '84406B', 'CREAM CUPID HEARTS COAT HANGER', 8, '2010-12-01 08:28:00', 2.75, '17850', 'United Kingdom');

# Total Sales by Country
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM ecommerce_orders
GROUP BY Country
ORDER BY TotalSales DESC;

#Average Order Value per Customer
SELECT CustomerID, AVG(Quantity * UnitPrice) AS AvgOrderValue
FROM ecommerce_orders
GROUP BY CustomerID
ORDER BY AvgOrderValue DESC;

#Top 5 Best-Selling Products
SELECT Description, SUM(Quantity) AS TotalSold
FROM ecommerce_orders
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 5;

#Number of Orders per Day
SELECT DATE(InvoiceDate) AS OrderDate, COUNT(DISTINCT InvoiceNo) AS NumOrders
FROM ecommerce_orders
GROUP BY OrderDate
ORDER BY OrderDate;

#Using Subquery: Highest Spending Customer
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpent
FROM ecommerce_orders
GROUP BY CustomerID
HAVING TotalSpent = (
    SELECT MAX(total)
    FROM (
        SELECT CustomerID, SUM(Quantity * UnitPrice) AS total
        FROM ecommerce_orders
        GROUP BY CustomerID
    ) AS sub
);

#Total Sales by Country (Using JOIN + SUM)
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM ecommerce_orders 
INNER JOIN customers  ON CustomerID = CustomerID
GROUP BY Country
ORDER BY TotalSales DESC;

#Create a View for Total Sales
CREATE VIEW country_sales_summary AS
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM ecommerce_orders
GROUP BY Country;
SELECT * FROM country_sales_summary
ORDER BY TotalSales DESC;

#Create an Index to Optimize Sales Query
CREATE INDEX idx_customer_sales ON ecommerce_orders (CustomerID, InvoiceDate);

#Total Revenue by Customer (Aggregate + View + JOIN)
CREATE VIEW customer_revenue_view AS
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalRevenue, Country
FROM ecommerce_orders e
INNER JOIN customers  ON CustomerID = CustomerID
GROUP BY CustomerID, Country;

SELECT * FROM customer_revenue_view
ORDER BY TotalRevenue DESC;
