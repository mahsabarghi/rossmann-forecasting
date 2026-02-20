-- ============================================================
-- Rossmann Forecasting Project
-- Dataset Initialization Script
--
-- IMPORTANT:
-- Replace `mahsa-rossmann-forecasting` with your own GCP project ID.
--
-- Purpose:
--   Create required BigQuery datasets for the project.
--
-- Datasets:
--   1. rossmann_raw        -> stores raw uploaded Kaggle tables
--   2. rossmann_analytics  -> stores all transformation views
--
-- Notes:
--   - Both datasets must be created in the same location.
--   - Location is set to 'US' (adjust if needed).
--   - All future tables and views must use the same region.
--   - Safe to re-run due to IF NOT EXISTS.
-- ============================================================


-- Create dataset for raw source tables
CREATE SCHEMA IF NOT EXISTS `mahsa-rossmann-forecasting.rossmann_raw`
OPTIONS(location='US');

-- Create dataset for analytics views (clean, join, label, features, splits)
CREATE SCHEMA IF NOT EXISTS `mahsa-rossmann-forecasting.rossmann_analytics`
OPTIONS(location='US');
