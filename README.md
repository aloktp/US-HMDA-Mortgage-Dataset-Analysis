# US HMDA Mortgage Dataset Analysis

## Case Study Question

Does borrower income, leverage, loan structure, and channel information explain mortgage approval outcomes in the HMDA dataset?

## Project Overview

This project analyzes five years (2019–2023) of U.S. mortgage loan-level data from the Home Mortgage Disclosure Act (HMDA) dataset. The objective is to examine underwriting patterns, approval trends, denial behavior, and lending structure across changing economic conditions.

The workflow was implemented entirely within AWS for data processing, with Power BI used for executive-level visualization.

---

## Technology Stack

- AWS S3 (Data Lake)
- Amazon Athena (SQL & Parquet optimization)
- Python (pandas, scikit-learn)
- SageMaker (Model training)
- Power BI (Visualization & Reporting)
  
---

## Data Architecture

HMDA Pipe Files (S3 raw/) ➝ Athena External Table (hmda_raw) ➝ Partitioned Parquet Table (hmda_parquet) ➝ Feature Engineering View (hmda_underwriting_features) ➝ Power BI Dashboard

---

## Data Pipeline

### 1. Raw Data Layer
- Uploaded HMDA pipe-delimited Loan Application Register (LAR) files (2019–2023) to Amazon S3.
- Created a partitioned external table in Athena.

### 2. Parquet Optimization
- Converted raw pipe files into a partitioned Parquet table using CTAS.
- Reduced scan cost and improved query performance.

### 3. Feature Engineering Layer
Created a structured analytical view with derived underwriting features:

- Loan-to-income ratio
- Income bands
- Debt-to-income bands
- Loan size buckets
- Approval flag (based on action_taken)
- Channel and purchaser labels
- Minority tract indicators

### 4. Validation & QA
Performed structured validation checks:
- Row count reconciliation (raw vs parquet vs feature view)
- Approval rate verification by year
- Volume checks by loan type
- Distribution consistency checks

---

## Analytical Focus Areas

- Approval rate trends across years
- Income segmentation analysis
- Loan size distribution
- Denial reason patterns
- Channel distribution (Direct, Broker, Correspondent)
- Secondary market purchaser trends
- Minority tract approval comparisons

---

## Dataset Scale

- Approximately 30GB of raw mortgage data
- ~5 years of national loan-level records
- Partitioned by year for optimized querying

---

## Power BI Dashboard

An executive Power BI dashboard was developed to analyze:

- Approval rates across years
- Loan structure segmentation
- Denial reason patterns
- Channel and purchaser distributions
- Mortgage volume trends

The dashboard integrates structured underwriting features and derived risk metrics for exploratory analysis.

---

## Machine Learning Model

A scalable logistic regression model was built to classify mortgage approval outcomes using 8.27 million applications.

- Predict mortgage approval outcomes from structured underwriting variables
- Binary classification problem (Approved vs Denied)
- Logistic regression chosen for interpretable credit decision modeling
- SGDClassifier (log-loss) used for scalable training on millions of records (8.2M sample)
- 80/20 train-test split
- Standardized numerical features
- Parallelized optimization for efficient training
- Converged in 7 epochs

### Key Results

- ROC-AUC: 0.913
- Accuracy: 81.9%
- Approval Precision: 90.3%
- Approval Recall: 79.1%

The model demonstrates strong separability between approved and denied loans using structured underwriting variables.

### Business Insights

- Higher borrower income materially increases approval probability
- Higher leverage (Loan-to-Income) reduces approval likelihood
- Channel and secondary market structure influence underwriting outcomes

### Model Monitoring

Performance stability was evaluated across years using ROC-AUC drift and portfolio-level leverage trends.

No significant model degradation was observed.

---
