/* ============================================================
   06_validation_checks.sql
   HMDA Underwriting Feature View – Data Validation & QA
   ============================================================

   Purpose:
   Validate raw ingestion, partition integrity, Parquet conversion,
   feature engineering logic, and business metric consistency
   before dashboarding or ML modeling.
   ============================================================ */


/* ------------------------------------------------------------
   1. RAW TABLE VALIDATION
   ------------------------------------------------------------
   Objective:
   - Confirm external table schema alignment
   - Confirm pipe-delimited parsing correct
   - Confirm partition registered properly
------------------------------------------------------------ */

SELECT *
FROM hmda_raw
WHERE year = 2019
LIMIT 10;


/* ------------------------------------------------------------
   2. RAW → PARQUET ROW COUNT RECONCILIATION
   ------------------------------------------------------------
   Objective:
   - Ensure CTAS Parquet conversion did not drop rows
   - Validate partition-level consistency
------------------------------------------------------------ */

SELECT year, COUNT(*) AS raw_count
FROM hmda_raw
GROUP BY year
ORDER BY year;

SELECT year, COUNT(*) AS parquet_count
FROM hmda_parquet
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   3. FEATURE VIEW ROW COUNT VALIDATION
   ------------------------------------------------------------
   Objective:
   - Confirm feature view loads successfully
   - Confirm no row loss after feature engineering
------------------------------------------------------------ */

SELECT year, COUNT(*) AS feature_view_count
FROM hmda_underwriting_features
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   4. GLOBAL ROW COUNT SANITY CHECK
   ------------------------------------------------------------
   Objective:
   - Quick validation that dataset is accessible
   - Detect unexpected filtering or runtime failure
------------------------------------------------------------ */

SELECT COUNT(*) AS total_records
FROM hmda_underwriting_features;


/* ------------------------------------------------------------
   5. TOTAL APPLICATIONS BY YEAR
   ------------------------------------------------------------
   Objective:
   - Validate partition pruning
   - Confirm yearly volumes reasonable
   - Detect missing year partitions
------------------------------------------------------------ */

SELECT 
    year,
    COUNT(*) AS total_applications
FROM hmda_underwriting_features
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   6. APPROVAL RATE VALIDATION
   ------------------------------------------------------------
   Objective:
   - Validate approved_flag logic (action_taken IN (1,2))
   - Confirm macro trend realism across years
------------------------------------------------------------ */

SELECT 
    year,
    AVG(approved_flag) AS approval_rate
FROM hmda_underwriting_features
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   7. APPROVAL VOLUME RECONCILIATION
   ------------------------------------------------------------
   Objective:
   - Ensure SUM(approved_flag) aligns with AVG(approved_flag)
   - Confirm no misclassification in binary logic
------------------------------------------------------------ */

SELECT 
    year,
    COUNT(*) AS total_apps,
    SUM(approved_flag) AS total_approved,
    AVG(approved_flag) AS approval_rate
FROM hmda_underwriting_features
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   8. LOAN TYPE DISTRIBUTION CHECK
   ------------------------------------------------------------
   Objective:
   - Confirm categorical integrity post-Parquet conversion
   - Ensure no encoding or type corruption
------------------------------------------------------------ */

SELECT 
    year,
    loan_type,
    COUNT(*) AS volume
FROM hmda_underwriting_features
GROUP BY year, loan_type
ORDER BY year, loan_type;


/* ============================================================
   VALIDATION SUMMARY
   ============================================================

   These checks confirm:

   ✓ Raw ingestion integrity
   ✓ Partition registration correctness
   ✓ Parquet conversion accuracy
   ✓ Feature engineering row preservation
   ✓ Approval flag correctness
   ✓ Business metric consistency
   ✓ Categorical field stability

   After these validations, the dataset is considered
   stable for dashboarding and ML modeling.

   ============================================================ */
