
-- ETAPE 3 : Création de la table nettoyée (ORC)






CREATE TABLE IF NOT EXISTS taxi_clean1
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY")
AS
SELECT
    VendorID,
    CAST(tpep_pickup_datetime  AS TIMESTAMP)  AS pickup_time,
    CAST(tpep_dropoff_datetime AS TIMESTAMP)  AS dropoff_time,
    passenger_count,
    trip_distance,
    PULocationID                              AS pickup_zone,
    DOLocationID                              AS dropoff_zone,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount,
    HOUR(tpep_pickup_datetime)                AS pickup_hour,
    DAYOFWEEK(tpep_pickup_datetime)           AS pickup_day
FROM yellow_taxi_trips
WHERE trip_distance   > 0
  AND fare_amount     > 0
  AND passenger_count > 0
  AND total_amount    > 0;


