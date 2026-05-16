
# Script : Transfert Parquet vers MySQL

# intaller  les biblio requises : 
#pip install pandas sqlalchemy pymysql pyarrow

#remplacer la variable chunksize par le nombre de lignes que vous voulez importer
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# --- CONFIG ---
MYSQL_USER     = "user"
password       = "password"
MYSQL_PASSWORD = quote_plus(password)
MYSQL_HOST     = "localhost"
MYSQL_PORT     = 3306
MYSQL_DB       = "NYC_TAXIS"
TABLE_NAME     = "yellow_taxi_trips"
PARQUET_FILE   = "chemin/vers/fichier.parquet"
NB_ROWS        = 1000

# --- LOAD PARQUET ---
print("Chargement du fichier parquet...")
df = pd.read_parquet(PARQUET_FILE)
df = df.head(NB_ROWS)
print(f"Lignes chargées : {len(df):,}")
print(f"Colonnes : {list(df.columns)}")

# --- CONNECT TO MYSQL ---
print("Connexion à MySQL...")
engine = create_engine(
    f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}"
)

# --- TRANSFER TO MYSQL ---
print(f"Transfert vers la table '{TABLE_NAME}'...")
df.to_sql(
    name      = TABLE_NAME,
    con       = engine,
    if_exists = "replace",   # replace = recrée la table si elle existe
    index     = False,
    chunksize = 1000
)

print(f"Terminé ! {NB_ROWS} lignes insérées dans {MYSQL_DB}.{TABLE_NAME}")
