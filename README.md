# Nombre del proyecto

Equipo E__ · Análisis de Datos Intermedio · Estud-IA (Capa 2)

## Brief v1

| Campo | Respuesta |
|---|---|
| Usuario y decisión | ¿Quién decide qué, y cada cuánto? |
| Pregunta | ¿Qué quieres responder? |
| Fuente con API | Enlace al endpoint (…/resource/xxxx-xxxx.json) |
| Qué representa una fila | |
| Campo que la identifica | |
| Cada cuánto se actualiza | |
| Dato a confirmar | |
| Tres indicadores | 1. · 2. · 3. |
| Terminó bien si… | Una regla que se responde sí o no y que otra persona puede verificar |
| No vamos a construir | |

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
