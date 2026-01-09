/*
Given dataset:
| Order_ID | Customer_ID | Sales_Amount   | Order_Date |
| -------- | ----------- | -------------- | ---------- |
| O101     | C001        | 4500           | 12-01-2024 |
| O102     | C002        | Null           | 15-01-2024 |
| O103     | C003        | 3200           | 2024/01/18 |
| O101     | C001        | 4500           | 12-01-2024 |
| O104     | C004        | Three Thousand | 20-01-2024 |
| O105     | C005        | 5100           | 25-01-2024 |
Q1. Data Understanding
Data Quality Issues Present
a)Duplicate records (Order_ID O101 appears twice)
b)Missing values (Sales_Amount = NULL)
c)Invalid data type (Sales_Amount = 'Three Thousand')
d)Inconsistent date formats
e)Primary key violation
f)Risk of incorrect aggregation in BI
---------------------------------------------------------------------------------------------
Q2. Primary Key Validation

Assume Order_ID is the Primary Key.

a)Is the dataset violating the Primary Key rule?
ans-- Yes

b) Which record(s) cause the violation?
ans--Order_ID
     O101 (appears twice)
     Primary keys must be unique and NOT NULL

--------------------------------------------------------------------------------------------
Q3. Missing Value Analysis
Column(s) with Missing Values
-- Sales_Amount

a)Affected Record(s)
Order_ID	Customer_ID
O102	     C002
b) Why is this risky?
1)Causes incorrect Total Sales
2)Can result in NULL propagation
3)BI tools may ignore or miscalculate metrics

----------------------------------------------------------------------------------------------
Q4. Data Type Validation
a) Records failing numeric validation
Order_ID	Sales_Amount
O104	    Three Thousand
b) If loaded as DECIMAL in SQL
1)Load fails 
2)Value becomes NULL
3)Causes incorrect revenue calculations
---------------------------------------------------------------------------------------------
Q5. Date Format Consistency
a) Date formats present
Format	       Example
DD-MM-YYYY	   12-01-2024
YYYY/MM/DD	   2024/01/18
b) Why this is a problem?
1)SQL engines expect uniform format
2)Can cause load failures
3)Sorting & filtering dates becomes unreliable

----------------------------------------------------------------------------------------------
Q6. Load Readiness Decision
a) Should this dataset be loaded directly into the database?
ans-- No

b) Justify your answer with at least three reasons
1)Primary key violation exists
2)Invalid numeric values present
3)Missing Sales_Amount
4)Inconsistent date formats
5)High risk of incorrect BI KPIs
----------------------------------------------------------------------------------------------
Q7. Pre-Load Validation Checklist
List the exact pre-load validation checks you would perform on this 
dataset before loading.
ans--Before loading, perform:
a)Primary key uniqueness check
b)NULL value check
c)Numeric validation on Sales_Amount
d)Date format standardization
e)Duplicate detection
f)Referential integrity check (if master tables exist)
g)Record count reconciliation

----------------------------------------------------------------------------------------------
Q8. Cleaning Strategy
Describe the step-by-step cleaning actions required to make this dataset
load-ready.
ans-- 
a)Remove or deduplicate Order_ID duplicates
b)Handle missing Sales_Amount (impute / reject)
c)Convert text amounts → numeric
d)Standardize date format (YYYY-MM-DD)
e)Validate business rules
f)Re-run quality checks

----------------------------------------------------------------------------------------------
Q9. Loading Strategy Selection
Assume this dataset represents daily sales data.
a) Should a Full Load or Incremental Load be used?
b) Justify your choice.
a) Full Load or Incremental Load?
---- Incremental Load
b) Justification
1)Daily data keeps growing
2)Full load is inefficient
3)Incremental load reduces cost and time
4)Supports watermarking by date

------------------------------------------------------------------------------------------------
Q10. BI Impact Scenario
Assume this dataset was loaded without cleaning and connected to a BI dashboard.
a) What incorrect results might appear in Total Sales KPI?
b) Which records specifically would cause misleading insights?
c) Why would BI tools not detect these issues automatically?
ans--
a) Incorrect Total Sales KPI
1)Revenue inflated due to duplicates
2)Revenue understated due to NULLs
b) Records causing misleading insights
Issue	              Record
Duplicate sales	      O101
Missing sales	      O102
Invalid amount	      O104
c) Why BI tools won’t detect automatically?
1)BI tools assume data is already clean
2)They don’t enforce business rules
3)They aggregate blindly (Garbage In → Garbage Out)
*/