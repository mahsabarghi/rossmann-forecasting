-- ============================================================
-- Splits Layer: Split Cutoffs
--
-- Purpose:
--   Define strict time-based train/valid/test boundaries in one place.
--   Other split views reference these cutoffs.
--
-- Leakage rule for t+1 labeling:
--   A row with feature date = d uses label from d+1.
--   Therefore each split must satisfy that label_date stays inside the split.
--
-- Recommended cutoffs:
--   TRAIN_END = 2014-12-31  (train uses dates <= 2014-12-30)
--   VALID_END = 2015-05-31  (valid uses dates <= 2015-05-30)
--   TEST_END  = 2015-07-30  (test uses dates <= 2015-07-29)
-- ============================================================

CREATE OR REPLACE VIEW `mahsa-rossmann-forecasting.rossmann_analytics.v_split_cutoffs` AS
SELECT
  DATE('2013-01-01') AS start_date,
  DATE('2014-12-31') AS train_end,
  DATE('2015-05-31') AS valid_end,
  DATE('2015-07-30') AS test_end;
