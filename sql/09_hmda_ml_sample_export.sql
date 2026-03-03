-- Export the sample dataset as Parquet files to AWS S3 Bucket folder. Dataset to be loaded later in the ML notebook.

CREATE TABLE hmda_ml_sample_export
WITH (
    format = 'PARQUET',
    external_location = 's3://"your-bucket"/ml/sample_parquet/'
) AS
SELECT
    approved_flag,
    income_000s,
    loan_amount_000s,
    tract_minority_pct,
    tract_income_pct,
    loan_type,
    loan_purpose,
    occupancy_type,
    lien_status,
    channel_label,
    purchaser_label
FROM hmda_ml_sample;
