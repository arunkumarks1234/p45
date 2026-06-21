-- Error Handling and Advanced ETL Scripts for Retail Sales Data Warehouse

-- This script demonstrates error handling in ETL processes and advanced data loading techniques

-- 1. Create a staging table for data loading with error handling
CREATE TABLE SalesStaging (
    sales_key INT,
    time_key INT,
    product_key INT,
    customer_key INT,
    location_key INT,
    sales_amount DECIMAL(10,2),
    quantity INT,
    load_status VARCHAR(20) DEFAULT 'PENDING',
    error_message VARCHAR(500),
    load_timestamp DATETIME DEFAULT GETDATE()
);

-- 2. Stored procedure for loading sales data with error handling
CREATE PROCEDURE LoadSalesData
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate data before loading
        UPDATE SalesStaging
        SET load_status = 'VALIDATING'
        WHERE load_status = 'PENDING';

        -- Check for invalid time keys
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid time_key: does not exist in TimeDim'
        WHERE time_key NOT IN (SELECT time_key FROM TimeDim)
          AND load_status = 'VALIDATING';

        -- Check for invalid product keys
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid product_key: does not exist in ProductDim'
        WHERE product_key NOT IN (SELECT product_key FROM ProductDim)
          AND load_status = 'VALIDATING';

        -- Check for invalid customer keys
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid customer_key: does not exist in CustomerDim'
        WHERE customer_key NOT IN (SELECT customer_key FROM CustomerDim)
          AND load_status = 'VALIDATING';

        -- Check for invalid location keys
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid location_key: does not exist in LocationDim'
        WHERE location_key NOT IN (SELECT location_key FROM LocationDim)
          AND load_status = 'VALIDATING';

        -- Check for negative sales amounts
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid sales_amount: cannot be negative'
        WHERE sales_amount < 0
          AND load_status = 'VALIDATING';

        -- Check for negative quantities
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = 'Invalid quantity: cannot be negative'
        WHERE quantity < 0
          AND load_status = 'VALIDATING';

        -- Load valid data into fact table
        INSERT INTO SalesFact (sales_key, time_key, product_key, customer_key, location_key, sales_amount, quantity)
        SELECT sales_key, time_key, product_key, customer_key, location_key, sales_amount, quantity
        FROM SalesStaging
        WHERE load_status = 'VALIDATING';

        -- Mark successfully loaded records
        UPDATE SalesStaging
        SET load_status = 'LOADED'
        WHERE load_status = 'VALIDATING';

        COMMIT TRANSACTION;

        -- Log successful load
        PRINT 'Sales data loaded successfully.';

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        -- Log error details
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Error occurred during sales data loading: ' + @ErrorMessage;

        -- Mark all pending records as error
        UPDATE SalesStaging
        SET load_status = 'ERROR',
            error_message = @ErrorMessage
        WHERE load_status IN ('PENDING', 'VALIDATING');

        -- Re-throw the error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

-- 3. Function to calculate total sales for a given period with error handling
CREATE FUNCTION GetTotalSalesByPeriod (
    @start_date DATE,
    @end_date DATE
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @total_sales DECIMAL(15,2);

    BEGIN TRY
        IF @start_date > @end_date
        BEGIN
            RAISERROR('Start date cannot be after end date', 16, 1);
        END

        SELECT @total_sales = SUM(sf.sales_amount)
        FROM SalesFact sf
        JOIN TimeDim t ON sf.time_key = t.time_key
        WHERE t.date BETWEEN @start_date AND @end_date;

        RETURN ISNULL(@total_sales, 0);
    END TRY
    BEGIN CATCH
        -- Log error and return 0
        PRINT 'Error in GetTotalSalesByPeriod: ' + ERROR_MESSAGE();
        RETURN 0;
    END CATCH
END;

-- 4. Trigger to maintain data integrity in SalesFact
CREATE TRIGGER SalesFact_IntegrityCheck
ON SalesFact
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for duplicate sales_keys
    IF EXISTS (
        SELECT sales_key
        FROM SalesFact
        GROUP BY sales_key
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Duplicate sales_key found in SalesFact', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Check for invalid foreign keys
    IF EXISTS (
        SELECT 1
        FROM SalesFact sf
        LEFT JOIN TimeDim t ON sf.time_key = t.time_key
        WHERE t.time_key IS NULL
    )
    BEGIN
        RAISERROR('Invalid time_key reference in SalesFact', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Similar checks for other foreign keys...
END;

-- 5. ETL logging table
CREATE TABLE ETLLoadLog (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(50),
    records_processed INT,
    records_loaded INT,
    records_failed INT,
    start_time DATETIME,
    end_time DATETIME,
    status VARCHAR(20),
    error_message VARCHAR(1000)
);

-- 6. Procedure to log ETL operations
CREATE PROCEDURE LogETLOperation (
    @table_name VARCHAR(100),
    @operation VARCHAR(50),
    @records_processed INT,
    @records_loaded INT,
    @records_failed INT,
    @status VARCHAR(20),
    @error_message VARCHAR(1000) = NULL
)
AS
BEGIN
    INSERT INTO ETLLoadLog (
        table_name, operation, records_processed, records_loaded,
        records_failed, start_time, end_time, status, error_message
    )
    VALUES (
        @table_name, @operation, @records_processed, @records_loaded,
        @records_failed, GETDATE(), GETDATE(), @status, @error_message
    );
END;

-- Example usage:
-- EXEC LoadSalesData;
-- SELECT dbo.GetTotalSalesByPeriod('2023-01-01', '2023-12-31');
-- EXEC LogETLOperation 'SalesFact', 'INSERT', 100, 95, 5, 'COMPLETED';
