# OTT Platforms Data Warehouse Mini-Project

## Course Context
Applicable for VTU courses related to Data Warehousing and Data Mining / Database Management Systems / Big Data Analytics.

## Objective
To help students understand the design, creation, and querying of data warehouses using star, snowflake, and fact constellation schemas. Students will learn ETL (Extract, Transform, Load) processes and OLAP (Online Analytical Processing) operations. This mini-project focuses on OTT platforms (e.g., Netflix, Amazon Prime), collecting data on movies watched, user logins, most-watched movies, time spent, and ranking top 10 movies.

## Learning Outcomes (Aligned with Bloom’s Taxonomy)
After completing this activity, students will be able to:
1. Design data warehouse schemas (Star, Snowflake, Fact Constellation). (Create)
2. Implement ETL operations to load data from multiple sources. (Apply)
3. Perform OLAP queries for analysis (roll-up, drill-down, slice, dice). (Analyze)
4. Visualize summarized data using SQL or BI tools. (Apply, Evaluate)

## Suggested Activities
### Activity 1: Understanding Schemas
- Discuss the differences between Star, Snowflake, and Fact Constellation schemas.
- Faculty demonstration: Example of OTT platform analytics.
- Student Task: Draw schema diagrams for the OTT domain.

### Activity 2: Design the Data Warehouse
- Identify Fact and Dimension tables.
- Define primary and foreign key relationships.
- Design schema in MySQL / PostgreSQL / Oracle.

### Activity 3: ETL Implementation
- Use SQL scripts to:
  - Extract data from sample inserts (simulating .csv or transactional DB).
  - Clean and transform the data (remove duplicates, convert formats).
  - Load the data into the designed warehouse.

### Activity 4: OLAP Queries
Perform the following:
- Roll-up: Aggregate views by platform or time period.
- Drill-down: Detailed analysis by movie or user.
- Slice and Dice: Filtering on multiple dimensions.
- Ranking: Rank top 10 movies by views, analyze login methods.

### Activity 5: Visualization and Reporting
- Use Power BI, Tableau, or Matplotlib to visualize results.
- Create dashboards showing KPIs (e.g., Top Movies, Login Trends, Time Spent).

## Evaluation Rubric (10 Marks Project)
| Criteria | Description | Marks |
|----------|-------------|-------|
| Schema Design | Correct identification of fact/dimension tables | 2 |
| ETL Implementation | Data extraction, transformation, and loading accuracy | 2 |
| Query Implementation | Use of OLAP queries for analysis | 2 |
| Report/Visualization | Meaningful data insights and presentation | 2 |
| Documentation & Viva | Clarity, understanding, and originality | 2 |

## Project Domain
OTT Platforms Data Warehouse:
- Users watch movies on platforms like Netflix, Amazon Prime, etc.
- Data collected: Movie watches (views, time spent), user logins (methods, timestamps).
- Analytics: Most watched movies, top 10 rankings, login patterns.

## Files in This Project
- `README.md`: This file.
- `schema_diagrams.txt`: Text-based schema diagrams.
- `star_schema.sql`: Star schema implementation.
- `snowflake_schema.sql`: Snowflake schema implementation.
- `fact_constellation_schema.sql`: Fact constellation schema implementation.

## How to Use
1. Set up a MySQL/PostgreSQL database.
2. Run the SQL scripts in order (star, snowflake, fact_constellation).
3. Execute queries to analyze data.
4. Visualize results using BI tools.
