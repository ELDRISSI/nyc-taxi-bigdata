

## Dataset
NYC TLC Yellow Taxi Trips - 1000 lignes utilisees !!
(la dataset presente ci-dessous contient plus 3 million ligne)
Source : https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

## Stack Technique
- MySQL      :source des données brutes
- Sqoop      : import MySQL vers HDFS
- HDFS       : stockage distribué
- Hive       : requêtes SQL sur HDFS
- HBase      : indexation rapide par zone

## Structure du projet
```
nyc-taxi-bigdata/
├── sqoop/                        scripts d'import MySQL vers HDFS
├── hive/                         création des tables
│   └── queries/                  toutes les requêtes HQL
├── hbase/                        configuration HBase
├── data/                         échantillon (.parquet)

```

## Ordre d'exécution

### 1. Import MySQL → HDFS
```bash
bash sqoop/import_yellow_taxi.sh
bash sqoop/import_zone_lookup.sh
```

### 2. Création des tables Hive
```bash
hive -f hive/01_create_database.hql
hive -f hive/02_create_external_table.hql
hive -f hive/03_create_clean_table.hql
hive -f hive/04_create_view.hql
hive -f hive/05_create_zone_lookup.hql
```

### 3. Requêtes
```bash
hive -f hive/queries/partie9_requetes.hql
hive -f hive/queries/partie10_avancees.hql
hive -f hive/queries/partie12_analyse.hql
```

### 4. HBase
```bash
hbase shell < hbase/create_table.hbase
hive -f hbase/hive_hbase_link.hql
hive -f hbase/insert_hbase.hql
```
