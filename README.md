# MoPhones Credit Analytics

A comprehensive analysis of MoPhones' customer credit data, including portfolio KPIs, customer segmentation, and NPS (Net Promoter Score) linkage.

## Overview

This repository contains a Jupyter notebook (`Mophones.ipynb`) that performs end-to-end credit analytics on MoPhones' customer data. The analysis includes:

- Loading and processing point-in-time credit snapshots
- Customer demographic enrichment (age, gender, income)
- Account status derivation based on delinquency patterns
- Portfolio-level KPI calculations over time
- NPS response linkage to credit performance
- Data export and visualization generation

## Data Sources

The analysis expects the following input files in the root directory:

### Credit Snapshots
- `Credit Data - 01-01-2025.csv` (January 1, 2025 snapshot)
- `Credit Data - 30-03-2025.csv` (March 30, 2025 snapshot)
- `Credit Data - 30-06-2025.csv` (June 30, 2025 snapshot)
- `Credit Data - 30-09-2025.csv` (September 30, 2025 snapshot)
- `Credit Data - 30-12-2025.csv` (December 30, 2025 snapshot)

### Customer Data
- `Sales and Customer Data.xlsx` - Contains customer demographics, DOB, gender, and income information

### NPS Data
- `NPS Data.xlsx` - Customer satisfaction survey responses

## Key Assumptions

### 1. Account Status Derivation
Account status is determined based on Days Past Due (DPD) and balance information:

- **Closed**: `BALANCE == 0 AND CLOSING_BALANCE == 0`
- **Default**: `DAYS_PAST_DUE >= 90`
- **Arrears**: `1 <= DAYS_PAST_DUE < 90`
- **Current**: `DAYS_PAST_DUE == 0 AND BALANCE > 0`

*Note: If `BALANCE_DUE_TO_DATE` is positive, it's treated as an arrears proxy in metrics.*

### 2. Age Calculation
- Age is calculated as of the `REPORTING_DATE`
- Formula: `AGE_YEARS = ((REPORTING_DATE - DOB).days / 365.25)`
- Age bands are assigned using the following bins:
  - Below 18 / Invalid: < 18 years
  - 18–25: 18-25 years
  - 26–35: 26-35 years
  - 36–45: 36-45 years
  - 46–55: 46-55 years
  - Above 55: > 55 years

### 3. Income Calculation
- Average income per month: `TOTAL_INCOME / DURATION_MONTHS`
- Income bands are assigned using the following bins:
  - Below 5,000
  - 5,000–9,999
  - 10,000–19,999
  - 20,000–29,999
  - 30,000–49,999
  - 50,000–99,999
  - 100,000–149,999
  - 150,000 and above

### 4. NPS Linkage
- NPS responses are linked to the nearest credit snapshot by date
- Matching is done per `LOAN_ID` (customer identifier)
- The closest reporting date to the NPS submission date is selected
- NPS groups are classified as:
  - Detractor: 0-6
  - Passive: 7-8
  - Promoter: 9-10
  - Unknown: Invalid/missing scores

### 5. Data Processing
- All dates are standardized to datetime format
- Missing values are handled appropriately (left joins preserve credit data)
- Income calculations handle division by zero (replace 0 duration with NaN)
- Numeric fields are coerced with error handling

## Output Files

The analysis generates the following CSV files in the `outputs/` directory:

- `portfolio_kpis.csv` - Portfolio-level metrics by reporting date
- `segment_metrics.csv` - KPIs segmented by age band, income band, and region
- `roll_rates.csv` - Account status transition rates
- `status_transitions.csv` - Detailed status transition counts
- `nps_by_status.csv` - NPS metrics by account status
- `nps_linkage_detail.csv` - Individual NPS responses linked to credit data

## Dependencies

```python
pandas
numpy
matplotlib
openpyxl
```

## Usage

1. Place all required data files in the root directory
2. Run the Jupyter notebook `Mophones.ipynb` from start to finish
3. Check the `outputs/` directory for generated CSV files and charts

## Methodology

1. **Data Loading**: Load credit snapshots, customer demographics, and NPS data
2. **Data Cleaning**: Standardize column names and data types
3. **Enrichment**: Join customer demographics to credit data
4. **Derivation**: Calculate age bands, income bands, and account statuses
5. **Aggregation**: Compute portfolio KPIs and segment metrics
6. **NPS Linkage**: Match survey responses to nearest credit snapshots
7. **Export**: Save results as CSV files for further analysis

## Notes

- The analysis assumes quarterly credit snapshots at the start of January and end of each quarter
- Customer identifiers are assumed to be consistent across all data sources
- Income averaging uses total contract duration as the denominator
- NPS linkage prioritizes temporal proximity for most relevant credit context</content>
<parameter name="filePath">c:\Users\ADMIN\Documents\mophones\README.md
