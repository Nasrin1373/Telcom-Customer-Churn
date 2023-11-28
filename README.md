# Telcom-Customer-Churn
Focused customer retention programs

Overview

Welcome to my data analysis project! In this project, I performed comprehensive data cleaning and analysis using SQL, and created insightful visualizations with Power BI. 

About Dataset

Context

"Predict behavior to retain customers. You can analyze all relevant customer data and develop focused customer retention programs." 

Content

Each row represents a customer, each column contains customer’s attributes described on the column Metadata.


The data set includes information about:

Customers who left within the last month – the column is called Churn
Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges
Demographic info about customers – gender, age range, and if they have partners and dependents



Features

customerID:Unique identifier for each customer.String (alphanumeric)

gender:Gender of the customer.Categorical (e.g., Male, Female).

SeniorCitizen:Indicates whether the customer is a senior citizen.Binary (1 for senior citizen, 0 for non-senior citizen).

Partner:Indicates whether the customer has a partner.Binary (Yes/No).

Dependents:Indicates whether the customer has dependents.Binary (Yes/No).

tenure:Number of months the customer has been with the company.Numeric (integer).

PhoneService:Indicates whether the customer has subscribed to phone service.Binary (Yes/No).

MultipleLines:Indicates whether the customer has multiple phone lines.Categorical (e.g., No phone service, No, Yes).

InternetService:Type of internet service subscribed by the customer.Categorical (e.g., DSL, Fiber optic, No).

OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies:Indicates whether the customer has subscribed to additional services like online security, online backup, etc.Categorical (e.g., No, Yes, No internet service).

Contract:Type of contract the customer has (e.g., month-to-month, one year, two years).Categorical.

PaperlessBilling:Indicates whether the customer has opted for paperless billing. Binary (Yes/No).

PaymentMethod:Method of payment chosen by the customer (e.g., Electronic check, Mailed check, Bank transfer, Credit card).Categorical.

MonthlyCharges:Monthly charges incurred by the customer.Numeric (float).

TotalCharges:Total charges incurred by the customer.Numeric (float).

Churn:Indicates whether the customer has churned (left the service).Binary (Yes/No).
