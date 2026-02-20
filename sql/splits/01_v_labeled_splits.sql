-- ============================================================
-- Splits Layer: Strict Time-Based Assignment
--
-- Purpose:
--   Assign each labeled row to train / valid / test
--   while preventing boundary leakage for t+1 labels.
--
-- Leakage Prevention Rule:
--   A row with feature date = d uses label at d+1.
--   Therefore:
--
--   Train:  d <= train_end - 1
--   Valid:  train_end <= d <= valid_end - 1
--   Test:   valid_end <= d <= test_end - 1
--
--   This guarantees labels never cross split boundaries.
--
-- Output View:
--   mahsa-rossmann-forecasting.rossmann_analytics.v_labeled_splits
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_labeled_splits` AS

WITH cutoffs AS (
  SELECT * FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_split_cutoffs`
),

labeled AS (
  SELECT * FROM `mahsa-rossmann-forecasting.rossmann_analytics.v_labeled_t_plus_1`
)

SELECT
  l.*,

  CASE
    WHEN l.date <= DATE_SUB(c.train_end, INTERVAL 1 DAY)
      THEN 'train'

    WHEN l.date > DATE_SUB(c.train_end, INTERVAL 1 DAY)
         AND l.date <= DATE_SUB(c.valid_end, INTERVAL 1 DAY)
      THEN 'valid'

    WHEN l.date > DATE_SUB(c.valid_end, INTERVAL 1 DAY)
         AND l.date <= DATE_SUB(c.test_end, INTERVAL 1 DAY)
      THEN 'test'

    ELSE NULL
  END AS split

FROM labeled l
CROSS JOIN cutoffs c
WHERE
  l.date >= c.start_date
  AND l.date <= DATE_SUB(c.test_end, INTERVAL 1 DAY);
