-- ============================================================
-- Feature Layer: Model-Ready Dataset
--
-- Purpose:
--   Prepare final dataset for model training.
--
-- Design Decisions:
--   - Drop rows with NULL structural lag features.
--   - These occur only at the beginning of each store's time series.
--   - Validation and test rows remain unaffected.
--
-- Rationale:
--   Structural lags (e.g., sales_lag_7) must exist to ensure
--   stable feature definitions and avoid injecting artificial values.
--
-- Output View:
--   mahsa-rossmann-forecasting.rossmann_analytics.v_features_model_ready
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_features_model_ready` AS

SELECT *
FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_features_basic`
WHERE
    -- Require at least 7 days of history
    sales_lag_7 IS NOT NULL;
