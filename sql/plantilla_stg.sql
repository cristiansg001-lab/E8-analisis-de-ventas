-- Staging de TU_TABLA
-- Copia este archivo como sql/stg_TU_TABLA.sql y cambia TU_TABLA por el nombre que te dio preparar_carga.py.
-- Origen: bruto.TU_TABLA, cargado tal como llegó de la API (todo es texto).
-- Escribe aquí tus reglas con palabras antes de escribir el SQL:
-- T1 ...
-- T2 ...
CREATE OR REPLACE VIEW staging.stg_TU_TABLA AS
SELECT
  socrata_id AS id_fila,                                   -- el :id de la API: identifica la fila
  columna_que_pasa_igual,
  SAFE_CAST(columna_texto AS INT64) AS columna_numero,     -- T1
  CASE TRIM(columna) WHEN 'así llega' THEN 'así queda' ELSE TRIM(columna) END AS columna,  -- T2
  archivo_origen
FROM bruto.TU_TABLA;
