#!/bin/bash
# ============================================================
# Importer le fihier "yellow_taxi_trips"  depuis MySQL vers HDFS


sqoop import \
  --connect jdbc:mysql://localhost:3306/NYC_TAXIS \
  --username elidrissi \
  -P \
  --table yellow_taxi_trips \
  --target-dir /user/hdfs/yellow_taxi_trips3 \
  --fields-terminated-by ',' \
  --null-string '\\N' \
  --null-non-string '\\N' \
  --num-mappers 1 \
  --delete-target-dir


