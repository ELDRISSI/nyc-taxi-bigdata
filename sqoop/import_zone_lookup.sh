#!/bin/bash

# Importer : la table "taxi_zone_lookup" (table de correspondance id_zone=zone_name) depuis  MySQL vers HDFS


sqoop import \
  --connect jdbc:mysql://localhost:3306/NYC_TAXIS \
  --username elidrissi \
  -P \
  --table taxi_zone_lookup \
  --target-dir /user/hdfs/zone_lookup \
  --fields-terminated-by ',' \
  --null-string '\\N' \
  --null-non-string '\\N' \
  --num-mappers 1 \
  --delete-target-dir


