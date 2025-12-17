import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import psycopg2.sql as sql
#import os

# 1. Recuperación SEGURA de variables de entorno
# Usa el nombre de la variable (DB_USER, DB_PASS, etc.) en el diccionario de conexión.
# DB_USER = os.environ.get('POSTGRES_USER', 'miusuario') 
# DB_PASS = os.environ.get('POSTGRES_PASS') 
# DB_HOST = os.environ.get('POSTGRES_HOST', 'localhost')
# DB_PORT = os.environ.get('POSTGRES_PORT', '5432')

# 2. Datos de conexión (apuntando a la base de datos del sistema 'postgres')
db_params = {
    # Usamos las VARIABLES que contienen los valores recuperados
    'user': 'miusuario',
    'password': 12345,
    'host': 'postgres', 
    'port': 5432,
    'dbname': 'postgres' # Conéctate a 'postgres' para crear otras bases de datos
}

nombre_nueva_db = "logistics_db"

try:
    # 1. Establecer conexión
    conn = psycopg2.connect(**db_params)
    
    # 2. Configurar autocommit
    # "CREATE DATABASE" no puede ejecutarse dentro de una transacción normal,
    # por eso necesitamos activar el autocommit.
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    
    cursor = conn.cursor()
    
    # 3. Crear la base de datos
    # Primero verificamos si ya existe para evitar errores
    cursor.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = %s",((nombre_nueva_db),))
    exists = cursor.fetchone()
    
    if not exists:
        # Uso de sql.Identifier para insertar de forma segura un identificador (nombre de BD)
        cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(nombre_nueva_db)))
        print(f" Base de datos '{nombre_nueva_db}' creada exitosamente.")
    else:
        print(f"ℹ La base de datos '{nombre_nueva_db}' ya existe.")

except Exception as e:
    print(f" Error: {e}")

finally:
    if 'cursor' in locals(): cursor.close()
    if 'conn' in locals(): conn.close()