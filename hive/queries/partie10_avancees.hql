-- ============================================================
-- PARTIE 10 : Requêtes Avancées
-- Projet    : NYC Yellow Taxi Big Data
-- Auteur    : elidrissi
-- ============================================================



-- Q1 : Jointure avec table de correspondance de zones

--D'abord,on cree la table de correspondance
DROP TABLE IF EXISTS zone_lookup;

CREATE EXTERNAL TABLE zone_lookup (
    LocationID    INT,
    Borough       STRING,
    Zone          STRING
    service_zone  STRING,
    
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hdfs/zone_lookup'
TBLPROPERTIES ("skip.header.line.count"="1");



SELECT
    t.pickup_zone,
    zp.Zone                        AS pickup_zone_name,
    zp.Borough                     AS pickup_borough,
    t.dropoff_zone,
    zd.Zone                        AS dropoff_zone_name,
    zd.Borough                     AS dropoff_borough,
    COUNT(*)                       AS nb_trips,
    ROUND(AVG(t.trip_distance),2)  AS avg_distance,
    ROUND(AVG(t.total_amount),2)   AS avg_amount
FROM taxi_clean1 t
JOIN zone_lookup zp ON CAST(t.pickup_zone  AS INT) = CAST(zp.LocationID AS INT)
JOIN zone_lookup zd ON CAST(t.dropoff_zone AS INT) = CAST(zd.LocationID AS INT)
GROUP BY t.pickup_zone, zp.Zone, zp.Borough, t.dropoff_zone, zd.Zone, zd.Borough
ORDER BY nb_trips DESC LIMIT 15;

-- Q2 : Agrégations imbriquées : top 3 flux entre zones
SELECT pickup_zone, dropoff_zone, flux, destination_rank
FROM (
    SELECT pickup_zone, dropoff_zone, COUNT(*) AS flux,
        RANK() OVER (
            PARTITION BY pickup_zone
            ORDER BY COUNT(*) DESC
        ) AS destination_rank
    FROM taxi_clean1
    GROUP BY pickup_zone, dropoff_zone
) ranked
WHERE destination_rank <= 3
ORDER BY pickup_zone, destination_rank;

-- Q3 : Filtrage avancé : trajets très courts, très longs ou à fort montant
SELECT pickup_zone, dropoff_zone, trip_distance, total_amount, pickup_time,
    CASE
        WHEN trip_distance < 0.5  THEN 'Très Court'
        WHEN trip_distance > 20   THEN 'Très Long'
        WHEN total_amount  > 100  THEN 'Fort Montant'
    END AS trip_type
FROM taxi_clean1
WHERE trip_distance < 0.5
   OR trip_distance > 20
   OR total_amount  > 100
ORDER BY total_amount DESC;

-- Q4 : Comparaison entre volume, distance et recette moyenne
SELECT
    pickup_zone,
    COUNT(*)                                                          AS volume,
    ROUND(AVG(trip_distance),2)                                       AS avg_distance,
    ROUND(AVG(total_amount),2)                                        AS avg_revenue,
    ROUND(SUM(total_amount),2)                                        AS total_revenue,
    ROUND(AVG(total_amount) / NULLIF(AVG(trip_distance),0),2)        AS revenue_per_mile,
    CASE
        WHEN COUNT(*) > 40 AND AVG(total_amount) > 20  THEN 'Fort Volume - Fort Revenu'
        WHEN COUNT(*) > 40 AND AVG(total_amount) <= 20 THEN 'Fort Volume - Faible Revenu'
        WHEN COUNT(*) <= 40 AND AVG(total_amount) > 20 THEN 'Faible Volume - Fort Revenu'
        ELSE 'Faible Volume - Faible Revenu'
    END AS zone_profile
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY volume DESC LIMIT 20;

-- Q5 : Analyse croisée entre spatial et temporel
SELECT
    pickup_zone,
    pickup_hour,
    COUNT(*)                        AS nb_trips,
    ROUND(AVG(total_amount),2)      AS avg_revenue,
    ROUND(AVG(trip_distance),2)     AS avg_distance,
    ROUND(SUM(total_amount),2)      AS total_revenue
FROM taxi_clean1
GROUP BY pickup_zone, pickup_hour
ORDER BY nb_trips DESC LIMIT 30;
