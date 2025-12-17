import pandas as pd
from sqlalchemy import create_engine


# CONFIGURACIÓN
excel_file = "/workspaces/Data-Logistics-Analytics-Pipeline/Data/logisticData.xlsx"    # Ruta del Excel
db_user = "miusuario"
db_pass = "12345"
db_host = "postgres"
db_port = "5432"
db_name = "logistics_db"          # base ya creada

# Crear conexión con SQLAlchemy
engine_str = f"postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"
engine = create_engine(engine_str)


# LEER TODAS LAS HOJAS DEL EXCEL
xls = pd.ExcelFile(excel_file)  
hojas = xls.sheet_names

print(f" Hojas detectadas: {hojas}")

for hoja in hojas:
    print(f"\n Procesando hoja: {hoja}...")

    # Leer la hoja actual
    df = pd.read_excel(excel_file, sheet_name=hoja)

    # Normalizar nombre de tabla (sin espacios)
    nombre_tabla = hoja.strip().replace(" ", "_").lower()

    # Insertar en PostgreSQL
    df.to_sql(
        nombre_tabla,
        engine,
        if_exists='replace',    # opciones: 'replace', 'append', 'fail'
        index=False
    )

    print(f" Tabla '{nombre_tabla}' creada y datos insertados.")

print("\n Migración completada.")
