-- Staging de ventas_loterias
-- Origen: bruto.ventas_loterias, cargado tal como llegó (todo texto).
--
-- T1: Limpiar el campo ventas y convertirlo a NUMERIC.
--     Eliminar $, comas y espacios.
--     Los valores vacíos o "-" quedan como NULL.
--
-- T2: Normalizar el nombre de la lotería.
--     Eliminar espacios sobrantes y convertir a mayúsculas.

CREATE OR REPLACE VIEW staging.stg_ventas_loterias AS

SELECT
    socrata_id AS id_fila,
    socrata_creado,
    socrata_actualizado,
    socrata_version,
    a_o,
    mes,

    UPPER(TRIM(loteria)) AS loteria,

    SAFE_CAST(
        NULLIF(
            REGEXP_REPLACE(TRIM(ventas), r'[$,\s]', ''),
            ''
        )
        AS NUMERIC
    ) AS ventas,

    archivo_origen

FROM bruto.ventas_loterias;