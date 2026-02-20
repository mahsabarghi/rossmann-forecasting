-- ============================================================
-- Join Layer: Base Modeling Dataset
--
-- Purpose:
--   Join cleaned train and store datasets into a single
--   canonical base view for modeling.
--
-- Design Principles:
--   - One row per (store_id, date)
--   - No feature engineering yet
--   - No label shifting yet
--   - Raw tables remain untouched
--
-- Output View:
--   mahsa-rossmann-forecasting.rossmann_analytics.v_base_joined
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_base_joined` AS

SELECT
    t.store_id,
    t.date,
    t.day_of_week,
    t.sales,
    t.customers,
    t.is_open,
    t.promo,
    t.state_holiday,
    t.school_holiday,

    -- Store metadata
    s.store_type,
    s.assortment,
    s.competition_distance,
    s.competition_open_since_month,
    s.competition_open_since_year,
    s.promo2,
    s.promo2_since_week,
    s.promo2_since_year,
    s.promo_interval

FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_clean_train` t
LEFT JOIN `mahsa-rossmann-forecasting.rossmann_analytics.v_clean_store` s
    ON t.store_id = s.store_id;
