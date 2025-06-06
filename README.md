## Objective
   The objective of this task is to demonstrate SQL skills by performing data analysis on an eCommerce dataset. This includes writing optimized SQL queries using joins, aggregate functions, views, and indexes. ----- The goal is to derive meaningful insights such as sales trends, customer revenue, and country-wise performance.
## Code used
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
-- );

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

---
## Output Screenshot

![Screenshot 2025-06-06 155546](https://github.com/user-attachments/assets/0917c6b3-035c-4c04-98f1-eecf8412d91b)
![Screenshot 2025-06-06 155701](https://github.com/user-attachments/assets/8d9dc54b-5794-4fcc-bb68-d0b319abc3a1)
![Screenshot 2025-06-06 155715](https://github.com/user-attachments/assets/dd1e2581-c525-463f-af01-e5887dd9837a)
![Screenshot 2025-06-06 155842](https://github.com/user-attachments/assets/ce872d1f-0b43-4413-b3ff-3492e485064e)
![Screenshot 2025-06-06 160115](https://github.com/user-attachments/assets/7ddb1c57-0522-4060-8535-98d58b1bc77f)

--
## Dataset Explanation
-- The dataset used is an online eCommerce transactional dataset. It contains the following columns:

InvoiceNo: Unique invoice number for each order

StockCode: Unique product code

Description: Name/description of the product

Quantity: Number of units purchased

InvoiceDate: Date and time of the invoice

UnitPrice: Price per unit of the product

CustomerID: Unique ID for each customer

Country: Customer's country of residence

---
## Insights, Patterns, Anomalies
-- United Kingdom contributes the highest total sales, followed by other European countries.

Some countries like Netherlands, Germany, and France have high-value purchases with fewer customers.

A few transactions have negative quantities, which indicate returns or cancellations.

The average revenue per customer varies significantly; a few customers contribute disproportionately to total revenue.

The views created (country_sales_summary, customer_revenue_view) help simplify frequent reporting.

---
## Conclusion
Using SQL, we were able to derive meaningful business insights from a structured eCommerce dataset. This task demonstrated the use of various SQL techniques such as aggregate functions (SUM), JOINs, views, and indexes to optimize queries. The analysis provides a foundation for further business intelligence reporting and dashboarding.

