--Remove Duplicates
WITH deduplicated_data AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY customerID ORDER BY customerID) AS row_num
  FROM Customer_Churn
)
SELECT *
FROM deduplicated_data WHERE row_num > 1;

-- Replace NULL values in MultipleLines column with 'No phone service'
SELECT CustomerID, 
ISNULL(MultipleLines, 'No phone service') as MultipleLines
FROM 
Customer_Churn

UPDATE Customer_Churn
SET MultipleLines = ISNULL(MultipleLines,'No phone service')

-- Replace NULL values in OnlineSecurity column with 'No internet service'
SELECT customerID, 
ISNULL(OnlineSecurity,'No internet service') as OnlineSecurity
FROM Customer_Churn

UPDATE Customer_Churn
SET OnlineSecurity = ISNULL(OnlineSecurity, 'No internet service')


-- Replace NULL values in OnlineBackup column with 'No internet service'
SELECT customerID, 
ISNULL(OnlineBackup,'No internet service') as OnlineBackup
FROM Customer_Churn

UPDATE Customer_Churn
SET OnlineBackup= ISNULL(OnlineBackup, 'No internet service')

-- Replace NULL values in DeviceProtection column with 'No internet service'
SELECT customerID, 
ISNULL(DeviceProtection,'No internet service') as DeviceProtection
FROM Customer_Churn

UPDATE Customer_Churn
SET DeviceProtection= ISNULL(DeviceProtection, 'No internet service')

-- Replace NULL values in TechSupport column with 'No internet service'
SELECT customerID, 
ISNULL(TechSupport,'No internet service') as TechSupport
FROM Customer_Churn

UPDAtE Customer_Churn
SET TechSupport = ISNULL(TechSupport, 'No internet service')

-- Replace NULL values in StreamingTV column with 'No internet service'
SELECT customerID, 
ISNULL(StreamingTV,'No internet service') as StreamingTV
FROM Customer_Churn

UPDAtE Customer_Churn
SET StreamingTV = ISNULL(StreamingTV, 'No internet service')

-- Replace NULL values in StreamingMovies column with 'No internet service'
SELECT customerID, 
ISNULL(StreamingMovies,'No internet service') as StreamingMovies
FROM Customer_Churn

UPDAtE Customer_Churn
SET StreamingMovies = ISNULL(StreamingMovies, 'No internet service')