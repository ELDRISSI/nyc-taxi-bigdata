
-- PARTIE 11 : Lier Hive à HBase
-- Prérequis : table 'zone_stats' créée dans HBase




-- Supprimer si elle existe déjà
DROP TABLE IF EXISTS hbase_zone_stats;

-- Créer la table Hive liée à HBase
-- RowKey = zone_id (pickup_zone)
CREATE EXTERNAL TABLE hbase_zone_stats (
    zone_id           STRING,
    nb_trajets        BIGINT,
    distance_moyenne  DOUBLE,
    montant_moyen     DOUBLE,
    top_destinations  STRING,
    heure_pointe      INT
)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES (
    "hbase.columns.mapping" =
    ":key,info:nb_trajets,info:distance_moyenne,info:montant_moyen,info:top_destinations,info:heure_pointe"
)
TBLPROPERTIES ("hbase.table.name" = "zone_stats");


