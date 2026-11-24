# Prompt para escribir tu SQL con ayuda de IA · S4 y S5

Análisis de Datos Intermedio · Estud-IA (Capa 2)

La IA te puede ayudar a escribir el SQL, pero no conoce tu fuente ni sabe qué decidió tu equipo. Eso lo pones tú en la **ficha**. Lo que te devuelva es un **borrador**: lo corres, compruebas las cifras de control y lo puedes explicar línea por línea. Si no lo puedes explicar, no va al repositorio.

## Cómo se usa

1. Llena la ficha (mensaje 1) en este archivo, con tu equipo. Si no sabes qué poner en una línea, esa es la decisión que les falta: resuélvanla antes de pedir SQL.
2. Abre una conversación nueva en tu asistente de IA y pega el mensaje 1 completo.
3. Pega el mensaje del paso en el que vas, con sus espacios llenos. En una conversación nueva, pega otra vez el mensaje 1 antes del paso.
4. Guarda el SQL en `sql/`, córrelo con `bq query --use_legacy_sql=false < sql/archivo.sql` y compara las cifras con lo que esperabas.
5. Anota en la bitácora (al final) qué te propuso, qué comprobaste y qué cambiaste. Este archivo va en tu pull request, con la ficha llena.

| Paso del prompt | Para qué | Guía |
|---|---|---|
| A | Tu staging: `sql/stg_….sql` | S4, pasos 6 y 7 |
| B | Cifras de control del staging: `sql/controles_stg.sql` | S4, paso 9 |
| C | Granularidad y llave, antes del hecho | S5, paso 2 |
| D | Tu hecho: `sql/fct_….sql` | S5, paso 3 |
| E | Una dimensión: `sql/dim_….sql` | S5, pasos 5 y 7 |
| F | Cifras de control del mart: `sql/controles_mart.sql` | S5, paso 8 |
| G | La consulta de tu indicador, con CTE | S5, paso 9 |
| Error | Cuando algo no corre | Cualquier paso |

> **Nunca pegues** en la IA tu `.env`, tokens ni contraseñas. Si tu fuente trae datos de personas (nombres, documentos, direcciones, coordenadas, etnia, EPS…), en las filas de ejemplo cámbialos por `XXX`.

### Para llenar la ficha (en Cloud Shell)

| Necesitas | Comando |
|---|---|
| Las columnas del bruto | `bq show --schema bruto.TU_TABLA` |
| Tres filas de ejemplo | `bq --format=prettyjson head -n 3 bruto.TU_TABLA` |
| Los valores de una columna, para ver rarezas | `bq query --use_legacy_sql=false 'SELECT columna, COUNT(*) AS filas FROM bruto.TU_TABLA GROUP BY 1 ORDER BY 2 DESC LIMIT 30'` |
| Las columnas de tu staging (S5) | `bq show --schema staging.stg_TU_TABLA` |

`bq show` y `bq head` no gastan cuota: leen la tabla sin consultarla. `bq head` no funciona sobre vistas; para ver filas del staging usa la pestaña Preview del bruto o una consulta con las columnas que necesitas.

---

## Mensaje 1 · Instrucciones y ficha de tu fuente

Llena lo que está entre corchetes. Lo demás no lo cambies.

```text
Vas a ayudarme a escribir SQL para mi proyecto del curso Análisis de Datos Intermedio (Estud-IA). Trabajo en BigQuery, en la zona de pruebas (Sandbox), y corro cada archivo desde Cloud Shell con: bq query --use_legacy_sql=false < sql/archivo.sql. Respóndeme en español.

REGLAS PARA TI
1. Usa solo las tablas y columnas de mi ficha, con esos nombres exactos. No inventes columnas.
2. Si a la ficha le falta algo que necesitas (qué representa una fila, la llave, una regla, la clave de una dimensión) o un campo sigue entre corchetes [ ] o empieza con «ej.:», no lo supongas: hazme hasta 3 preguntas y espera mi respuesta antes de escribir SQL.
3. Zona de pruebas: nada de INSERT, UPDATE, DELETE ni MERGE. El staging es CREATE OR REPLACE VIEW staging.stg_<tabla>; el mart es CREATE OR REPLACE TABLE mart.<tabla> AS SELECT.
4. Al principio de cada archivo, en comentarios, cada regla con palabras: T1, T2… en el staging; H1, H2… en el hecho; la regla de la clave en la dimensión. En la línea que aplica una regla, un comentario con su código.
5. Convierte con SAFE_CAST, nunca con CAST. No rellenes vacíos con 0 ni con texto: un nulo dice «no sé». Para un valor que significa «no hay dato», NULLIF.
6. El staging no quita filas: una fila del bruto = una fila del staging, salvo que yo te dé una regla escrita para quitar alguna; en ese caso, dime cuántas quita. Conserva el campo que identifica la fila del bruto como id_fila (en datos.gov.co es socrata_id) y conserva archivo_origen.
7. Para dejar una fila por llave usa ROW_NUMBER() con un ORDER BY que tenga desempate (id_fila). Si las copias de una llave traen valores distintos, márcalas en una columna; no escojas una en silencio.
8. Si un resultado trae filas de más, no lo tapes con DISTINCT ni con GROUP BY: dime qué clave se repite y dónde se corrige.
9. En las consultas de control usa LEFT JOIN para no perder filas sin pareja, y numera los controles 01, 02… para que ORDER BY no los desordene.
10. Para explorar no uses SELECT * sobre toda la tabla: LIMIT no reduce lo que se procesa.

CÓMO RESPONDES, EN ESTE ORDEN
a) Preguntas, solo si falta algo (regla 2). Si preguntas, no escribas SQL todavía.
b) El archivo completo en un solo bloque de código, con su nombre (sql/…) en la primera línea de comentario.
c) Qué hace cada regla, en una línea cada una y sin jerga.
d) Las cifras de control: la consulta, qué valor debería salir si todo está bien y qué significa si sale otro.
e) Las filas para la tabla del README.
f) Dos preguntas que yo debería poder responder sobre este SQL antes de hacer commit. No me des las respuestas.

FICHA DE MI FUENTE
Equipo: [E__]
Pregunta del proyecto: [la del brief]
Usuario y decisión: [quién decide qué con esto, y cada cuánto]
Fuente: [nombre y endpoint, por ejemplo https://www.datos.gov.co/resource/xxxx-xxxx.json]
Qué representa una fila del bruto: [con palabras]
Campo que identifica una fila: [socrata_id u otro]
Tabla en el bruto: [bruto.nombre, como la dejó preparar_carga.py]
Filas en el bruto (COUNT en BigQuery = traídas en conteos.csv): [ ]
Columnas del bruto (salida de bq show --schema): [pega aquí]
Tres filas de ejemplo (salida de bq head; datos de personas cambiados por XXX): [pega aquí]
Lo raro que vimos en la fuente, con cifra (formatos, vacíos, nombres escritos distinto, copias):
- [ej.: la columna mes llega como texto: «Enero», «Febrero»…]
- [ ]
Columnas con datos de personas que no deben pasar al staging: [ninguna / cuáles]
Indicadores del brief: 1. [ ] 2. [ ] 3. [ ]

Por ahora no escribas SQL. Responde «Listo» y dime qué le falta a la ficha, si le falta algo. Después te pido cada paso.
```

---

## Paso A · S4 · Tu staging

Antes de llenarlo: guía de la S4, paso 6. Si no puedes decir la regla con palabras y con una fila de ejemplo, todavía no está lista para el SQL.

```text
PASO A: escribe sql/stg_[tabla].sql, la vista staging.stg_[tabla].

Mis reglas, con palabras y una fila de ejemplo:
T1: [ej.: año, mes y cargos pasan de texto a número] · Antes: [ej.: "2018", "Enero"] · Después: [ej.: 2018, 1]
T2: [ ] · Antes: [ ] · Después: [ ]
T3 (si hay): [ ]
Columnas que pasan sin cambio: [ ]
Columnas que no paso al staging y por qué: [ ]

Usa esta forma:
-- Staging de TU_TABLA
-- Origen: bruto.TU_TABLA, cargado tal como llegó de la API (todo es texto).
-- T1 ...
-- T2 ...
CREATE OR REPLACE VIEW staging.stg_TU_TABLA AS
SELECT
  socrata_id AS id_fila,                                   -- identifica la fila
  columna_que_pasa_igual,
  SAFE_CAST(columna_texto AS INT64) AS columna_numero,     -- T1
  CASE TRIM(columna) WHEN 'así llega' THEN 'así queda' ELSE TRIM(columna) END AS columna,  -- T2
  archivo_origen
FROM bruto.TU_TABLA;
```

## Paso B · S4 · Cifras de control del staging

```text
PASO B: escribe sql/controles_stg.sql para el staging que hicimos.
Quiero una fila por control: filas en el bruto y en el staging, y para cada regla una cifra antes y después.
- Para cada SAFE_CAST, separa los que ya venían vacíos de los que tenían texto y no convirtieron.
- Para cada CASE, valores distintos antes y después.
Lo que espero ver: [ej.: las mismas filas; 25 municipios pasan a 24; 0 meses sin convertir]

Usa esta forma:
SELECT '01 filas en el bruto' AS control, COUNT(*) AS valor FROM bruto.TU_TABLA
UNION ALL SELECT '02 filas en el staging', COUNT(*) FROM staging.stg_TU_TABLA
UNION ALL SELECT '03 T1: no convirtió', COUNTIF(columna_texto IS NOT NULL AND SAFE_CAST(columna_texto AS INT64) IS NULL) FROM bruto.TU_TABLA
UNION ALL SELECT '04 T2: valores antes', COUNT(DISTINCT columna) FROM bruto.TU_TABLA
UNION ALL SELECT '05 T2: valores después', COUNT(DISTINCT columna) FROM staging.stg_TU_TABLA
ORDER BY control;

Si algún control de conversión no da 0, dame también la consulta para ver qué valores del bruto no convirtieron y cuántas filas tiene cada uno.
```

---

## Paso C · S5 · Granularidad y llave

Este paso no escribe el hecho: comprueba si tu llave se repite antes de decidir qué hacer.

```text
PASO C: ayúdame a comprobar la granularidad de mi hecho. Todavía no escribas el hecho.
Mi staging: staging.stg_[tabla] · Columnas (salida de bq show --schema): [pega aquí]
Una fila de mi hecho = [con palabras, ej.: el cargo de un servicio para un municipio, un sector y un estrato en un mes]
Llave natural (columnas del staging que identifican esa fila): [ ]
Medida(s) que voy a sumar o promediar: [ ]

Dame:
1. La consulta que cuenta filas y llaves distintas en el staging.
2. Si filas > llaves, la consulta que separa las llaves con copias exactas de las llaves cuyas copias traen valores distintos, con 5 ejemplos de cada una.
No decidas cuál fila se queda: lo decido yo con las cifras.
```

## Paso D · S5 · Tu hecho

```text
PASO D: escribe sql/fct_[hecho].sql, la tabla mart.fct_[hecho].
Lo que salió en el paso C: filas [ ] · llaves [ ] · llaves con copias exactas [ ] · llaves con valores distintos [ ]
H1 Cuál fila se queda cuando una llave se repite: [ej.: la de fecha de actualización más reciente; desempate id_fila]
H2 Qué hago con las llaves cuyas copias traen valores distintos: [ej.: las marco en una columna y los indicadores las excluyen]
Columnas que lleva el hecho: [la llave, las medidas, id_fila, archivo_origen…]

Usa esta forma:
-- Hecho TU_HECHO. Granularidad: una fila = … (con palabras).
-- Llave natural: columna1, columna2, columna3.
-- H1 Una fila por llave. Orden: columna_criterio (y el desempate: id_fila).
CREATE OR REPLACE TABLE mart.fct_TU_HECHO AS
WITH numeradas AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY columna1, columna2, columna3
      ORDER BY columna_criterio DESC, id_fila) AS n_copia,
    COUNT(*) OVER (PARTITION BY columna1, columna2, columna3) AS filas_llave
  FROM staging.stg_TU_TABLA
)
SELECT columna1, columna2, columna3, medida1, filas_llave AS filas_en_staging, id_fila
FROM numeradas
WHERE n_copia = 1;

Dame también la consulta que comprueba que en el hecho llaves = filas.
```

## Paso E · S5 · Una dimensión

Pon solo las dimensiones que tu pregunta usa (una o dos). Pide una por mensaje.

```text
PASO E: escribe sql/dim_[dimensión].sql, la tabla mart.dim_[dimensión].
Para qué la necesita mi pregunta: [ ]
Una fila de la dimensión = [ej.: un municipio] · Clave: [ ] (no se puede repetir)
De dónde sale: [mi staging, u otra tabla: staging.stg_… con sus columnas]
Cómo cruza con el hecho: mart.fct_[hecho].[columna] = [columna de la dimensión]
Regla de la clave (tildes, mayúsculas, ceros a la izquierda, excepciones): [ ]
Atributos que lleva: [ ]

Si la clave se puede repetir con atributos distintos, no uses DISTINCT: dime cuántas claves se repiten y propón una regla con ROW_NUMBER que yo pueda escribir con palabras.
Si es una dimensión de fecha o de mes, genérala con GENERATE_DATE_ARRAY entre el primer y el último periodo del hecho.

Usa esta forma:
-- Dimensión TU_DIMENSION: una fila por … Clave: … (no se puede repetir).
-- Regla de la clave: cómo se escribe para que cruce con el hecho.
CREATE OR REPLACE TABLE mart.dim_TU_DIMENSION AS
SELECT DISTINCT
  clave,
  atributo1,
  atributo2
FROM staging.stg_TU_TABLA;
```

## Paso F · S5 · Cifras de control del mart

```text
PASO F: escribe sql/controles_mart.sql para mi hecho y mi(s) dimensión(es).
Hecho: mart.fct_[ ] · llave: [ ] · medida para sumar: [ ]
Dimensión: mart.dim_[ ] · clave: [ ] · se une con el hecho por: [ ]
Si tengo más de una dimensión, un bloque de controles para cada una.

Usa esta forma:
WITH unido AS (
  SELECT f.medida1, d.clave AS clave_dim
  FROM mart.fct_TU_HECHO AS f
  LEFT JOIN mart.dim_TU_DIMENSION AS d ON d.clave = f.clave
)
SELECT '01 filas en el staging' AS control, COUNT(*) AS valor FROM staging.stg_TU_TABLA
UNION ALL SELECT '02 filas en el hecho', COUNT(*) FROM mart.fct_TU_HECHO
UNION ALL SELECT '03 llaves repetidas en el hecho',
  COUNT(*) - COUNT(DISTINCT FORMAT('%t', (columna1, columna2, columna3))) FROM mart.fct_TU_HECHO
UNION ALL SELECT '04 claves repetidas en la dimension', COUNT(*) - COUNT(DISTINCT clave) FROM mart.dim_TU_DIMENSION
UNION ALL SELECT '05 filas del hecho sin dimension', COUNTIF(clave_dim IS NULL) FROM unido
UNION ALL SELECT '06 filas despues del JOIN', COUNT(*) FROM unido
UNION ALL SELECT '07 suma antes del JOIN', CAST(ROUND(SUM(medida1)) AS INT64) FROM mart.fct_TU_HECHO
UNION ALL SELECT '08 suma despues del JOIN', CAST(ROUND(SUM(medida1)) AS INT64) FROM unido
ORDER BY control;
```

## Paso G · S5 · La consulta de tu indicador

```text
PASO G: escribe sql/indicador_[nombre].sql con una CTE.
Indicador (del brief, con palabras): [ ]
Qué filas entran: [el filtro, ej.: estrato 3, octubre de 2026, sin llaves en conflicto]
Cómo se agrupa: [por qué atributo de qué dimensión]
Dame también la cifra de control: cuántas filas entran a la CTE y cuántas filas del hecho suma el resultado. Tienen que ser iguales.
```

---

## Si te sale un error

```text
ERROR: corrí sql/[archivo].sql y salió esto:
[pega el mensaje completo]
El archivo que corrí:
[pega el SQL]
Explícame la causa en una frase y dime qué línea cambio. No reescribas todo el archivo.
```

---

## Bitácora de uso de IA

Una fila por paso. Va en tu pull request.

| Paso | Qué me propuso | Qué comprobé (cifra) | Qué cambié y por qué |
|---|---|---|---|
| A | | | |
| B | | | |
| C | | | |
| D | | | |
| E | | | |
| F | | | |
| G | | | |
