
-- PARTIE 9 : Requêtes Attendues




-- Q1 : Nombre total de trajets
SELECT COUNT(*) AS total_trajets
FROM taxi_clean1;

-- Q2 : Zones de pickup les plus fréquentées
SELECT pickup_zone, COUNT(*) AS nb
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY nb DESC LIMIT 10;

-- Q3 : Zones de dropoff les plus fréquentées
SELECT dropoff_zone, COUNT(*) AS nb
FROM taxi_clean1
GROUP BY dropoff_zone
ORDER BY nb DESC LIMIT 10;

-- Q4 : Distance moyenne par zone de départ
SELECT pickup_zone, ROUND(AVG(trip_distance),2) AS avg_dist
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY avg_dist DESC;

-- Q5 : Distance moyenne par zone d'arrivée
SELECT dropoff_zone, ROUND(AVG(trip_distance),2) AS avg_dist
FROM taxi_clean1
GROUP BY dropoff_zone
ORDER BY avg_dist DESC;

-- Q6 : Trajets les plus longs
SELECT pickup_zone, dropoff_zone, trip_distance, total_amount, pickup_time
FROM taxi_clean1
ORDER BY trip_distance DESC LIMIT 10;

-- Q7 : Montant moyen des trajets par zone
SELECT pickup_zone, ROUND(AVG(total_amount),2) AS avg_amount
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY avg_amount DESC;

-- Q8 : Heures de pointe par zone
SELECT pickup_zone, pickup_hour, COUNT(*) AS nb
FROM taxi_clean1
GROUP BY pickup_zone, pickup_hour
ORDER BY pickup_zone, nb DESC;

-- Q9 : Flux les plus fréquents entre zones
SELECT pickup_zone, dropoff_zone, COUNT(*) AS flux
FROM taxi_clean1
GROUP BY pickup_zone, dropoff_zone
ORDER BY flux DESC LIMIT 10;

-- Q10 : Comparaison zones très actives vs secondaires
SELECT pickup_zone, COUNT(*) AS nb,
    CASE
        WHEN COUNT(*) >= 50 THEN 'Zone Très Active'
        WHEN COUNT(*) >= 20 THEN 'Zone Active'
        ELSE 'Zone Secondaire'
    END AS zone_type
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY nb DESC;
