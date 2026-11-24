-- Cifras de control del staging: filas antes y después, y nulos nuevos.
-- Cambia TU_TABLA y las columnas por las tuyas. Una fila por control.
SELECT '1 filas en el bruto' AS control, COUNT(*) AS valor FROM bruto.TU_TABLA
UNION ALL SELECT '2 filas en el staging', COUNT(*) FROM staging.stg_TU_TABLA
UNION ALL SELECT '3 T1: no convirtió', COUNTIF(columna_numero IS NULL) FROM staging.stg_TU_TABLA
UNION ALL SELECT '4 T2: valores antes', COUNT(DISTINCT columna) FROM bruto.TU_TABLA
UNION ALL SELECT '5 T2: valores después', COUNT(DISTINCT columna) FROM staging.stg_TU_TABLA
ORDER BY control;
