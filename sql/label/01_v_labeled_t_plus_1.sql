-- ============================================================
-- Label Layer: Next-Day Sales (t+1)
--
-- Purpose:
--   Create the supervised learning target:
--     sales_t_plus_1 = sales on the next calendar day for the same store.
--
-- Notes:
--   - This view does NOT decide train/valid/test membership.
--   - Split logic will later ensure labels do not cross boundaries.
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_labeled_t_plus_1` AS
WITH labeled AS (
  SELECT
    b.*,
    LEAD(b.sales) OVER (PARTITION BY b.store_id ORDER BY b.date) AS sales_t_plus_1
  FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_base_joined` b
)
SELECT
  l.*,
  DATE_ADD(l.date, INTERVAL 1 DAY) AS label_date
FROM labeled l
WHERE l.sales_t_plus_1 IS NOT NULL;
