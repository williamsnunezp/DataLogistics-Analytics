-- CONSULTAS

--
WITH Promedios AS (
    -- Calcula el promedio global de remesas
    SELECT AVG("CANTIDAD_REMESAS_VIAJE") AS Avg_Global_Remesas
    FROM entregas)
SELECT
    p."COD_PRODUCTO",
    p."PRODUCTO",
    ROUND(AVG(e."CANTIDAD_REMESAS_VIAJE")::numeric, 2) AS Promedio_Remesas_Producto,
    pr.Avg_Global_Remesas
FROM entregas e
JOIN productos p ON e."COD_PRODUCTO" = p."COD_PRODUCTO"
JOIN sucursales s ON e."COD_SUCURSAL" = s."COD_SUCURSAL"
CROSS JOIN Promedios pr
WHERE s."CIUDAD_DEPART" = 'BOGOTA BOGOTA D.C.'
GROUP BY
    p."COD_PRODUCTO",
    p."PRODUCTO",
    pr.Avg_Global_Remesas
HAVING AVG(e."CANTIDAD_REMESAS_VIAJE") < pr.Avg_Global_Remesas -- Muestra los productos que se consolidan menos que el promedio
ORDER BY Promedio_Remesas_Producto DESC;
--

--
SELECT
    s."CIUDAD_DEPART" AS Sucursal,
    cd."CIUDAD_DEPART" AS Destino,
    ROUND(AVG(e."HORAS_VIAJE")::numeric, 2) AS Promedio_Viaje_Hrs,
    ROUND(AVG(e."HORAS_ESPERA_DESCARGUE" + e."HORAS_DESCARGUE")::numeric, 2) AS Promedio_Manejo_Destino_Hrs,
    COUNT(e."COD_ENTREGA") AS Total_Entregas
FROM entregas e
JOIN ciudad_destino cd ON e."COD_DESCARGUE" = cd."COD_DESCARGUE"
JOIN sucursales s ON e."COD_SUCURSAL" = s."COD_SUCURSAL"
WHERE s."CIUDAD_DEPART" = 'BOGOTA BOGOTA D.C.'
GROUP BY 
    cd."CIUDAD_DEPART",
    s."CIUDAD_DEPART"
ORDER BY Promedio_Viaje_Hrs DESC;
--

--
SELECT 
    e."NATURALEZA",
    ROUND(AVG(e."VALOR_PAGADO")::NUMERIC / 
    AVG(e."HORAS_VIAJE"+ e."HORAS_ESPERA_CARGUE"+ e."HORAS_ESPERA_DESCARGUE" + e."HORAS_CARGUE" +e."HORAS_DESCARGUE")::NUMERIC
    , 2)
    AS Rentabilidad_por_hora_PESOS
FROM entregas e
WHERE (e."HORAS_VIAJE"+ e."HORAS_ESPERA_CARGUE"+ e."HORAS_ESPERA_DESCARGUE" + e."HORAS_CARGUE" +e."HORAS_DESCARGUE") > 0
GROUP BY e."NATURALEZA"
ORDER BY Rentabilidad_por_hora_PESOS DESC;
--

--  
SELECT 
    e."NATURALEZA",
    pr."UNID_MEDIDA",
    COUNT(e."NATURALEZA") AS Frecuencia_de_entrega,
    ROUND(AVG(e."HORAS_VIAJE")::NUMERIC, 2) AS  Promedio_horas_viaje,
    ROUND(AVG(e."CANTIDAD")::NUMERIC, 2) AS Cantidad_promedio,
    ROUND((SUM(e."VALOR_PAGADO") / COUNT(e."NATURALEZA"))::NUMERIC,2) AS Promedio_pagado_por_naturaleza,
    ROUND(SUM(e."VALOR_PAGADO")::NUMERIC, 2) AS Total_valor_pagado
FROM entregas e 
JOIN sucursales s ON e."COD_SUCURSAL" = s."COD_SUCURSAL"
JOIN productos pr ON e."COD_PRODUCTO" = pr."COD_PRODUCTO"
WHERE
    s."CIUDAD_DEPART" = 'BOGOTA BOGOTA D.C.' -- AND pr."UNID_MEDIDA" = 'Kilogramos'
GROUP BY 
    e."NATURALEZA",
    pr."UNID_MEDIDA"
ORDER BY Total_valor_pagado DESC;
--

-- 
ALTER TABLE empresa_transporte 
ADD COLUMN "NOMBRE" VARCHAR(100) GENERATED ALWAYS AS (
    'Transporte ' || CAST("COD_EMPRESATRANSPORTE" AS VARCHAR)
) STORED;
--

-- 
SELECT 
    et."NOMBRE" AS Nombre_Empresa,
    SUM(e."HORAS_VIAJE") AS Total_horas_viaje,
    COUNT(e."COD_EMPRESATRANSPORTE") AS Total_entregas

FROM  entregas e
JOIN empresa_transporte et ON e."COD_EMPRESATRANSPORTE" = et."COD_EMPRESATRANSPORTE"
JOIN sucursales s ON e."COD_SUCURSAL" = s."COD_SUCURSAL"
WHERE 
    s."CIUDAD_DEPART" = 'BOGOTA BOGOTA D.C.'
GROUP BY et."NOMBRE"
ORDER BY Total_horas_viaje DESC
LIMIT 20; 
--
