# Analisis de ventas

Equipo E8 · Análisis de Datos Intermedio · Estud-IA (Capa 2)

## Brief v1

| Campo | Respuesta |
|---|---|
| Usuario y decisión | ¿Quién decide qué, y cada cuánto? |Un analista del equipo del proyecto usará el resultado para informar a los responsables comerciales de las loterías qué loterías tuvieron mayores ventas en el periodo estudiado.
| Pregunta | ¿Qué quieres responder? |¿Qué lotería tradicional registró el mayor valor de ventas acumulado en Colombia entre 2021 y 2025?
| Fuente con API | Enlace al endpoint (…/resource/xxxx-xxxx.json) |https://www.datos.gov.co/resource/2zg4-ahca.json?
| Qué representa una fila | |Las ventas de una lotería en un mes y año determinados.
| Campo que la identifica | |La combinación de `Loteria` + año + mes identifica cada registro.
| Cada cuánto se actualiza | |Trimestral
| Dato a confirmar | |Verificar que `Ventas` sea un valor numérico o convertirlo a número, y que la combinación `Loteria` + año + mes no tenga registros repetidos.
| Tres indicadores | 1. · 2. · 3. | 1. Valor acumulado de ventas por lotería entre 2021 y 2025. 2. Variación porcentual anual de las ventas por lotería. 3. Participación porcentual de cada lotería en el total de ventas del periodo.
| Terminó bien si… | Una regla que se responde sí o no y que otra persona puede verificar | La extracción termina sin error, trae registros de 2021 a 2025 y de más de una lotería, incluye los campos requeridos y permite calcular el total de ventas por lotería sin duplicar registros.
| No vamos a construir | |Una predicción de ventas ni una recomendación basada en datos que no estén incluidos en la fuente.

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
| Bruto cargado | `data/raw/…json` |
| Tabla en BigQuery | `bruto.…` (todas las columnas como texto) |
| Traídas según `conteos.csv` | |
| `COUNT(*)` en BigQuery | |

### Staging: de dónde viene cada columna

Archivo: `sql/stg_….sql` (vista `staging.stg_…`).

| Columna en el staging | Viene de (bruto) | Regla |
|---|---|---|
| | | |

### Conteo antes y después (`sql/controles_stg.sql`)

| Control | Bruto | Staging | ¿Es lo esperado? |
|---|---|---|---|
| Filas | | | |
