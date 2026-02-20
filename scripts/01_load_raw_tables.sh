#!/bin/bash

# ============================================================
# Rossmann Forecasting Project
# Raw Table Loading Script
#
# Purpose:
#   Load Kaggle CSV files into BigQuery raw dataset
#   using explicit schema definitions.
#
# Requirements:
#   - GCP project must be set via `gcloud config set project`
#   - BigQuery API must be enabled
#   - Datasets must already exist
#
# Usage:
#   bash scripts/01_load_raw_tables.sh
# ============================================================


PROJECT_ID="mahsa-rossmann-forecasting"
DATASET="rossmann_raw"


echo "Loading train.csv into BigQuery..."

bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  ${PROJECT_ID}:${DATASET}.train \
  data/raw/train.csv \
  sql/admin/schemas/train_schema.json


echo "Loading store.csv into BigQuery..."

bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  ${PROJECT_ID}:${DATASET}.store \
  data/raw/store.csv \
  sql/admin/schemas/store_schema.json


echo "Raw tables loaded successfully."
