"""
Rossmann Forecasting Project
Raw Data Profiling Script

Purpose
-------
This script performs a basic exploratory data profiling step
on the original Kaggle CSV files before loading them into BigQuery.

Why this matters
----------------
- Schema decisions (REQUIRED vs NULLABLE) should be evidence-based.
- We want to understand missingness before defining table schema.
- This step documents data assumptions explicitly.

Outputs
-------
- Prints missing value statistics to console.
- Saves profiling results into `data/extracts/` (ignored by git).

Note
----
This script is for local analysis only.
It is NOT part of the production training pipeline.
"""

from pathlib import Path
import pandas as pd


# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

# Path to locally stored raw Kaggle files (ignored by git)
RAW_DATA_DIR = Path("data/raw")

# Output directory for profiling artifacts (ignored by git)
EXTRACTS_DIR = Path("data/extracts")


# ------------------------------------------------------------
# Profiling function
# ------------------------------------------------------------

def profile_csv(path: Path, parse_dates=None) -> pd.DataFrame:
    """
    Profiles a CSV file and computes basic statistics per column.

    Parameters
    ----------
    path : Path
        Path to the CSV file.
    parse_dates : list or None
        Optional list of column names to parse as dates.

    Returns
    -------
    pd.DataFrame
        DataFrame containing:
        - column name
        - inferred pandas dtype
        - number of null values
        - percentage of null values
        - number of unique values
    """

    # Load CSV into pandas
    df = pd.read_csv(path, parse_dates=parse_dates)

    total_rows = len(df)
    results = []

    # Iterate over each column and compute statistics
    for column in df.columns:
        null_count = int(df[column].isna().sum())
        unique_count = int(df[column].nunique(dropna=True))

        results.append({
            "column": column,
            "dtype": str(df[column].dtype),
            "null_count": null_count,
            "null_pct": round((null_count / total_rows) * 100, 2),
            "n_unique": unique_count
        })

    # Sort by highest missing percentage first
    return pd.DataFrame(results).sort_values(
        by="null_pct",
        ascending=False
    )


# ------------------------------------------------------------
# Main execution
# ------------------------------------------------------------

def main():
    """
    Profiles both train.csv and store.csv
    and saves profiling results locally.
    """

    # Ensure output directory exists
    EXTRACTS_DIR.mkdir(parents=True, exist_ok=True)

    # Profile train dataset
    train_profile = profile_csv(
        RAW_DATA_DIR / "train.csv",
        parse_dates=["Date"]  # Ensure Date column is parsed correctly
    )

    # Profile store dataset
    store_profile = profile_csv(
        RAW_DATA_DIR / "store.csv"
    )

    # Print results to console
    print("\n========== TRAIN DATA PROFILING ==========")
    print(train_profile.to_string(index=False))

    print("\n========== STORE DATA PROFILING ==========")
    print(store_profile.to_string(index=False))

    # Save results for reference (ignored by git)
    train_profile.to_csv(EXTRACTS_DIR / "train_profile.csv", index=False)
    store_profile.to_csv(EXTRACTS_DIR / "store_profile.csv", index=False)

    print("\nProfiling results saved to data/extracts/ (ignored by git).")


if __name__ == "__main__":
    main()
