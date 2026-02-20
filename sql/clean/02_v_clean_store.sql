-- ============================================================
-- Clean Layer: Store (raw -> standardized view)
--
-- Purpose:
--   Provide a cleaned and standardized view over the raw store table.
--   - Standardize column names (lower_snake_case)
--   - Preserve nullable fields (competition/promo2 metadata)
--
-- Output View:
--   mahsa-rossmann-forecasting.rossmann_analytics.v_clean_store
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_clean_store` AS
SELECT
  CAST(Store AS INT64)                       AS store_id,
  CAST(StoreType AS STRING)                  AS store_type,
  CAST(Assortment AS STRING)                 AS assortment,
  CAST(CompetitionDistance AS FLOAT64)       AS competition_distance,
  CAST(CompetitionOpenSinceMonth AS INT64)   AS competition_open_since_month,
  CAST(CompetitionOpenSinceYear AS INT64)    AS competition_open_since_year,
  CAST(Promo2 AS INT64)                      AS promo2,
  CAST(Promo2SinceWeek AS INT64)             AS promo2_since_week,
  CAST(Promo2SinceYear AS INT64)             AS promo2_since_year,
  CAST(PromoInterval AS STRING)              AS promo_interval
FROM `mahsa-rossmann-forecasting.rossmann_raw.store`;
