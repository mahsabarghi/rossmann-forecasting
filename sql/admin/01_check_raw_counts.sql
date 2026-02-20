-- ============================================================
-- Raw Data Sanity Checks
--
-- Purpose:
--   Verify raw tables exist and have expected row counts.
--   This is a quick validation after `bq load`.
-- ============================================================

SELECT 'train' AS table_name, COUNT(*) AS row_count
FROM `mahsa-rossmann-forecasting.rossmann_raw.train`
UNION ALL
SELECT 'store' AS table_name, COUNT(*) AS row_count
FROM `mahsa-rossmann-forecasting.rossmann_raw.store`;
