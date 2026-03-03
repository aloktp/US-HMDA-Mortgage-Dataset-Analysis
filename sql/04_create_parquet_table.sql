-- Replace "your-bucket" with your bucket name.

CREATE TABLE hmda_parquet
WITH (
    format = 'PARQUET',
    external_location = 's3://"your-bucket"/curated/',
    partitioned_by = ARRAY['year']
) AS
SELECT * FROM hmda_raw;
