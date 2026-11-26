-- Cifras de control del staging: filas antes y después, y reglas T1 y T2.

SELECT
    '1 filas en el bruto' AS control,
    COUNT(*) AS valor
FROM bruto.ventas_loterias

UNION ALL

SELECT
    '2 filas en el staging',
    COUNT(*)
FROM staging.stg_ventas_loterias

UNION ALL

SELECT
    '3 T1: ventas no convirtió',
    COUNTIF(ventas IS NULL)
FROM staging.stg_ventas_loterias

UNION ALL

SELECT
    '4 T2: loterías distintas antes',
    COUNT(DISTINCT loteria)
FROM bruto.ventas_loterias

UNION ALL

SELECT
    '5 T2: loterías distintas después',
    COUNT(DISTINCT loteria)
FROM staging.stg_ventas_loterias

ORDER BY control;