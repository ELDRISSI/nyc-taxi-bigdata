
-- PARTIE 12 : Analyse et Interprétation

-- Q1 : Identifier les zones critiques de mobilité
SELECT
    pickup_zone,
    COUNT(*)                        AS nb_trips,
    ROUND(AVG(trip_distance),2)     AS avg_distance,
    ROUND(AVG(total_amount),2)      AS avg_amount,
    ROUND(SUM(total_amount),2)      AS total_revenue
FROM taxi_clean1
GROUP BY pickup_zone
HAVING COUNT(*) > 20
ORDER BY nb_trips DESC LIMIT 15;

-- Q2 : Comparer zones de forte densité et zones périphériques
SELECT
    pickup_zone,
    COUNT(*)                        AS nb_trips,
    ROUND(AVG(trip_distance),2)     AS avg_distance,
    CASE
        WHEN COUNT(*) >= 40 AND AVG(trip_distance) < 5  THEN 'Zone Dense Urbaine'
        WHEN COUNT(*) >= 40 AND AVG(trip_distance) >= 5 THEN 'Zone Active Long-Courrier'
        WHEN COUNT(*) < 40  AND AVG(trip_distance) >= 8 THEN 'Zone Périphérique'
        ELSE 'Zone Mixte'
    END AS zone_type
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY nb_trips DESC;

-- Q3 : Discuter les liens entre flux, distance et activité urbaine
SELECT
    pickup_zone,
    COUNT(*)                                                          AS flux,
    ROUND(AVG(trip_distance),2)                                       AS avg_distance,
    ROUND(AVG(total_amount),2)                                        AS avg_revenue,
    ROUND(SUM(total_amount),2)                                        AS total_revenue,
    ROUND(AVG(total_amount) / NULLIF(AVG(trip_distance),0),2)        AS revenue_per_mile
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY flux DESC LIMIT 20;

-- Q4 : Mettre en évidence les zones stratégiques
SELECT
    pickup_zone,
    COUNT(*)                        AS nb_trips,
    COUNT(DISTINCT dropoff_zone)    AS nb_destinations,
    ROUND(SUM(total_amount),2)      AS total_revenue,
    ROUND(AVG(total_amount),2)      AS avg_amount,
    CASE
        WHEN COUNT(*) > 40
         AND COUNT(DISTINCT dropoff_zone) > 15
         AND AVG(total_amount) > 20  THEN 'Zone Strategique Majeure'
        WHEN COUNT(*) > 20
         AND COUNT(DISTINCT dropoff_zone) > 10 THEN 'Zone Strategique Secondaire'
        ELSE 'Zone Ordinaire'
    END AS strategic_level
FROM taxi_clean1
GROUP BY pickup_zone
ORDER BY nb_trips DESC LIMIT 20;
