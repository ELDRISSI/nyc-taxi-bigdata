# Script : Transfert zone_lookup CSV vers MySQL

import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

# --- CONFIG ---
MYSQL_USER = "user"
MYSQL_PASSWORD = quote_plus("password")
MYSQL_HOST = "localhost"
MYSQL_PORT = 3306
MYSQL_DB = "nom_base_de_donnees"

# --- LOAD CSV directly from URL ---
url = "/chemin/taxi_zone_lookup.csv"
zones = pd.read_csv(url)

print(zones.head())
print(zones.shape)  # should be ~265 rows, 4 columns

# --- CONNECT TO MYSQL ---
engine = create_engine(f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}")

# --- IMPORT TO MYSQL ---
zones.to_sql(
    name="taxi_zone_lookup",
    con=engine,
    if_exists="replace",
    index=False
)

print("Done!")
