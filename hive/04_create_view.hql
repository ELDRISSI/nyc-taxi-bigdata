
-- ETAPE 4 : Création de la vue zone_summary





CREATE VIEW IF NOT EXISTS zone_summary1 AS
SELECT
    pickup_zone,
    COUNT(*)                        AS nb_trips,
    ROUND(AVG(trip_distance), 2)    AS avg_distance,
    ROUND(AVG(total_amount), 2)     AS avg_amount,
    ROUND(SUM(total_amount), 2)     AS total_revenue
FROM taxi_clean1
GROUP BY pickup_zone;


