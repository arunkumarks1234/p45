-- Snowflake Schema for Retail Sales Data Warehouse with App Usage Analytics

-- Dimension Tables (Normalized)
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
    city_key INT
);

CREATE TABLE CityDim (
    city_key INT PRIMARY KEY,
    city VARCHAR(50),
    state_key INT
);

CREATE TABLE StateDim (
    state_key INT PRIMARY KEY,
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
    city_key INT,
    sales_amount DECIMAL(10,2),
    quantity INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (product_key) REFERENCES ProductDim(product_key),
    FOREIGN KEY (customer_key) REFERENCES CustomerDim(customer_key),
    FOREIGN KEY (city_key) REFERENCES CityDim(city_key)
);

CREATE TABLE AppInteractionsFact (
    interaction_key INT PRIMARY KEY,
    time_key INT,
    customer_key INT,
    content_key INT,
    city_key INT,
    views INT,
    time_spent_minutes INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (customer_key) REFERENCES CustomerDim(customer_key),
    FOREIGN KEY (content_key) REFERENCES ContentDim(content_key),
    FOREIGN KEY (city_key) REFERENCES CityDim(city_key)
);

-- Sample Data Inserts (ETL Simulation)
INSERT INTO TimeDim VALUES (1, '2023-01-01', 1, 1, 2023);
INSERT INTO TimeDim VALUES (2, '2023-02-01', 2, 1, 2023);
INSERT INTO TimeDim VALUES (3, '2023-03-01', 3, 1, 2023);

INSERT INTO ProductDim VALUES (1, 'Laptop', 'Electronics', 'Computers', 1000.00);
INSERT INTO ProductDim VALUES (2, 'Shirt', 'Clothing', 'Tops', 50.00);
INSERT INTO ProductDim VALUES (3, 'Book', 'Books', 'Fiction', 20.00);

INSERT INTO StateDim VALUES (1, 'NY', 'USA');
INSERT INTO StateDim VALUES (2, 'CA', 'USA');
INSERT INTO StateDim VALUES (3, 'IL', 'USA');

INSERT INTO CityDim VALUES (1, 'New York', 1);
INSERT INTO CityDim VALUES (2, 'Los Angeles', 2);
INSERT INTO CityDim VALUES (3, 'Chicago', 3);

INSERT INTO CustomerDim VALUES (1, 'John Doe', 30, 'Male', 1);
INSERT INTO CustomerDim VALUES (2, 'Jane Smith', 25, 'Female', 2);
INSERT INTO CustomerDim VALUES (3, 'Bob Johnson', 40, 'Male', 3);

INSERT INTO ContentDim VALUES (1, 'Product Video 1', 'video', 'Electronics');
INSERT INTO ContentDim VALUES (2, 'Fashion Tips', 'video', 'Clothing');
INSERT INTO ContentDim VALUES (3, 'Book Review', 'image', 'Books');

INSERT INTO SalesFact VALUES (1, 1, 1, 1, 1, 1000.00, 1);
INSERT INTO SalesFact VALUES (2, 2, 2, 2, 2, 100.00, 2);
INSERT INTO SalesFact VALUES (3, 3, 3, 3, 3, 40.00, 2);

INSERT INTO AppInteractionsFact VALUES (1, 1, 1, 1, 1, 5, 10);
INSERT INTO AppInteractionsFact VALUES (2, 2, 2, 2, 2, 3, 5);
INSERT INTO AppInteractionsFact VALUES (3, 3, 3, 3, 3, 7, 15);
INSERT INTO AppInteractionsFact VALUES (4, 1, 1, 1, 1, 2, 4);

-- OLAP Queries (Similar to Star, but with joins through normalized dims)

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

-- Slice: Sales in USA (join through CityDim and StateDim)
SELECT sf.sales_amount, sf.quantity
FROM SalesFact sf
JOIN CityDim cd ON sf.city_key = cd.city_key
JOIN StateDim sd ON cd.state_key = sd.state_key
WHERE sd.country = 'USA';

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
