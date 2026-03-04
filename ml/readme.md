# Machine Learning – Mortgage Underwriting Classification

## Case Study Question

Does borrower income, leverage, loan structure, and channel information explain mortgage approval outcomes in the HMDA dataset?

## Overview

A scalable logistic regression model was developed using stochastic gradient descent (SGDClassifier) to classify mortgage approval outcomes from the US HMDA dataset.

The objective was to evaluate whether structured underwriting variables can effectively distinguish approved and denied applications at scale.

---

## Dataset

- Sample Size: 8.27 million mortgage applications
- Target Variable: `approved_flag`
  - 1 = Approved
  - 0 = Denied
- Class Distribution:
  - 61.6% Approved
  - 38.4% Denied

---

## Feature Engineering

- Engineered Loan-to-Income (LTI) ratio
- Removed extreme LTI outliers (>20)
- Log transformation applied to income and loan amount
- One-hot encoding for categorical features
- Standard scaling for numerical stability

---

## Modeling Approach

- Predict mortgage approval outcomes from structured underwriting variables
- Binary classification problem (Approved vs Denied)
- Logistic regression chosen for interpretable credit decision modeling
- SGDClassifier (log-loss) used for scalable training on millions of records (8.2M sample)
- 80/20 train-test split
- Standardized numerical features
- Parallelized optimization for efficient training
- Converged in 7 epochs

---

## Model Performance

| Metric | Value |
|--------|--------|
| ROC-AUC | 0.913 |
| Accuracy | 81.9% |
| Approval Precision | 90.3% |
| Approval Recall | 79.1% |
| Denial Recall | 86.5% |
| F1 Score (Approved) | 0.84 |

---

## Interpretation

The model demonstrates strong discriminatory power (AUC > 0.90).

Higher borrower income and favorable loan structures increase approval likelihood, while higher leverage (Loan-to-Income) reduces approval probability.

Channel and purchaser type significantly influence underwriting outcomes.

---

## Monitoring

Model stability was evaluated by:

- ROC-AUC by year
- Approval rate drift over time
- Average Loan-to-Income trends

No significant degradation in predictive power was observed across years.
