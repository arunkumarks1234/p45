# Data Visualization Guide for Retail Sales Data Warehouse

## Overview
This guide provides instructions for visualizing the sample data from the Retail Sales Data Warehouse using Power BI or Tableau.

## Sample Data Files
The following CSV files have been created from the OLAP queries in the SQL scripts:
- `sales_by_category.csv`: Sales by month and category
- `time_spent_by_category.csv`: Total time spent by content category
- `total_sales_by_year.csv`: Total sales by year
- `sales_by_location.csv`: Sales by city
- `customer_sales.csv`: Sales by customer
- `content_views.csv`: Total views by content title

## Steps to Visualize in Power BI
1. Open Power BI Desktop.
2. Click "Get Data" > "Text/CSV" and import each CSV file.
3. Create relationships between tables if needed (e.g., link customer sales to locations).
4. Create visualizations:
   - Bar chart for sales by category
   - Line chart for total sales by year
   - Pie chart for sales by location
   - Table for customer sales
   - Column chart for content views
   - Area chart for time spent by category

## Steps to Visualize in Tableau
1. Open Tableau Desktop.
2. Connect to the CSV files.
3. Drag and drop fields to create worksheets:
   - Sales by Category: Bar chart
   - Total Sales by Year: Line chart
   - Sales by Location: Pie chart
   - Customer Sales: Table
   - Content Views: Column chart
   - Time Spent by Category: Area chart
4. Create a dashboard combining these visualizations.

## Key Insights to Visualize
- Top-selling categories and locations
- Sales trends over time
- Customer purchasing patterns
- Content engagement metrics
- Time spent on different content types

## Next Steps
- Extend sample data with more records
- Add error handling to ETL scripts
- Implement advanced analytics features
