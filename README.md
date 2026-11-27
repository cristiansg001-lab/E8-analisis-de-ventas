# Analisis de ventas

Equipo E8 · Análisis de Datos Intermedio · Estud-IA (Capa 2)

## Brief v1

| Campo | Respuesta |
|---|---|
| Usuario y decisión | Un analista del equipo del proyecto usará el resultado para informar a los responsables comerciales de las loterías qué loterías tuvieron mayores ventas en el periodo estudiado.
| Pregunta | ¿Qué lotería tradicional registró el mayor valor de ventas acumulado en Colombia entre 2021 y 2025?
| Fuente con API |https://www.datos.gov.co/resource/2zg4-ahca.json?
| Qué representa una fila |Las ventas de una lotería en un mes y año determinados.
| Campo que la identifica |La combinación de `Loteria` + año + mes identifica cada registro.
| Cada cuánto se actualiza |Trimestral
| Dato a confirmar |Verificar que `Ventas` sea un valor numérico o convertirlo a número, y que la combinación `Loteria` + año + mes no tenga registros repetidos.
| Tres indicadores | 1. Valor acumulado de ventas por lotería entre 2021 y 2025. 2. Variación porcentual anual de las ventas por lotería. 3. Participación porcentual de cada lotería en el total de ventas del periodo.
| Terminó bien si… | La extracción termina sin error, trae registros de 2021 a 2025 y de más de una lotería, incluye los campos requeridos y permite calcular el total de ventas por lotería sin duplicar registros.
| No vamos a construir |Una predicción de ventas ni una recomendación basada en datos que no estén incluidos en la fuente.

## Contrato de datos

- Una fila es:
- La identifica:
- Si llega una fila repetida:
- Si falta un campo:

## Bitácora de decisiones

| Fecha | Decisión | Por qué |
|---|---|---|
| | | |

## Reglas del repositorio

- Es público: nada de datos personales, contraseñas, tokens ni llaves.
- Las credenciales van en un archivo `.env`, que Git ignora (ver `.gitignore`). `.env.example` muestra qué variables hacen falta, sin valores.
- Cada commit explica en su mensaje qué se decidió y por qué.

## Carga y staging

### Carga a BigQuery

| | |
|---|---|
| Bruto cargado | `data/raw/2zg4-ahca_2026-11-24_072949.json` |
| Tabla en BigQuery | `bruto.ventas_loterias` (todas las columnas como texto) |
| Traídas según `conteos.csv` | 3.173 |
| `COUNT(*)` en BigQuery | 3.173 |

### Staging: de dónde viene cada columna

Archivo: `sql/stg_ventas_loterias.sql` (vista `staging.stg_ventas_loterias`).

| Columna en el staging | Viene de (bruto) | Regla |
|---|---|---|
| id_fila | socrata_id | Identificador de la fila |
| socrata_creado | socrata_creado | Sin transformación |
| socrata_actualizado | socrata_actualizado | Sin transformación |
| socrata_version | socrata_version | Sin transformación |
| a_o | a_o | Sin transformación |
| mes | mes | Sin transformación |
| loteria | loteria | T2: TRIM y conversión a mayúsculas |
| ventas | ventas | T1: eliminar $, comas y espacios; convertir a NUMERIC. Vacíos y "-" quedan como NULL |
| archivo_origen | archivo_origen | Sin transformación |

### Conteo antes y después (`sql/controles_stg.sql`)

| Control | Bruto | Staging | ¿Es lo esperado? |
|---|---:|---:|---|
| Filas | 3.173 | 3.173 | Sí: staging conserva todas las filas |
| Ventas no convertidas | — | 119 | Sí: corresponden a valores vacíos o "-" |
| Loterías distintas | 34 | 25 | Sí: T2 normaliza variaciones de escritura |

## Mi consulta en 3 respuestas (S4)

Consulta: `sql/stg_ventas_loterias.sql`

**1. ¿Por qué el número de filas es igual en bruto y staging?**

Porque las transformaciones que hicimos no eliminaron filas. Convertimos los valores de ventas de texto a números y normalizamos los nombres de las loterías, conservando el total de registros.

**2. ¿Por qué usamos SAFE_CAST y qué pasó con las conversiones fallidas?**

Usamos SAFE_CAST para convertir las ventas a números sin que la consulta falle cuando encuentra un valor que no puede convertir. Los valores vacíos o con guion quedaron como NULL; fueron 119.

**3. ¿Qué pasaría si quitáramos la regla T2?**

Si quitáramos la regla T2, tendríamos la misma lotería registrada en diferentes categorías debido a variaciones en su escritura, por ejemplo, con mayúsculas o espacios. Esto podría dividir la información y afectar los análisis, como las sumas y los promedios de ventas.
