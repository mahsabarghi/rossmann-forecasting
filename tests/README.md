# Tests

This folder contains unit tests that enforce correctness and reproducibility of the forecasting pipeline.

## What we test

- **Configuration loading**  
  YAML configs are parsed and validated (required fields, types, defaults).

- **Time-based splitting rules**  
  Train/valid/test splits are strictly chronological and deterministic.

- **Leakage prevention**  
  Ensures labels and features do not use information from the future (e.g., target `t+1` must not appear in features at time `t`).

- **Smoke training**  
  A lightweight end-to-end training run executes on `data/samples/` to verify the pipeline works in CI without cloud access.

## CI Policy

GitHub Actions runs tests and smoke training using only local sample data to remain fast and deterministic.
