-- Run each sql command seperately if you are running in Amazon Athena

ALTER TABLE hmda_raw ADD PARTITION (year=2019) LOCATION 's3://"your-bucket"/raw/2019/';
ALTER TABLE hmda_raw ADD PARTITION (year=2020) LOCATION 's3://"your-bucket"/raw/2020/';
ALTER TABLE hmda_raw ADD PARTITION (year=2021) LOCATION 's3://"your-bucket"/raw/2021/';
ALTER TABLE hmda_raw ADD PARTITION (year=2022) LOCATION 's3://"your-bucket"/raw/2022/';
ALTER TABLE hmda_raw ADD PARTITION (year=2023) LOCATION 's3://"your-bucket"/raw/2023/';
