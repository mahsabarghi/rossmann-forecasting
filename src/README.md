# Application Layer (Python)

This folder contains the Python code responsible for:

- Reading prepared datasets from BigQuery
- Loading configuration files
- Training a single global forecasting model
- Evaluating model performance
- Running lightweight smoke training jobs (used in CI)

## Design Principles

- **No feature engineering in Python**  
  All data cleaning, joins, labeling, and feature creation are handled in the SQL layer.

- **Config-driven training**  
  Model parameters, split cutoffs, and runtime options are controlled via YAML configuration files.

- **Single global model**  
  One model is trained across all stores, rather than one model per store.

- **Reproducibility**  
  Given the same config and dataset view, training is deterministic.

## Entry Points

Typical execution patterns:

- Full training run (BigQuery-backed)
- Smoke training run (CI, using small local samples)
