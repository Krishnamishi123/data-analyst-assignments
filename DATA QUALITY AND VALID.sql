/*
Question 1 : Define Data Quality in the context of ETL pipelines. Why is it more
 than just data cleaning?
Answer 1: Data Quality in ETL pipelines refers to how fit-for-use the data is 
after it has been extracted, transformed, and loaded for analytics, 
reporting, or downstream systems.

High-quality data is typically:

a)Accurate – correctly represents real-world values

b)Complete – no critical fields missing

c)Consistent – same data gives same meaning across sources

d)Timely – available when needed

e)Valid – follows business rules and formats

f)Unique – no unintended duplicates

Why Data Quality is more than just Data Cleaning:----

Data cleaning is only one part of data quality. Data quality spans the 
entire ETL lifecycle:

1️)Prevention, not just correction

a)Cleaning fixes bad data after it arrives

b)Data quality also focuses on preventing errors at source.

2)Business rule enforcement

a)Data quality ensures data matches business logic, not just format

Example:

b)Age must be ≥ 18 for customers

c)Order date cannot be after delivery date

3️)Consistency across systems

a)ETL often merges multiple sources

b)Data quality ensures:

Same customer ID means same customer everywhere

Units, currencies, and codes are standardized

4️)Monitoring and governance

a)Includes:

Data quality checks

Threshold alerts (e.g., null rate > 5%)

Audit logs and data lineage

5️)Trust and decision-making

a)Clean data can still be wrong or misleading

b)High data quality ensures:

Reliable dashboards

Correct ML models

Confident business decisions

---------------------------------------------------------------------------------------------------------
Question 2 : Explain why poor data quality leads to misleading dashboards 
and incorrect decisions.
Answer 2:Dashboards and reports are only as reliable as the data feeding them.
Poor data quality directly results in wrong insights, even if the visualization
and tools are correct.
Key Reasons
1️)Inaccurate Data → Wrong Metrics

a)If source data is incorrect, KPIs become meaningless.

Example: Sales amount entered twice → Revenue dashboard shows inflated growth

Impact: Management believes performance is improving when it’s not

2️)Missing or Incomplete Data → Partial Insights

a)Null or missing values distort trends.

Example: Missing customer income values → Average income appears lower

Impact: Incorrect customer segmentation and targeting

3️)Inconsistent Data → Conflicting Reports

a)Same metric calculated differently across sources.

Example:

One system stores revenue in INR

Another stores it in USD

Impact: Two dashboards show different totals for the same business question

4️) Duplicate Records → Overcounting

a)Duplicates inflate counts and totals.

Example: Same customer loaded multiple times

Impact: Overestimated customer base and retention rates

5️)Outdated or Late Data → Poor Timing Decisions

a)Data that is not timely misguides planning.

Example: Dashboard updated weekly instead of daily

Impact: Delayed reaction to sales drop or system issues

6️)Violation of Business Rules → False Patterns

a)Data may look clean but be logically wrong.

Example: Negative order quantity or future delivery dates

Impact: Invalid trends and unreliable forecasting

-----------------------------------------------------------------------------------------------
Question 3 : What is duplicate data? Explain three causes in ETL pipelines.
Answer 3:Duplicate data refers to the presence of multiple records 
representing the same real-world entity or event when only one should exist.

Example:
Same customer appearing twice with the same Customer_ID
Same order loaded multiple times into a fact table

Duplicates cause overcounting, inflated metrics, and misleading analytics. 
Three Common Causes of Duplicate Data in ETL Pipelines
1️)Multiple Data Sources with No Deduplication
When ETL integrates data from different systems without proper matching logic.

Example:
CRM and Billing system both store the same customer

Cause:
No unique key or fuzzy matching during merge

Result:
Duplicate customer records in the target table

2️)Reprocessing or Reloading the Same Data

ETL jobs re-run without handling already processed records.

Example:
A failed job is restarted and reloads yesterday’s data again

Cause:
Missing incremental load logic or watermarking

Result:
Same transactions inserted multiple times

3️)Poor Primary Key or Natural Key Design

Duplicates occur when uniqueness is not enforced.

Example:
Using name + city instead of Customer_ID as a key

Cause:
No primary key or incorrect surrogate key handling

Result:
Multiple rows for the same entity

------------------------------------------------------------------------------------------------------------------
Question 4 : Differentiate between exact, partial, and fuzzy duplicates.
Answer 4:1️)Exact Duplicates
Definition:
Records that are completely identical across all key fields.
example:
| Customer_ID | Name | Email                                   |
| ----------- | ---- | --------------------------------------- |
| 101         | Amit | [amit@gmail.com](mailto:amit@gmail.com) |
| 101         | Amit | [amit@gmail.com](mailto:amit@gmail.com) |
Cause in ETL:
a)Same file loaded twice
b)Job rerun without deduplication
Impact:
Straightforward to detect and remove

2️)Partial Duplicates
Definition:
Records match on some key attributes but differ in others.
example:
| Customer_ID | Name | City   |
| ----------- | ---- | ------ |
| 102         | Riya | Mumbai |
| 102         | Riya | MUM    |
Cause in ETL:
a)Inconsistent data formats
b)Standardization not applied before loading
Impact:
Requires business rules to decide which record is correct.
3️)Fuzzy Duplicates
Definition:
Records represent the same entity but have slight variations due to spelling, abbreviations, or data entry errors.
Example:
Name	Phone
Krishna M.	9876543210
Krishan	9876543210
Cause in ETL:
a)Manual data entry
b)Different source systems
Impact:
a)Hardest to detect
b)Requires fuzzy matching techniques (similarity scores)

--------------------------------------------------------------------------------------------------------------
Question 5 : Why should data validation be performed during transformation 
rather than after loading?
Answer 5: Key Reasons
1️)Prevents Bad Data from Entering Target Tables
Once invalid data is loaded, it:
a)Pollutes fact and dimension tables
b)Requires costly cleanup or reprocessing
During transformation:
Invalid records can be filtered, corrected, or rejected early.

2️)Reduces Rework and Rollbacks
Post-load validation often means:
a)Truncating tables
b)Re-running full ETL jobs
Transform-stage validation avoids:
a)Data rollback
b)Downtime for reports and dashboards

3️)Enforces Business Rules Early
Tansformation is where business logic lives.
a)Example rules:
Salary > 0
Order_Date ≤ Delivery_Date
b)Validating after load may allow logically incorrect data to influence reports.

4️)Improves Performance and Cost Efficiency
a)Validating after loading:
Consumes warehouse storage
Wastes compute resources
b)Validating during transformation:
Loads only clean, trusted data

5️)Enables Better Error Handling and Auditing
a)During transformation, ETL can:
Log rejected records
Send alerts
Route bad data to quarantine tables

-------------------------------------------------------------------------------------------------
Question 6 : Explain how business rules help in validating data accuracy. Give an example.
Answer 6: Business rules are predefined logical conditions derived from how a
business operates. They help validate data accuracy by ensuring that data is
not only technically correct, but also logically and contextually correct.
How Business Rules Ensure Data Accuracy
1️)Check Logical Correctness
a)Data may pass format checks but still be wrong.
Example: Age = 5 for an employee
→ Format is valid, but business rule fails.

2️)Enforce Real-World Constraints
a)Business rules reflect real-life scenarios.
Prevent impossible or invalid situations.
Example:
Order quantity must be > 0
Discount ≤ Product price

3️)Maintain Consistency Across Processes
a)Rules ensure the same logic is applied everywhere.
Example:
Order status “Delivered” must have a delivery date
Avoids mismatched data across systems.

4️)Improve Trust in Analytics
When business rules are enforced:
a)KPIs reflect true business performance
b)Decision-makers trust dashboards and reports

---------------------------------------------------------------------------------------------------------
*/
use etl;
CREATE TABLE Sales_Transactions(
Txn_ID INT PRIMARY KEY,
Customer_ID VARCHAR(5),
Customer_Name VARCHAR(20),
Product_ID VARCHAR(5),
Quantity INT,
Txn_Amount INT,
Txn_Date DATE,
City VARCHAR(10)
);
INSERT INTO Sales_Transactions VALUES(201, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(202, 'C102', 'Anjali Rao', 'P12', 1, 1500, '2025-12-01', 'Bengaluru'),
(203, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai'),
(204, 'C103', 'Suresh Iyer', 'P13', 3, 6000, '2025-12-02', 'Chennai'),
(205, 'C104', 'Neha Singh', 'P14', NULL, 2500, '2025-12-02', 'Delhi'),
(206, 'C105', 'N/A', 'P15', 1, NULL, '2025-12-03', 'Pune'),
(207, 'C106', 'Amit Verma', 'P16', 1, 1800, NULL, 'Pune'),
(208, 'C101', 'Rahul Mehta', 'P11', 2, 4000, '2025-12-01', 'Mumbai');

-- Question 7 : Write an SQL query on Sales_Transactions to list all duplicate keys and their counts using the
-- business key (Customer_ID + Product_ID + Txn_Date + Txn_Amount )
-- Answer:
           SELECT Customer_ID,Product_ID,Txn_Date,Txn_Amount,
           COUNT(*) AS duplicatescount FROM Sales_Transactions
           GROUP BY Customer_ID,Product_ID,Txn_Date,Txn_Amount
           HAVING COUNT(*)>1;
           
-- Question 8 : Enforcing Referential Integrity--Identify Sales_Transactions.
-- Customer_ID values that violate referential integrity when joined with
-- Customers_Master and write a query to detect such violations.
-- Answer 8: 
           CREATE TABLE Customers_Master(
           Customer_ID VARCHAR(10),
           CustomerName VARCHAR(20),
           City VARCHAR(10)
          );
         INSERT INTO Customers_Master VALUES('C101','Rahul Mehta','Mumbai'),
         ('C102','Anjali Rao','Bengaluru'),
         ('C103','Suresh Iyer','Chennai'),
         ('C104','Neha Singh','Delhi');
         
         SELECT DISTINCT S.Customer_ID FROM Sales_Transactions S
         LEFT JOIN Customers_Master M ON S.Customer_ID=M.Customer_ID
         WHERE M.Customer_ID IS NULL;
    


