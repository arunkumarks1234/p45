-- Fact Constellation Schema for OTT Platforms Data Warehouse

-- Dimension Tables
CREATE TABLE TimeDim (
    time_key INT PRIMARY KEY,
    date DATE,
    month INT,
    quarter INT,
    year INT
);

CREATE TABLE UserDim (
    user_key INT PRIMARY KEY,
    user_name VARCHAR(100),
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

CREATE TABLE MovieDim (
    movie_key INT PRIMARY KEY,
    movie_title VARCHAR(100),
    genre VARCHAR(50),
    director VARCHAR(100),
    release_year INT
);

CREATE TABLE PlatformDim (
    platform_key INT PRIMARY KEY,
    platform_name VARCHAR(50)
);

CREATE TABLE LoginMethodDim (
    login_key INT PRIMARY KEY,
    login_method VARCHAR(50)
);

-- Fact Tables
CREATE TABLE WatchFact (
    watch_key INT PRIMARY KEY,
    time_key INT,
    user_key INT,
    movie_key INT,
    platform_key INT,
    views INT,
    time_spent_minutes INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (user_key) REFERENCES UserDim(user_key),
    FOREIGN KEY (movie_key) REFERENCES MovieDim(movie_key),
    FOREIGN KEY (platform_key) REFERENCES PlatformDim(platform_key)
);

CREATE TABLE LoginFact (
    login_key INT PRIMARY KEY,
    time_key INT,
    user_key INT,
    platform_key INT,
    login_method_key INT,
    login_count INT,
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (user_key) REFERENCES UserDim(user_key),
    FOREIGN KEY (platform_key) REFERENCES PlatformDim(platform_key),
    FOREIGN KEY (login_method_key) REFERENCES LoginMethodDim(login_key)
);

-- Additional Fact Table for Constellation
CREATE TABLE SubscriptionFact (
    sub_key INT PRIMARY KEY,
    time_key INT,
    user_key INT,
    platform_key INT,
    subscription_type VARCHAR(50),
    revenue DECIMAL(10,2),
    FOREIGN KEY (time_key) REFERENCES TimeDim(time_key),
    FOREIGN KEY (user_key) REFERENCES UserDim(user_key),
    FOREIGN KEY (platform_key) REFERENCES PlatformDim(platform_key)
);

-- Sample Data Inserts (ETL Simulation)
INSERT INTO TimeDim VALUES (1, '2023-01-01', 1, 1, 2023);
INSERT INTO TimeDim VALUES (2, '2023-02-01', 2, 1, 2023);
INSERT INTO TimeDim VALUES (3, '2023-03-01', 3, 1, 2023);

INSERT INTO LocationDim VALUES (1, 'New York', 'NY', 'USA');
INSERT INTO LocationDim VALUES (2, 'Los Angeles', 'CA', 'USA');
INSERT INTO LocationDim VALUES (3, 'Chicago', 'IL', 'USA');

INSERT INTO UserDim VALUES (1, 'John Doe', 30, 'Male', 1);
INSERT INTO UserDim VALUES (2, 'Jane Smith', 25, 'Female', 2);
INSERT INTO UserDim VALUES (3, 'Bob Johnson', 40, 'Male', 3);

INSERT INTO MovieDim VALUES (1, 'Inception', 'Sci-Fi', 'Christopher Nolan', 2010);
INSERT INTO MovieDim VALUES (2, 'The Shawshank Redemption', 'Drama', 'Frank Darabont', 1994);
INSERT INTO MovieDim VALUES (3, 'Pulp Fiction', 'Crime', 'Quentin Tarantino', 1994);
INSERT INTO MovieDim VALUES (4, 'The Dark Knight', 'Action', 'Christopher Nolan', 2008);
INSERT INTO MovieDim VALUES (5, 'Forrest Gump', 'Drama', 'Robert Zemeckis', 1994);
INSERT INTO MovieDim VALUES (6, 'The Matrix', 'Sci-Fi', 'Wachowskis', 1999);
INSERT INTO MovieDim VALUES (7, 'Titanic', 'Romance', 'James Cameron', 1997);
INSERT INTO MovieDim VALUES (8, 'Avatar', 'Sci-Fi', 'James Cameron', 2009);
INSERT INTO MovieDim VALUES (9, 'The Godfather', 'Crime', 'Francis Ford Coppola', 1972);
INSERT INTO MovieDim VALUES (10, 'Schindler\'s List', 'Historical', 'Steven Spielberg', 1993);
INSERT INTO MovieDim VALUES (11, 'Fight Club', 'Drama', 'David Fincher', 1999);
INSERT INTO MovieDim VALUES (12, 'The Lord of the Rings', 'Fantasy', 'Peter Jackson', 2001);

INSERT INTO PlatformDim VALUES (1, 'Netflix');
INSERT INTO PlatformDim VALUES (2, 'Amazon Prime');
INSERT INTO PlatformDim VALUES (3, 'Disney+');

INSERT INTO LoginMethodDim VALUES (1, 'Email');
INSERT INTO LoginMethodDim VALUES (2, 'Social Media');
INSERT INTO LoginMethodDim VALUES (3, 'Device');

INSERT INTO WatchFact VALUES (1, 1, 1, 1, 1, 5, 120);
INSERT INTO WatchFact VALUES (2, 2, 2, 2, 2, 3, 90);
INSERT INTO WatchFact VALUES (3, 3, 3, 3, 3, 7, 150);
INSERT INTO WatchFact VALUES (4, 1, 1, 4, 1, 2, 60);
INSERT INTO WatchFact VALUES (5, 2, 2, 5, 2, 4, 100);
INSERT INTO WatchFact VALUES (6, 3, 3, 6, 3, 6, 130);
INSERT INTO WatchFact VALUES (7, 1, 1, 7, 1, 8, 180);
INSERT INTO WatchFact VALUES (8, 2, 2, 8, 2, 9, 140);
INSERT INTO WatchFact VALUES (9, 3, 3, 9, 3, 10, 110);
INSERT INTO WatchFact VALUES (10, 1, 1, 11, 1, 11, 95);
INSERT INTO WatchFact VALUES (11, 2, 2, 12, 2, 12, 160);

INSERT INTO LoginFact VALUES (1, 1, 1, 1, 1, 1);
INSERT INTO LoginFact VALUES (2, 2, 2, 2, 2, 1);
INSERT INTO LoginFact VALUES (3, 3, 3, 3, 3, 1);

INSERT INTO SubscriptionFact VALUES (1, 1, 1, 1, 'Monthly', 15.99);
INSERT INTO SubscriptionFact VALUES (2, 2, 2, 2, 'Annual', 139.00);
INSERT INTO SubscriptionFact VALUES (3, 3, 3, 3, 'Monthly', 7.99);

-- OLAP Queries across multiple facts

-- Roll-up: Total views and revenue by year
SELECT t.year, SUM(wf.views) AS total_views, SUM(sf.revenue) AS total_revenue
FROM WatchFact wf
JOIN TimeDim t ON wf.time_key = t.time_key
JOIN SubscriptionFact sf ON wf.time_key = sf.time_key AND wf.user_key = sf.user_key
GROUP BY t.year;

-- Drill-down: Views and logins by month and platform
SELECT t.month, pd.platform_name, SUM(wf.views) AS views, SUM(lf.login_count) AS logins
FROM WatchFact wf
JOIN TimeDim t ON wf.time_key = t.time_key
JOIN PlatformDim pd ON wf.platform_key = pd.platform_key
LEFT JOIN LoginFact lf ON wf.time_key = lf.time_key AND wf.user_key = lf.user_key AND wf.platform_key = lf.platform_key
GROUP BY t.month, pd.platform_name;

-- Slice: Data for USA users
SELECT wf.views, lf.login_count, sf.revenue
FROM WatchFact wf
JOIN UserDim ud ON wf.user_key = ud.user_key
JOIN LocationDim l ON ud.location_key = l.location_key
LEFT JOIN LoginFact lf ON wf.time_key = lf.time_key AND wf.user_key = lf.user_key
LEFT JOIN SubscriptionFact sf ON wf.time_key = sf.time_key AND wf.user_key = sf.user_key
WHERE l.country = 'USA';

-- Dice: Sci-Fi movies on Netflix in Q1
SELECT wf.views, sf.revenue
FROM WatchFact wf
JOIN TimeDim t ON wf.time_key = t.time_key
JOIN MovieDim md ON wf.movie_key = md.movie_key
JOIN PlatformDim pd ON wf.platform_key = pd.platform_key
LEFT JOIN SubscriptionFact sf ON wf.time_key = sf.time_key AND wf.user_key = sf.user_key
WHERE md.genre = 'Sci-Fi' AND pd.platform_name = 'Netflix' AND t.quarter = 1;

-- Ranking: Top 10 most viewed movies
SELECT md.movie_title, SUM(wf.views) AS total_views
FROM WatchFact wf
JOIN MovieDim md ON wf.movie_key = md.movie_key
GROUP BY md.movie_title
ORDER BY total_views DESC
LIMIT 10;

-- Total time spent by genre
SELECT md.genre, SUM(wf.time_spent_minutes) AS total_time
FROM WatchFact wf
JOIN MovieDim md ON wf.movie_key = md.movie_key
GROUP BY md.genre;

-- Login method analysis
SELECT lmd.login_method, SUM(lf.login_count) AS total_logins
FROM LoginFact lf
JOIN LoginMethodDim lmd ON lf.login_method_key = lmd.login_key
GROUP BY lmd.login_method;

-- Revenue by subscription type
SELECT sf.subscription_type, SUM(sf.revenue) AS total_revenue
FROM SubscriptionFact sf
GROUP BY sf.subscription_type;
