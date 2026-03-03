-- This is the SQL View that will create the fields that will power the PowerBI dashboards.

CREATE VIEW hmda_underwriting_features AS
SELECT
    year,
    loan_type,
    loan_purpose,
    occupancy_type,
    lien_status,
    conforming_loan_limit,

    TRY_CAST(income AS double) AS income_000s,
    TRY_CAST(loan_amount AS double) AS loan_amount_000s,
    TRY_CAST(rate_spread AS double) AS rate_spread,
    TRY_CAST(tract_minority_population_percent AS double) AS tract_minority_pct,
    TRY_CAST(tract_to_msa_income_percentage AS double) AS tract_income_pct,

    debt_to_income_ratio,
    denial_reason_1,
    action_taken,

    CASE
        WHEN TRY_CAST(loan_amount AS double) < 100000 THEN '<100k'
        WHEN TRY_CAST(loan_amount AS double) < 300000 THEN '100-300k'
        WHEN TRY_CAST(loan_amount AS double) < 600000 THEN '300-600k'
        ELSE '>600k'
    END AS loan_size_bucket,

    CASE
        WHEN denial_reason_1 = '1' THEN 'DTI'
        WHEN denial_reason_1 = '2' THEN 'Employment History'
        WHEN denial_reason_1 = '3' THEN 'Credit History'
        WHEN denial_reason_1 = '4' THEN 'Collateral'
        WHEN denial_reason_1 = '5' THEN 'Insufficient Cash'
        WHEN denial_reason_1 = '6' THEN 'Unverifiable Info'
        WHEN denial_reason_1 = '7' THEN 'Incomplete Application'
        WHEN denial_reason_1 = '8' THEN 'Mortgage Insurance Denied'
        WHEN denial_reason_1 = '9' THEN 'Other'
        ELSE NULL
    END AS denial_reason_label,

    -- SAFE CHANNEL LABEL (force varchar)
    CASE
        WHEN CAST(initially_payable_to_institution AS varchar) = '1' THEN 'Direct'
        WHEN CAST(initially_payable_to_institution AS varchar) = '2' THEN 'Broker'
        WHEN CAST(initially_payable_to_institution AS varchar) = '3' THEN 'Correspondent'
        ELSE 'Other'
    END AS channel_label,

    -- SAFE PURCHASER LABEL
    CASE
        WHEN CAST(purchaser_type AS varchar) = '0' THEN 'Retained'
        WHEN CAST(purchaser_type AS varchar) = '1' THEN 'Fannie Mae'
        WHEN CAST(purchaser_type AS varchar) = '2' THEN 'Ginnie Mae'
        WHEN CAST(purchaser_type AS varchar) = '3' THEN 'Freddie Mac'
        WHEN CAST(purchaser_type AS varchar) = '5' THEN 'Private'
        ELSE 'Other'
    END AS purchaser_label,

    TRY_CAST(loan_amount AS double) /
        NULLIF(TRY_CAST(income AS double), 0) AS loan_to_income_ratio,

    CASE 
        WHEN TRY_CAST(income AS double) < 40000 THEN 'Low'
        WHEN TRY_CAST(income AS double) BETWEEN 40000 AND 100000 THEN 'Middle'
        WHEN TRY_CAST(income AS double) > 100000 THEN 'High'
        ELSE 'Unknown'
    END AS income_band,

    CASE
        WHEN debt_to_income_ratio IN ('<20%', '20%-<30%') THEN 'Low DTI'
        WHEN debt_to_income_ratio IN ('30%-<36%', '36%-<43%') THEN 'Moderate DTI'
        WHEN debt_to_income_ratio IS NOT NULL THEN 'High DTI'
        ELSE 'Unknown'
    END AS dti_band,

    CASE 
        WHEN action_taken IN (1,2) THEN 1
        ELSE 0
    END AS approved_flag,

    initially_payable_to_institution,
    purchaser_type

FROM hmda_parquet;
