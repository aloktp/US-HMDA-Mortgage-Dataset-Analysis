# Methodology

This document outlines the architectural, analytical, and modeling approach used in the project.

---

## 1. Data Architecture

### 1.1 Partition Strategy

Raw HMDA Loan Application Register (LAR) files were stored in Amazon S3 using a year-based folder structure:

s3://bucket/raw/2019/  
s3://bucket/raw/2020/
s3://bucket/raw/2021/  
s3://bucket/raw/2022/  
s3://bucket/raw/2023/  
 
An external Athena table (`hmda_raw`) was created and partitioned by `year`.

Benefits:
- Partition pruning during queries
- Reduced scan cost
- Improved query performance
- Scalable ingestion for future years

---

### 1.2 Parquet Optimization

A CTAS (CREATE TABLE AS SELECT) operation was used to convert raw pipe-delimited files into a partitioned Parquet table (`hmda_parquet`).

Benefits:
- Columnar storage
- Reduced storage footprint
- Faster aggregation queries
- Lower Athena cost per query

The Parquet table retains the same year-based partition structure.

---

## 2. Feature Engineering Layer

A structured analytical view (`hmda_underwriting_features`) was created in Athena.

Transformations implemented in SQL include:

- TRY_CAST numeric conversions
- Loan-to-income ratio computation
- Income band segmentation
- Debt-to-income categorization
- Loan size bucketing
- Denial reason mapping
- Channel labeling
- Secondary market purchaser labeling
- Binary approval flag creation

This ensures reproducibility and transparency of derived metrics.

---

## 3. Data Validation & QA

Before modeling or dashboarding, structured validation checks were performed:

- Raw vs Parquet row count reconciliation
- Feature view row preservation checks
- Partition-level volume validation
- Approval rate verification
- Loan type distribution consistency checks

These steps ensured:
- No row loss during transformation
- No duplication
- Correct business logic mapping
- Stable dataset for analytics and modeling

---

## 4. Machine Learning Pipeline

Machine learning was implemented as a separate modeling layer built on top of the feature-engineered view.

### 4.1 Dataset Creation

Two modeling datasets were created:

1. 10% Sample Dataset (for rapid experimentation)
2. Full Dataset (for final model training)

Sampling was performed in Athena using SQL to ensure reproducibility.

---

### 4.2 Train-Test Split

An 80/20 train-test split was implemented in Python using scikit-learn.

- 80% Training set
- 20% Testing set
- Random state fixed for reproducibility

This ensures unbiased evaluation of model performance.

---

### 4.3 Model Selection

Logistic Regression was selected as the baseline model because:

- It is interpretable
- Suitable for binary classification
- Common in credit risk modeling
- Provides coefficient-based feature importance

The target variable:

approved_flag  
(1 = Approved, 0 = Not Approved)

---

### 4.4 Model Training

Training was conducted in Amazon SageMaker using:

- Python
- pandas
- numpy
- scikit-learn

Categorical variables were encoded using one-hot encoding.
Missing values were handled prior to training.

---

### 4.5 Model Evaluation

Model performance was evaluated using:

- Accuracy
- ROC-AUC
- Confusion Matrix
- Precision / Recall

ROC-AUC was used as the primary metric due to its robustness in classification tasks.

---

### 4.6 Feature Importance

Logistic regression coefficients were analyzed to identify:

- Strongest predictors of approval
- Relative impact of income
- Impact of debt-to-income category
- Channel influence
- Loan size influence

This provides interpretability aligned with credit analytics practices.

---

## 5. Architectural Separation

The project is structured into two independent layers:

Analytics Layer:
- Stable feature-engineered dataset
- Power BI dashboards
- Business insight generation

Machine Learning Layer:
- Experimental modeling
- Train-test validation
- Performance evaluation

This separation ensures:
- Dashboard stability
- Reproducible experimentation
- Clean architectural design
