-- Star Schema for Retail Sales Data Warehouse with App Usage Analytics

-- Dimension Tables
CREATE TABLE TimeDim (
    time_key INT PRIMARY KEY,
    date DATE,
    month INT,
    quarter INT,
    year INT
);

CREATE TABLE ProductDim (
    product_key INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE CustomerDim (
    customer_key INT PRIMARY KEY,
    customer_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    location_key INT
);

CREATE TABLE LocationDim (
    location_key INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE ContentDim (
    content_key INT PRIMARY KEY,
    content_title VARCHAR(100),
    content_type VARCHAR(20),
    category VARCHAR(50)
);

-- Fact Tables
CREATE TABLE SalesFact (
    sales_key INT PRIMARY KEY,
    time_key INT,
    product_key INT,
    customer_key INT,
    location_key INT,
    sales_amount DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (product_key) REFERENCES ProductDim(product_key),
    FOREIGN KEY (customer_key) REFERENCES CustomerDim(customer_key),
    FOREIGN KEY (location_key) REFERENCES LocationDim(location_key)
);

CREATE TABLE AppInteractionsFact (
    interaction_key INT PRIMARY KEY,
    time_key INT,
    customer_key INT,
    content_key INT,
    location_key INT,
    views INT,
    time_spent_minutes INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (customer_key) REFERENCES CustomerDim(customer_key),
    FOREIGN KEY (content_key) REFERENCES ContentDim(content_key),
    FOREIGN KEY (location_key) REFERENCES LocationDim(location_key)
);

-- Sample Data Inserts (ETL Simulation)
INSERT INTO TimeDim VALUES (1, '2023-01-01', 1, 1, 2023);
INSERT INTO TimeDim VALUES (2, '2023-02-01', 2, 1, 2023);
INSERT INTO TimeDim VALUES (3, '2023-03-01', 3, 1, 2023);
INSERT INTO TimeDim VALUES (4, '2023-04-01', 4, 2, 2023);
INSERT INTO TimeDim VALUES (5, '2023-05-01', 5, 2, 2023);
INSERT INTO TimeDim VALUES (6, '2023-06-01', 6, 2, 2023);
INSERT INTO TimeDim VALUES (7, '2023-07-01', 7, 3, 2023);
INSERT INTO TimeDim VALUES (8, '2023-08-01', 8, 3, 2023);
INSERT INTO TimeDim VALUES (9, '2023-09-01', 9, 3, 2023);
INSERT INTO TimeDim VALUES (10, '2023-10-01', 10, 4, 2023);
INSERT INTO TimeDim VALUES (11, '2023-11-01', 11, 4, 2023);
INSERT INTO TimeDim VALUES (12, '2023-12-01', 12, 4, 2023);
INSERT INTO TimeDim VALUES (13, '2024-01-01', 1, 1, 2024);
INSERT INTO TimeDim VALUES (14, '2024-02-01', 2, 1, 2024);
INSERT INTO TimeDim VALUES (15, '2024-03-01', 3, 1, 2024);

INSERT INTO ProductDim VALUES (1, 'Laptop', 'Electronics', 'Computers', 1000.00);
INSERT INTO ProductDim VALUES (2, 'Shirt', 'Clothing', 'Tops', 50.00);
INSERT INTO ProductDim VALUES (3, 'Book', 'Books', 'Fiction', 20.00);

INSERT INTO LocationDim VALUES (1, 'New York', 'NY', 'USA');
INSERT INTO LocationDim VALUES (2, 'Los Angeles', 'CA', 'USA');
INSERT INTO LocationDim VALUES (3, 'Chicago', 'IL', 'USA');
INSERT INTO LocationDim VALUES (4, 'Houston', 'TX', 'USA');
INSERT INTO LocationDim VALUES (5, 'Phoenix', 'AZ', 'USA');
INSERT INTO LocationDim VALUES (6, 'Philadelphia', 'PA', 'USA');
INSERT INTO LocationDim VALUES (7, 'San Antonio', 'TX', 'USA');
INSERT INTO LocationDim VALUES (8, 'San Diego', 'CA', 'USA');
INSERT INTO LocationDim VALUES (9, 'Dallas', 'TX', 'USA');
INSERT INTO LocationDim VALUES (10, 'San Jose', 'CA', 'USA');

INSERT INTO CustomerDim VALUES (1, 'John Doe', 30, 'Male', 1);
INSERT INTO CustomerDim VALUES (2, 'Jane Smith', 25, 'Female', 2);
INSERT INTO CustomerDim VALUES (3, 'Bob Johnson', 40, 'Male', 3);

INSERT INTO ContentDim VALUES (1, 'Product Video 1', 'video', 'Electronics');
INSERT INTO ContentDim VALUES (2, 'Fashion Tips', 'video', 'Clothing');
INSERT INTO ContentDim VALUES (3, 'Book Review', 'image', 'Books');

INSERT INTO SalesFact VALUES (1, 1, 1, 1, 1, 1000.00, 1);
INSERT INTO SalesFact VALUES (2, 2, 2, 2, 2, 100.00, 2);
INSERT INTO SalesFact VALUES (3, 3, 3, 3, 3, 40.00, 2);
INSERT INTO SalesFact VALUES (4, 4, 1, 4, 4, 1200.00, 1);
INSERT INTO SalesFact VALUES (5, 5, 2, 5, 5, 150.00, 3);
INSERT INTO SalesFact VALUES (6, 6, 3, 6, 6, 60.00, 3);
INSERT INTO SalesFact VALUES (7, 7, 1, 7, 7, 800.00, 1);
INSERT INTO SalesFact VALUES (8, 8, 2, 8, 8, 200.00, 4);
INSERT INTO SalesFact VALUES (9, 9, 3, 9, 9, 80.00, 4);
INSERT INTO SalesFact VALUES (10, 10, 1, 10, 10, 1500.00, 1);
INSERT INTO SalesFact VALUES (11, 11, 2, 1, 1, 250.00, 5);
INSERT INTO SalesFact VALUES (12, 12, 3, 2, 2, 100.00, 5);
INSERT INTO SalesFact VALUES (13, 13, 1, 3, 3, 1100.00, 1);
INSERT INTO SalesFact VALUES (14, 14, 2, 4, 4, 300.00, 6);
INSERT INTO SalesFact VALUES (15, 15, 3, 5, 5, 120.00, 6);

INSERT INTO AppInteractionsFact VALUES (1, 1, 1, 1, 1, 5, 10);
INSERT INTO AppInteractionsFact VALUES (2, 2, 2, 2, 2, 3, 5);
INSERT INTO AppInteractionsFact VALUES (3, 3, 3, 3, 3, 7, 15);
INSERT INTO AppInteractionsFact VALUES (4, 1, 1, 1, 1, 2, 4);

-- OLAP Queries

-- Roll-up: Total sales by year
SELECT t.year, SUM(sf.sales_amount) AS total_sales
FROM SalesFact sf
JOIN TimeDim t ON sf.time_key = t.time_key
GROUP BY t.year;

-- Drill-down: Sales by month and category
SELECT t.month, pd.category, SUM(sf.sales_amount) AS sales
FROM SalesFact sf
JOIN TimeDim t ON sf.time_key = t.time_key
JOIN ProductDim pd ON sf.product_key = pd.product_key
GROUP BY t.month, pd.category;

-- Slice: Sales in USA
SELECT sf.sales_amount, sf.quantity
FROM SalesFact sf
JOIN LocationDim l ON sf.location_key = l.location_key
WHERE l.country = 'USA';

-- Dice: Sales of Electronics in Q1
SELECT sf.sales_amount
FROM SalesFact sf
JOIN TimeDim t ON sf.time_key = t.time_key
JOIN ProductDim pd ON sf.product_key = pd.product_key
WHERE pd.category = 'Electronics' AND t.quarter = 1;

-- Ranking: Most viewed content
SELECT cd.content_title, SUM(aif.views) AS total_views
FROM AppInteractionsFact aif
JOIN ContentDim cd ON aif.content_key = cd.content_key
GROUP BY cd.content_title
ORDER BY total_views DESC;

-- Total time spent by content category
SELECT cd.category, SUM(aif.time_spent_minutes) AS total_time
FROM AppInteractionsFact aif
JOIN ContentDim cd ON aif.content_key = cd.content_key
GROUP BY cd.category;
