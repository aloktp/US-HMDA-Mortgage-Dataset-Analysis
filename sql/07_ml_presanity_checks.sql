/* ============================================================
   07_ml_presanity_checks.sql
   ML PRE-SANITY CHECKS (QA LAYER)
   Dataset: hmda_underwriting_features
   Purpose: Validate data quality before ML modelling
   Author: Alok
   ============================================================ */


/* ------------------------------------------------------------
   CHECK 1 — CLASS BALANCE
   ------------------------------------------------------------
   Objective:
   - Count records by approved_flag
   - Compute class share

   Findings:
   - Approved (1): ~55.5M records (~57.2%)
   - Not Approved (0): ~41.6M records (~42.8%)
   - Dataset is moderately balanced.
   - No severe class imbalance detected.
   - No resampling techniques required at this stage.
------------------------------------------------------------ */

SELECT
    approved_flag,
    COUNT(*) AS count_records,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS share
FROM hmda_underwriting_features
GROUP BY approved_flag
ORDER BY approved_flag;



/* ------------------------------------------------------------
   CHECK 2 — NULL PROFILING
   ------------------------------------------------------------
   Objective:
   - Count NULL values in key modelling fields

   Findings:
   - ~13.1M NULL values in income_000s
   - ~5 NULL values in loan_amount_000s
   - ~14.3M NULL values in loan_to_income_ratio
   - Total dataset size: ~97.1M rows
   - Approximately 14–15% of dataset contains missing income/LTI.
   - These rows must be filtered or imputed before ML training.
------------------------------------------------------------ */

SELECT
    SUM(CASE WHEN income_000s IS NULL THEN 1 ELSE 0 END) AS null_income,
    SUM(CASE WHEN loan_amount_000s IS NULL THEN 1 ELSE 0 END) AS null_loan,
    SUM(CASE WHEN loan_to_income_ratio IS NULL THEN 1 ELSE 0 END) AS null_lti,
    COUNT(*) AS total_rows
FROM hmda_underwriting_features;



/* ------------------------------------------------------------
   CHECK 3 — OUTLIER CHECK (Loan-to-Income Ratio)
   ------------------------------------------------------------
   Objective:
   - Detect extreme or corrupted ratio values

   Findings:
   - Minimum LTI: -3.44e7 (negative → invalid)
   - Maximum LTI: 4.36e9 (unrealistic)
   - Average LTI: ~3014 (not economically plausible)
   - Indicates corrupted income or loan values.
   - Outlier filtering required prior to modelling.
------------------------------------------------------------ */

SELECT
    MIN(loan_to_income_ratio) AS min_lti,
    MAX(loan_to_income_ratio) AS max_lti,
    AVG(loan_to_income_ratio) AS avg_lti
FROM hmda_underwriting_features
WHERE loan_to_income_ratio IS NOT NULL;



/* ------------------------------------------------------------
   CHECK 4 — INCOME & LOAN DISTRIBUTION CHECK
   ------------------------------------------------------------
   Objective:
   - Validate economic realism of income & loan amounts

   Findings:
   - Minimum income: -899,459 (invalid)
   - Maximum income: 7.17e8 (extreme outlier)
   - Minimum loan amount: -1.39e9 (invalid)
   - Maximum loan amount: 5.00e11 (extreme outlier)
   - These values suggest placeholder codes or malformed entries.
   - Threshold-based filtering required before ML pipeline.
------------------------------------------------------------ */

SELECT
    MIN(income_000s) AS min_income,
    MAX(income_000s) AS max_income,
    AVG(income_000s) AS avg_income,
    MIN(loan_amount_000s) AS min_loan_amt,
    MAX(loan_amount_000s) AS max_loan_amt,
    AVG(loan_amount_000s) AS avg_loan_amt
FROM hmda_underwriting_features;


/* ============================================================
   QA CONCLUSION
   ============================================================

   Summary of Pre-ML Data Quality Findings:

   ✓ Class distribution acceptable for binary modelling
   ✗ Significant null presence in income-related fields
   ✗ Extreme outliers detected in income and loan values
   ✗ Unrealistic loan-to-income ratios observed

   Action Required:
   - Remove rows with NULL numeric fields
   - Apply economically reasonable thresholds
   - Re-validate distributions before modelling

   I have created a view table hmda_ml_dataset_clean to do this data cleaning before loaing into ML model in ML notebook.

   ============================================================ */

/* ------------------------------------------------------------
   CLEAN ML DATASET VIEW
   ------------------------------------------------------------*/
/* ===========================================================================
   hmda_ml_dataset_clean
   Dataset: Cleaned HMDA underwriting feature set
   Purpose: Retain economically plausible records for ML modelling
   Rationale:
     - Income and loan_amount fields represent whole-dollar values in HMDA data.
     - Derived loan_to_income_ratio is valid when computed as loan_amount / income.
     - Extreme outliers are filtered using reasonable thresholds to preserve real patterns
       while removing corrupted or nonsensical entries.
   ===========================================================================
*/

CREATE OR REPLACE VIEW hmda_ml_dataset_clean AS
SELECT *
FROM hmda_underwriting_features

WHERE

    -- 1) Filter out rows with missing key numeric fields
    income_000s IS NOT NULL
    AND loan_amount_000s IS NOT NULL
    AND loan_to_income_ratio IS NOT NULL

    -- 2) Filter out negative or zero values; only real economic values
    AND income_000s > 0
    AND loan_amount_000s > 0

/* ------------------------------------------------------------
   Now the above sanity checks run on this hmda_ml_dataset_clean provides good dataset.
From 97 Million records in original dataset, we get good quality 82 Million Records without NULL values which we feed into ml model.

There are a lot of outliers because Income is in thousands, while loan amount is in actual value. We will clean this dataset further int eh ML notebook.
   ------------------------------------------------------------*/


