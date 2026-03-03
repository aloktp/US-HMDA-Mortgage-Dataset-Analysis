# Data Dictionary

This document defines key derived and analytical fields used in the 
`hmda_underwriting_features` view.

---

## Core Derived Fields

| Field Name | Type | Description | Derivation Logic |
|------------|------|-------------|------------------|
| income_000s | DOUBLE | Applicant income (in USD) | TRY_CAST(income AS double) |
| loan_amount_000s | DOUBLE | Loan amount (in USD) | TRY_CAST(loan_amount AS double) |
| rate_spread | DOUBLE | Difference between loan rate and benchmark rate | TRY_CAST(rate_spread AS double) |
| tract_minority_pct | DOUBLE | % minority population in census tract | TRY_CAST(tract_minority_population_percent AS double) |
| tract_income_pct | DOUBLE | Tract income as % of MSA median | TRY_CAST(tract_to_msa_income_percentage AS double) |

---

## Risk & Underwriting Metrics

| Field Name | Type | Description | Derivation Logic |
|------------|------|-------------|------------------|
| loan_to_income_ratio | DOUBLE | Loan amount divided by applicant income | loan_amount / NULLIF(income, 0) |
| income_band | STRING | Income segmentation bucket | < 40k = Low, 40k–100k = Middle, > 100k = High |
| dti_band | STRING | Debt-to-Income categorical band | Based on debt_to_income_ratio ranges |
| loan_size_bucket | STRING | Loan size segmentation | <100k, 100–300k, 300–600k, >600k |

---

## Approval & Outcome Fields

| Field Name | Type | Description | Derivation Logic |
|------------|------|-------------|------------------|
| approved_flag | INTEGER | Binary approval indicator | 1 if action_taken IN (1,2), else 0 |
| action_taken | INTEGER | Original HMDA action code | Provided in raw dataset |
| denial_reason_1 | STRING | Primary denial reason code | Provided in raw dataset |
| denial_reason_label | STRING | Interpreted denial reason | CASE mapping of denial_reason_1 |

---

## Channel & Secondary Market Fields

| Field Name | Type | Description | Derivation Logic |
|------------|------|-------------|------------------|
| channel_label | STRING | Loan origination channel | CASE mapping of initially_payable_to_institution |
| purchaser_label | STRING | Secondary market purchaser | CASE mapping of purchaser_type |

---

## Notes

- TRY_CAST is used to prevent query failures due to malformed values.
- Derived fields are computed within Athena for analytical consistency.
- No filtering is applied at the feature view level; all records are retained.
