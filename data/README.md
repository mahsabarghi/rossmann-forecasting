# Data Directory

This directory contains **only lightweight, version-controlled samples** used for tests and CI.

## Structure

- `raw/` – Local copies of the original Kaggle CSV files (**ignored by git**)
- `samples/` – Small deterministic samples used for unit tests and CI smoke runs (**committed**)
- `extracts/` – Optional BigQuery exports for local debugging (**ignored by git**)

## Source of Truth

For real training runs, data is sourced from **BigQuery**:

1. Raw Kaggle CSVs are uploaded to BigQuery tables.
2. All cleaning, joins, labels, features, and time splits are implemented as BigQuery views.
3. Python training code reads only the final dataset views.

## CI Policy

GitHub Actions does **not** depend on cloud access.

CI runs on `data/samples/` to ensure fast, deterministic tests and a lightweight smoke training job.
