"""
Rossmann Forecasting - Training Script

Purpose
-------
- Load model-ready dataset from BigQuery
- Split using pre-defined SQL split column
- Train a LightGBM model
- Evaluate RMSE on train / valid during development

NOTE: Test evaluation is intentionally excluded here to preserve a final holdout set

Design Principles
-----------------
- No random splits in Python
- Split logic comes from SQL
- Config-driven
- Deterministic training
"""

import pandas as pd
import lightgbm as lgb
from google.cloud import bigquery
from sklearn.metrics import mean_squared_error
import numpy as np

import config

# ------------------------------------------------------------
# Load data from BigQuery
# ------------------------------------------------------------
def load_data_from_bigquery() -> pd.DataFrame:
    """
    Loads the final modeling view from BigQuery into a pandas DataFrame.
    """
    client = bigquery.Client(project=config.PROJECT_ID)

    query = f"""
        SELECT *
        FROM `{config.PROJECT_ID}.{config.DATASET}.{config.TABLE}`
    """

    df = client.query(query).to_dataframe()

    return df

# ------------------------------------------------------------
# RMSE
# ------------------------------------------------------------
def rmse(y_true, y_pred):
    return np.sqrt(mean_squared_error(y_true, y_pred))

# ------------------------------------------------------------
# Main training routine
# ------------------------------------------------------------
def main():

    print("Loading data from BigQuery...")
    df = load_data_from_bigquery()
    print(f"Loaded {len(df):,} rows")

    # -----------------------------------
    # Cast categorical columns properly
    # -----------------------------------
    for col in config.CATEGORICAL_FEATURES:
        df[col] = df[col].astype("category")

    feature_cols = config.NUMERIC_FEATURES + config.CATEGORICAL_FEATURES

    # -----------------------------------
    # Split datasets
    # -----------------------------------
    df_train = df[df[config.SPLIT_COL] == "train"]
    df_valid = df[df[config.SPLIT_COL] == "valid"]

    print(f"Train rows: {len(df_train):,}")
    print(f"Valid rows: {len(df_valid):,}")

    X_train = df_train[feature_cols]
    y_train = df_train[config.TARGET_COL]

    X_valid = df_valid[feature_cols]
    y_valid = df_valid[config.TARGET_COL]

    # -----------------------------------
    # Train LightGBM
    # -----------------------------------
    print("Training LightGBM model...")

    model = lgb.LGBMRegressor(**config.LGBM_PARAMS)

    model.fit(
        X_train,
        y_train,
        eval_set=[(X_valid, y_valid)],
        eval_metric="rmse",
        categorical_feature=config.CATEGORICAL_FEATURES,
    )

    # -----------------------------------
    # Evaluation
    # -----------------------------------
    print("\nEvaluating model...")

    train_rmse = rmse(y_train, model.predict(X_train))
    valid_rmse = rmse(y_valid, model.predict(X_valid))

    print(f"Train RMSE: {train_rmse:,.2f}")
    print(f"Valid RMSE: {valid_rmse:,.2f}")


if __name__ == "__main__":
    main()
