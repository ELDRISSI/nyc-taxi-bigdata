
-- ETAPE 2 : Création de la table externe 


USE taxi_project;

CREATE EXTERNAL TABLE IF NOT EXISTS yellow_taxi_trips (
    VendorID              INT,
    tpep_pickup_datetime  STRING,
    tpep_dropoff_datetime STRING,
    passenger_count       INT,
    trip_distance         DOUBLE,
    RatecodeID            INT,
    store_and_fwd_flag    STRING,
    PULocationID          INT,
    DOLocationID          INT,
    payment_type          INT,
    fare_amount           DOUBLE,
    extra                 DOUBLE,
    mta_tax               DOUBLE,
    tip_amount            DOUBLE,
    tolls_amount          DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount          DOUBLE,
    congestion_surcharge  DOUBLE,
    Airport_fee           DOUBLE,
    cbd_congestion_fee    DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hdfs/yellow_taxi_trips3'
TBLPROPERTIES ("skip.header.line.count"="1");


