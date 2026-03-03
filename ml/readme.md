## Machine Learning Modeling – Mortgage Underwriting Classification

A scalable logistic regression model was developed using **Stochastic Gradient Descent (SGDClassifier)** to predict mortgage approval outcomes using structured underwriting features from the US HMDA dataset.

---

### Dataset Overview

- **Sample Size:** 8.27 million mortgage applications  
- **Target Variable:** `approved_flag`  
  - `1` = Approved  
  - `0` = Denied  
- **Class Distribution:**  
  - 61.6% Approved  
  - 38.4% Denied  

Features include borrower income, loan structure, census tract characteristics, leverage ratios, channel type, and purchaser type.

---

### Feature Engineering & Modeling Approach

- Engineered **Loan-to-Income (LTI)** ratio  
- Removed extreme LTI outliers for numerical stability  
- Applied **log transformation** to income and loan amount  
- One-hot encoded categorical features  
- Standardized numerical variables  
- 80/20 train-test split  
- Logistic regression trained using **SGD (log-loss objective)** for scalability  

This approach ensures the model scales efficiently across multi-million record datasets.

---

### Model Performance

| Metric | Value |
|--------|--------|
| **ROC-AUC** | **0.913** |
| **Accuracy** | **81.9%** |
| **Approval Precision** | **90.3%** |
| **Approval Recall** | **79.1%** |
| **Denial Recall** | **86.5%** |
| **F1 Score (Approved)** | **0.84** |

---

### Interpretation

- The **ROC-AUC of 0.913** indicates excellent separability between approved and denied loans.
- High **precision (90%)** suggests low false-approval risk.
- Strong denial recall (86.5%) demonstrates effective identification of rejected applications.
- The model converged efficiently in 7 epochs using parallelized SGD.

---

### Key Drivers of Approval

**Positive Influences:**
- Higher borrower income
- Favorable lien structures
- Government-backed purchaser channels (e.g., Ginnie Mae)
- Higher tract income percentage

**Negative Influences:**
- Higher loan-to-income ratios (leverage sensitivity)
- Correspondent lending channel
- Certain loan types
- Loans retained on balance sheet

---

### Business Implication

The model captures core underwriting dynamics at scale:

- Income strength materially increases approval likelihood  
- Higher leverage reduces approval probability  
- Channel and secondary market structure significantly influence outcomes  

The strong ROC-AUC confirms that structured underwriting variables alone provide substantial predictive power.

---
