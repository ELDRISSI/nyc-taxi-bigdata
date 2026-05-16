
-- PARTIE 11 : Remplir HBase depuis taxi_clean1
-- Prérequis : hive_hbase_link.hql exécuté avec succès




INSERT OVERWRITE TABLE hbase_zone_stats
SELECT
    CAST(t.pickup_zone AS STRING)          AS zone_id,

    COUNT(*)                               AS nb_trajets,

    ROUND(AVG(t.trip_distance), 2)         AS distance_moyenne,

    ROUND(AVG(t.total_amount), 2)          AS montant_moyen,

    -- Top destination : zone de dropoff la plus fréquente
    (
        SELECT CAST(d.dropoff_zone AS STRING)
        FROM taxi_clean1 d
        WHERE d.pickup_zone = t.pickup_zone
        GROUP BY d.dropoff_zone
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS top_destinations,

    -- Heure de pointe : heure avec le plus de départs
    (
        SELECT h.pickup_hour
        FROM taxi_clean1 h
        WHERE h.pickup_zone = t.pickup_zone
        GROUP BY h.pickup_hour
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS heure_pointe

FROM taxi_clean1 t
GROUP BY t.pickup_zone;

