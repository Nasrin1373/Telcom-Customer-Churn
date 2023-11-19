--Count the number of customers by gender
SELECT gender, COUNT(*) as customer_count
FROM Customer_Churn
GROUP BY gender;

--Calculate the average tenure for each gender
SELECT gender, AVG(tenure) as average_tenure
FROM Customer_Churn
GROUP BY gender;

--Find the percentage of customers who have churned
SELECT churn, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customer_Churn) as churn_percentage
FROM Customer_Churn
GROUP BY churn;

--Identify the top 5 payment methods with the highest average monthly charges
SELECT PaymentMethod, AVG(MonthlyCharges) as avg_monthly_charges
FROM Customer_Churn
GROUP BY PaymentMethod
ORDER BY avg_monthly_charges DESC;

--Calculate the total revenue generated from each contract type
SELECT Contract, SUM(MonthlyCharges) as total_revenue
FROM Customer_Churn
GROUP BY Contract;

--Find the average monthly charges for customers with and without internet service
SELECT InternetService, AVG(MonthlyCharges) as avg_monthly_charges
FROM Customer_Churn
GROUP BY InternetService;


--Identify the most common contract type among senior citizens
SELECT SeniorCitizen, Contract, COUNT(*) as contract_count
FROM Customer_Churn
WHERE SeniorCitizen = 1
GROUP BY SeniorCitizen, Contract
ORDER BY contract_count DESC;

--Calculate the average total charges for each payment method
SELECT PaymentMethod, AVG(TotalCharges) as avg_total_charges
FROM Customer_Churn
GROUP BY PaymentMethod;

--Rank customers by their total charges within each contract type
WITH RankedCustomers AS (
  SELECT 
    CustomerID,
    TotalCharges,
    Contract,
    RANK() OVER (PARTITION BY Contract ORDER BY TotalCharges DESC) as charges_rank
  FROM Customer_Churn
)
SELECT CustomerID, TotalCharges, Contract, charges_rank
FROM RankedCustomers;

--Calculate the cumulative total charges for each customer over time
WITH CumulativeTotal AS (
  SELECT 
    CustomerID,
    TotalCharges,
    Contract,
    SUM(TotalCharges) OVER (PARTITION BY CustomerID ORDER BY Contract) as cumulative_total
  FROM Customer_Churn
)
SELECT CustomerID, TotalCharges, Contract, cumulative_total
FROM CumulativeTotal;

--Identify customers who have a higher total spend than the average spend within their contract type
WITH AverageSpend AS (
  SELECT 
    Contract,
    AVG(TotalCharges) as avg_spend
  FROM Customer_Churn
  GROUP BY Contract
)
SELECT t.CustomerID, t.TotalCharges, t.Contract, a.avg_spend
FROM Customer_Churn t
JOIN AverageSpend a ON t.Contract = a.Contract
WHERE t.TotalCharges > a.avg_spend;

--Find customers who have recently churned and their average monthly charges exceed the overall average
WITH RecentChurned AS (
  SELECT 
    CustomerID,
    Churn,
    MonthlyCharges,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY Contract DESC) as rn
  FROM Customer_Churn
  WHERE Churn = 1
)
SELECT r.CustomerID, r.Churn, r.MonthlyCharges, AVG(t.MonthlyCharges) as overall_avg
FROM RecentChurned r
JOIN Customer_Churn t ON r.CustomerID = t.CustomerID
WHERE r.rn = 1
GROUP BY r.CustomerID, r.Churn, r.MonthlyCharges;

--Calculate the 3-month moving average of monthly charges for each customer
WITH MonthlyChargesWithRowNum AS (
  SELECT 
    CustomerID,
    MonthlyCharges,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY Contract) as rn
  FROM Customer_Churn
)
SELECT 
  m.CustomerID,
  m.MonthlyCharges,
  AVG(m2.MonthlyCharges) OVER (PARTITION BY m.CustomerID ORDER BY m.rn ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
FROM MonthlyChargesWithRowNum m
JOIN MonthlyChargesWithRowNum m2 ON m.CustomerID = m2.CustomerID AND m.rn >= m2.rn - 2 AND m.rn <= m2.rn;

--Rank customers by their total charges within each contract type, including churned customers
WITH RankedCustomers AS (
  SELECT 
    t.CustomerID,
    t.TotalCharges,
    t.Contract,
    t.Churn,
    RANK() OVER (PARTITION BY t.Contract ORDER BY t.TotalCharges DESC) as charges_rank
  FROM Customer_Churn t
  LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID AND c.Churn = 1
)
SELECT r.CustomerID, r.TotalCharges, r.Contract, r.Churn, r.charges_rank
FROM RankedCustomers r;


-- Calculate the cumulative total charges for each customer over time, including churned customers
WITH CumulativeTotal AS (
  SELECT 
    t.CustomerID,
    t.TotalCharges,
    t.Contract,
    t.Churn,
    SUM(t.TotalCharges) OVER (PARTITION BY t.CustomerID ORDER BY t.Contract) as cumulative_total
  FROM Customer_Churn t
  LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID  AND c.Churn = 1
)
SELECT c.CustomerID, c.TotalCharges, c.Contract, c.Churn, c.cumulative_total
FROM CumulativeTotal c;

--Identify customers who have a higher total spend than the average spend within their contract type, including churned customers
WITH AverageSpend AS (
  SELECT 
    t.Contract,
    AVG(t.TotalCharges) as avg_spend
  FROM Customer_Churn t
  LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID  AND c.Churn = 1
  GROUP BY t.Contract
)
SELECT t.CustomerID, t.TotalCharges, t.Contract, t.Churn, a.avg_spend
FROM Customer_Churn t
LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID  AND c.Churn = 1
JOIN AverageSpend a ON t.Contract = a.Contract
WHERE t.TotalCharges > a.avg_spend;


--Find customers who have recently churned and their average monthly charges exceed the overall average, including churned customers
WITH RecentChurned AS (
  SELECT 
    t.CustomerID,
    t.Churn,
    t.MonthlyCharges,
    ROW_NUMBER() OVER (PARTITION BY t.CustomerID ORDER BY t.Contract DESC) as rn
  FROM Customer_Churn t
  LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID  
  WHERE t.Churn = 1
)
SELECT r.CustomerID, r.Churn, r.MonthlyCharges, AVG(t.MonthlyCharges) as overall_avg
FROM RecentChurned r
LEFT JOIN Customer_Churn c ON r.CustomerID = c.CustomerID  AND c.Churn = 1
JOIN Customer_Churn t ON r.CustomerID = t.CustomerID
WHERE r.rn = 1
GROUP BY r.CustomerID, r.Churn, r.MonthlyCharges;

--Calculate the 3-month moving average of monthly charges for each customer, including churned customers
WITH MonthlyChargesWithRowNum AS (
  SELECT 
    t.CustomerID,
    t.MonthlyCharges,
    ROW_NUMBER() OVER (PARTITION BY t.CustomerID ORDER BY t.Contract) as rn
  FROM Customer_Churn t
  LEFT JOIN Customer_Churn c ON t.CustomerID = c.CustomerID   AND c.Churn = 1
)
SELECT 
  m.CustomerID,
  m.MonthlyCharges,
  AVG(m2.MonthlyCharges) OVER (PARTITION BY m.CustomerID ORDER BY m.rn ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
FROM MonthlyChargesWithRowNum m
LEFT JOIN Customer_Churn c ON m.CustomerID = c.CustomerID   AND c.Churn = 1
JOIN MonthlyChargesWithRowNum m2 ON m.CustomerID = m2.CustomerID AND m.rn >= m2.rn - 2 AND m.rn <= m2.rn;
