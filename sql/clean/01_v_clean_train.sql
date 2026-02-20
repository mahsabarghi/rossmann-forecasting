-- ============================================================
-- Clean Layer: Train (raw -> standardized view)
--
-- Purpose:
--   Provide a cleaned and standardized view over the raw train table.
--   - Standardize column names (lower_snake_case)
--   - Ensure consistent typing
--   - Keep raw data immutable (views only)
--
-- Output View:
--   mahsa-rossmann-forecasting.rossmann_analytics.v_clean_train
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_clean_train` AS
SELECT
  CAST(Store AS INT64)         AS store_id,
  CAST(DayOfWeek AS INT64)     AS day_of_week,
  CAST(Date AS DATE)           AS date,
  CAST(Sales AS INT64)         AS sales,
  CAST(Customers AS INT64)     AS customers,
  CAST(Open AS INT64)          AS is_open,
  CAST(Promo AS INT64)         AS promo,
  -- StateHoliday is categorical (e.g., '0','a','b','c'); enforce string.
  CAST(StateHoliday AS STRING) AS state_holiday,
  CAST(SchoolHoliday AS INT64) AS school_holiday
FROM `mahsa-rossmann-forecasting.rossmann_raw.train`;
