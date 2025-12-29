/*
Question 1 : What are the most common reasons for missing data in ETL pipelines?
Answer  :1. Source System Issues--

A)Data not captured at the source (optional fields left blank by users)

B)Legacy systems that do not enforce mandatory fields

C)Sensor or logging failures in source applications

Example: customer_phone missing because users skipped it during signup.

2. Data Extraction Failures

A)Partial extraction due to network timeouts or API rate limits

B)Incremental load logic missing some records

C)Corrupted files during transfer (FTP/SFTP issues)

Example: API returns only 90% of records due to pagination errors.

3. Schema Mismatch or Changes

A)New columns added in source but not handled in ETL

B)Column renamed or data type changed without updating mappings

C)Fields dropped during schema evolution

Example: email_id renamed to email causing NULL values.

4. Transformation Errors

A)Invalid data filtered out by business rules

B)Join conditions removing records (INNER JOIN instead of LEFT JOIN)

C)Failed type casting (string → date/number)

Example: Dates like 31-02-2024 becoming NULL after conversion.

5. Data Integration Problems

A)Missing reference data in lookup tables

B)Late-arriving dimensions in data warehouses

C)Key mismatches across systems

Example: product_id not found in product dimension table.

6. Manual Data Entry Errors

A)Users leaving fields empty

B)Typos or inconsistent formatting

C)Default values not provided

Example: Gender entered as empty instead of Male/Female.

7. Data Privacy & Compliance Rules

A)Fields masked or removed due to GDPR/PII policies

B)Sensitive data excluded from downstream systems

Example: SSN removed during transformation.

8. Load Failures

A)Records rejected due to constraint violations

B)Batch job failures or partial loads

C)Duplicate or invalid primary keys

Example: Rows rejected due to NOT NULL constraint.

9. Time-based Data Issues

A)Late-arriving data

B)Clock/timezone mismatches

C)Snapshot vs transactional data differences

Question 2: Why is blindly deleting rows with missing values considered a bad practice in ETL?
Answer : Here are some of the points why its bad to blindly deleting rows:
1. Loss of Valuable Data

a)A row may have one missing field but many valid and important fields.

b)Deleting it removes potentially useful business information.

Example:
Order record missing discount_code but having valid order_id, amount, and customer_id.

2. Data Bias & Skewed Analysis

a)Missing values are often not random.

b)Removing rows can bias analytics and ML models.

Example:
Low-income users skipping optional fields → deleting rows removes a specific user segment.

3. Incorrect Business Metrics

a)KPIs like revenue, conversion rate, or churn become inaccurate.

b)Counts and aggregates get underreported.

Example:
Deleted rows → lower total sales than actual.

4. Breaks Data Lineage & Auditing

a)No trace of what was removed and why.

b)Makes debugging and compliance audits difficult.

5. Hides Upstream Data Quality Issues

a)Deleting data masks problems in source systems or ETL logic.

b)Issues never get fixed, they just get hidden.

6. Negative Impact on Machine Learning Models

a)Reduced training data

b)Poor generalization

c)Bias toward “complete” records

7. Violates Business Rules

a)Some fields are optional by design.

b)Treating optional NULLs as errors causes unnecessary data loss.

8. Referential Integrity Problems

a)Deleting fact records can break relationships with dimension tables.

Example:
Fact sales record deleted → orphaned dimension references.

9. Regulatory & Compliance Risks

a)Required historical records may be lost.

b)Violates data retention policies.

Question 3: Explain the difference between:
           a)Listwise deletion
           b)Column deletion
Also mention one scenario where each is appropriate.
Answer 3: 1. Listwise Deletion (Row Deletion)
    Entire rows (records) are removed if any one of the selected columns 
    contains a missing value.
    
| id | age  | email                     | salary |
| -- | ---- | ------------------------- | ------ |
| 1  | 25   | [a@x.com](mailto:a@x.com) | 50000  |
| 2  | NULL | [b@x.com](mailto:b@x.com) | 60000  |
| 3  | 30   | NULL                      | 70000  |

After listed deletion: 
| id | age | email                     | salary |
| -- | --- | ------------------------- | ------ |
| 1  | 25  | [a@x.com](mailto:a@x.com) | 50000  |

Pros:

a)Simple to implement

b)Ensures complete cases only

Cons:

a)High data loss

b)Introduces bias

c)Bad for ETL and analytics pipelines

When acceptable:

a)Small datasets

b)Statistical tests requiring complete rows

Example scenario:

a)Financial or statistical analysis where all variables must be present

b)Exam results dataset where score, subject, student_id are all compulsory

2. Column Deletion (Feature Deletion)
Entire columns (fields/features) are removed if they have a high 
percentage of missing values or are not business-critical.

| id | age | email                     | loyalty_score |
| -- | --- | ------------------------- | ------------- |
| 1  | 25  | [a@x.com](mailto:a@x.com) | NULL          |
| 2  | 30  | [b@x.com](mailto:b@x.com) | NULL          |
| 3  | 35  | [c@x.com](mailto:c@x.com) | NULL          |

After column deletion:
| id | age | email                     |
| -- | --- | ------------------------- |
| 1  | 25  | [a@x.com](mailto:a@x.com) |
| 2  | 30  | [b@x.com](mailto:b@x.com) |
| 3  | 35  | [c@x.com](mailto:c@x.com) |

Pros:

a)Preserves row count

b)Useful when column has little value

Cons:

a)Permanent loss of that attribute

b)May impact future analysis

When acceptable:

a)Column is optional or unused

b)70–80% missing values

c)Not required by business logic

Example scenario:

a)Optional customer profile field (e.g., middle_name, fax_number).

b)Marketing attribute collected inconsistently across systems.

Quetion 4:  Why is median imputation preferred over mean imputation for skewed data such as income?
Answer 4: Median imputation is preferred over mean imputation for 
skewed data (like income) because it is robust to outliers and better 
represents the typical value of the distribution.
Key Reasons
1. Less Sensitive to Outliers
a)Income data usually has extreme high values (a few very high earners).

b)The mean gets pulled upward by these outliers.

c)The median remains stable.

Example:
Incomes: 30k, 32k, 35k, 38k, 40k, 500k
Mean ≈ 112k (misleading)
Median = 36.5k (realistic)

2. Better Representation of Central Tendency

a)For skewed distributions, the median reflects the typical 
individual better than the mean.

b)Imputing with the median avoids inflating values artificially.

3. Prevents Distortion of Downstream Analysis

a)Mean imputation increases overall averages, totals, and variance.

b)Median imputation preserves distribution shape more accurately.

4. Improves Model Stability

a)Machine learning models become less biased.

b)Reduces noise caused by extreme values.

5. Common Best Practice in ETL

a)Income, salary, transaction amounts, house prices → median

b)Symmetric data (height, temperature) → mean

Question 5: What is forward fill and in what type of dataset is it most useful?
Answer 5: Forward fill (also called forward propagation or carry-forward
 imputation) is a method where a missing value is filled using the most
 recent previous non-null value in the same column.
 When a value is missing at time t, it is replaced with the value from time t-1.
Example: 
 | Date   | Stock Price |
| ------ | ----------- |
| 01-Jan | 100         |
| 02-Jan | NULL        |
| 03-Jan | NULL        |
| 04-Jan | 105         |

After forward fill:
| Date   | Stock Price |
| ------ | ----------- |
| 01-Jan | 100         |
| 02-Jan | 100         |
| 03-Jan | 100         |
| 04-Jan | 105         |

Where Is Forward Fill Most Useful?
Time-Series / Sequential Data---
Forward fill works best when values change slowly over time and the last
observed value is still valid until updated.
Common datasets:
a)Stock prices (non-trading days)
b)Sensor readings
c)System configuration logs
d)Daily account balances
e)IoT telemetry
f)Slowly changing dimensions (SCD Type-2 attributes like status)

Question 6: Why should flagging missing values be done before imputation in an ETL workflow?
Answer 6: Flagging missing values before imputation is a best practice in 
ETL because it preserves information, improves transparency, and prevents 
analytical bias. Once you impute, the fact that data was missing is
otherwise lost forever.

Key Reasons
1. Preserves Missingness Information

a)Missingness itself can carry business meaning.

b)After imputation, original NULLs are indistinguishable from real values.

Example:
email_missing = 1 may indicate low user engagement.

2. Improves Model Performance

a)ML models can learn patterns from missingness flags.

b)Helps capture non-random missing data (MNAR).

Example:
High-income users skipping income field → flag becomes predictive.

3. Enables Auditing & Debugging

a)You can trace which values were originally missing.

b)Helps validate ETL logic and data quality.

4. Supports Multiple Imputation Strategies

a)Same dataset can be reused with different imputations.

b)No need to re-extract data.

5. Avoids Silent Data Corruption

a)Prevents treating imputed values as real facts.

b)Maintains trust in downstream analytics.

Question 7: Consider a scenario where income is missing for many customers.
 How can this missingness itself provide business insights?
Answer 7:  
 1. Customer Trust & Privacy Sensitivity

a)Customers who skip income fields may be privacy-conscious or less trusting.

b)Indicates hesitation to share sensitive information.

Business insight:
These customers may respond better to trust-building messaging rather than aggressive personalization.

2. Socio-Economic Segmentation

a)Missing income is often not random.

b)Certain income groups (very low or very high earners) tend to skip disclosure.

Business insight:
Missing income can act as a proxy segment when explicit income is unavailable.

3. Product Affordability & Pricing

a)Customers without income data may avoid high-priced products.

b)Can correlate with lower conversion on premium offerings.

Business insight:
Offer budget plans or flexible pricing to this segment.

4. Data Collection & UX Issues

High missing rates may indicate:

a)Poor form design

b)Optional field placement

c)Confusing wording

Business insight:
Improve UX or ask income in ranges instead of exact numbers.
 
*/
CREATE TABLE empsale(
Customer_ID INT PRIMARY KEY,
Name VARCHAR(50),
City VARCHAR(50),
Monthly_Sales INT,
Income INT,
Region VARCHAR(50)
);
INSERT INTO empsale VALUES(101,'Rahul Mehta','Mumbai',12000,65000,'West'),
(102,'Anjali Rao','Bengaluru',NULL,NULL,'South'),
(103,'Suresh Rao','Chennai',15000,72000,'South'),
(104,'Neha Singh','Delhi',NULL,NULL,'North'),
(105,'Amit Verma','Pune',18000,58000,NULL),
(106,'Karan Shah','Ahmedabad',NULL,61000,'West'),
(107,'Pooja Das','Kolkata',14000,NULL,'East'),
(108,'Riya Kapoor','Jaipur',16000,69000,'North');

-- QUESTION 8 
-- 1.FINDING ROWS WHERE REGION IS NULL
SELECT * FROM empsale WHERE Region IS NULL;
SET SQL_SAFE_UPDATES=0;
-- 2.DATASET AFTER DELETION
DELETE FROM empsale WHERE Region IS NULL;
-- 3.HOW MANY RECORDS LOST
SELECT COUNT(*) FROM empsale;-- earlier it was 8 now 7

-- Question 9
-- 1.Forward fill = use the last known non-NULL value.
SELECT Name,COALESCE(Monthly_Sales,LAG(Monthly_Sales) OVER 
(ORDER BY Region)) AS Monthly_Sales_Filled FROM empsale;

-- 2.before vs after values
SELECT Monthly_Sales AS beforevalue,COALESCE(Monthly_Sales,
LAG(Monthly_Sales) OVER (ORDER BY Region)) AS aftervalue FROM empsale;

-- 3. why suitable
/*
Reason 1: Time-Series Data

a)Monthly sales are ordered by time

b)Forward fill respects temporal continuity

Reason 2: Missing Means “No Update”

a)NULL months likely mean sales continued at last known level

b)No new data reported, not zero sales
*/
-- Question 10
-- 1.Create Income_Missing_Flag (0 = present, 1 = missing)
SELECT name,income,
CASE
  WHEN Income IS NULL THEN 1
  ELSE 0
  END AS income_missing_flag
FROM empsale;

-- 2.updated dataset
SELECT Customer_ID,Name,City,Monthly_Sales,income,Region,
CASE
  WHEN Income IS NULL THEN 1
  ELSE 0
  END AS income_missing_flag
FROM empsale;
-- 3.Customer hahing missing income
SELECT COUNT(*) AS missing_income_count
FROM empsale
WHERE Income IS NULL;











 
 








    
    