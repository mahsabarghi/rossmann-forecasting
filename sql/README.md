# SQL Layer

This folder contains all **BigQuery view definitions** used to build the modeling dataset.

## Design

The SQL pipeline follows a layered architecture:

1. **Clean** – Normalize raw tables (types, null handling, date parsing)
2. **Join** – Join `train` + `store` into a single canonical dataset
3. **Label** – Create next-day target `sales_t_plus_1`
4. **Features** – Feature engineering (calendar, promo signals, lags/rolling stats)
5. **Splits** – Strict time-based train/valid/test splits (leakage-safe)

## Contract with Python

All modeling data is produced in BigQuery via views.

Python training code reads only the final split views and trains a **single global model across all stores**.
