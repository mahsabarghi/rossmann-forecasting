"""
Rossmann Forecasting Project - Training Config

Purpose
-------
Centralize training settings so runs are reproducible and config-driven.

Notes
-----
- SQL in BigQuery produces the final modeling dataset:
    rossmann_analytics.v_features_model_ready
- Python consumes that view and trains a single global model across stores.
"""

# -----------------------------
# BigQuery source
# -----------------------------
PROJECT_ID = "mahsa-rossmann-forecasting"
DATASET = "rossmann_analytics"
TABLE = "v_features_model_ready"  # final, leakage-safe dataset view

# -----------------------------
# Dataset columns
# -----------------------------
TARGET_COL = "sales_t_plus_1"
SPLIT_COL = "split"

# -----------------------------
# Feature columns
# -----------------------------
# Numeric features used in the baseline model
NUMERIC_FEATURES = [
    "sales",
    "customers",
    "is_open",
    "promo",
    "school_holiday",
    "competition_distance",
    "sales_lag_1",
    "sales_lag_7",
    "sales_rollmean_7",
    "year",
    "month",
    "day_of_month",
    "week_of_year",
]

# Categorical features (handled natively by LightGBM)
CATEGORICAL_FEATURES = [
    "store_type",
    "assortment",
    "state_holiday",
    "day_of_week",
]

# -----------------------------
# LightGBM parameters (baseline)
# -----------------------------
LGBM_PARAMS = {
    # Objective for regression forecasting
    "objective": "regression",

    # Evaluation metric: Will be computed in Python (RMSE), but keeping here for completeness
    "metric": "rmse",

    # Reasonable baseline complexity
    "learning_rate": 0.05,
    "num_leaves": 63,
    "min_data_in_leaf": 50,

    # Reproducibility
    "random_state": 42,

    # Speed
    "n_estimators": 500,
}
