-- ============================================================
-- Feature Layer: Basic Time-Series Features
--
-- Purpose:
--   Create leakage-safe features for forecasting sales_t_plus_1.
--
-- Design Rules:
--   - Only backward-looking windows
--   - No FOLLOWING rows
--   - Features computable at time d
--
-- Input:
--   v_labeled_splits
--
-- Output:
--   v_features_basic
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_features_basic` AS

WITH base AS (
  SELECT *
  FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_labeled_splits`
)

SELECT
  b.*,

  -- =========================
  -- Calendar Features
  -- =========================
  EXTRACT(YEAR FROM b.date)  AS year,
  EXTRACT(MONTH FROM b.date) AS month,
  EXTRACT(DAY FROM b.date)   AS day_of_month,
  EXTRACT(WEEK FROM b.date)  AS week_of_year,

  -- =========================
  -- Lag Features
  -- =========================
  LAG(b.sales, 1) OVER (
      PARTITION BY b.store_id
      ORDER BY b.date
  ) AS sales_lag_1,

  LAG(b.sales, 7) OVER (
      PARTITION BY b.store_id
      ORDER BY b.date
  ) AS sales_lag_7,

  -- =========================
  -- Rolling Mean (7-day)
  -- Safe window: no future rows
  -- =========================
  AVG(b.sales) OVER (
      PARTITION BY b.store_id
      ORDER BY b.date
      ROWS BETWEEN 7 PRECEDING AND CURRENT ROW
  ) AS sales_rollmean_7

FROM base b;
