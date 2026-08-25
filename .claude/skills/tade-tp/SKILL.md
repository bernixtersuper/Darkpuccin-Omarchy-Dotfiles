---
name: tade-tp
description: |
  Arma un Trabajo Práctico completo para la materia 11.85 Toma de Decisiones del ITBA.
  Úsala cuando el usuario diga "hacer el TP de TADE", "armar el informe del TP", o cuando
  proporcione una carpeta con materiales del TP (rubrica, draft, ideas, planillas de ejemplo).
  La skill cubre el flujo completo: leer la rubrica, definir el problema, elegir y aplicar
  el método MCDM (preferentemente AHP), generar la planilla Excel de cálculo, y escribir
  el informe_final.md con las 4 secciones requeridas. Genera también el symlink en Obsidian.
---

# TP de Toma de Decisiones (ITBA 11.85)

## Flujo completo

### Paso 0: Relevamiento de materiales

Antes de escribir nada, leer todo lo que haya en la carpeta del TP:

1. **Rubrica / consigna** (PDF): usar Read directamente — renderiza PDFs como imágenes.
2. **Draft de informe** si existe: parsear con `firecrawl parse` si es DOCX/PDF, leer directo si es MD.
3. **Ideas / pesos propuestos** por el grupo: leer el archivo de notas.
4. **Planilla de ejemplo de la cátedra** (xlsx): parsear con `firecrawl parse` para entender el formato esperado.
5. **Slides de clase relevantes** (están en la carpeta de la clase donde se vio el método, ej. `2026-05-15/`): leer con Read (PDF renderiza como imágenes).

No asumir nada sobre el tema, las alternativas ni los criterios antes de leer los materiales del grupo.

### Paso 1: Entender la rubrica

La rubrica de este TP pide exactamente 4 secciones:

1. **Presentación del problema** — por qué esto es un problema (no solo descripción).
2. **Desarrollo del problema y posibles soluciones** — causas, consecuencias, pros/contras de cada alternativa, y **al menos una solución debe llegar via herramienta de la materia** (subrayado en la rubrica).
3. **Definición de la propuesta** — por qué se elige la que se elige, por qué NO se eligieron las otras, orden de preferencia explícito.
4. **Anexos, fuentes y bibliografía** — todo lo que no sea de generación propia.

### Paso 2: Definir el problema

Escribir la sección 1 enfocada en:
- Qué hace que esto sea un *problema* y no solo una situación.
- Causas raíz (no síntomas).
- Consecuencias concretas de no resolverlo.
- Contexto cuantitativo si existe (tamaño del evento, número de personas afectadas, etc.).

### Paso 3: Identificar alternativas y hacer benchmarking

- Definir exactamente 3 alternativas (el método AHP funciona bien con 3; más de 4 complica la presentación).
- Nombrarlas A / B / C con nombre descriptivo.
- Para cada una: descripción breve + ventajas + desventajas (lista de bullets, no párrafos largos).
- Buscar 3-4 referentes reales del problema para benchmarking. Usar `firecrawl search` si se necesita investigar.

### Paso 4: Elegir y justificar el método MCDM

Siempre comparar contra los otros métodos vistos en la materia antes de elegir:

| Método | Cuándo usarlo | Limitación |
|---|---|---|
| Pros/contras | Primer filtro cualitativo | No produce ranking numérico |
| Scoring ponderado directo | Criterios bien definidos, pesos claros | No verifica coherencia interna de los pesos |
| TOPSIS | Datos objetivos y cardinales por alternativa | Menos adecuado cuando los valores son juicios estimados |
| **AHP** | Juicios subjetivos, criterios comparables, se necesita verificar consistencia | Mayor complejidad de cálculo |

**Elegir AHP cuando:** los pesos de criterios vienen de juicio del grupo (no de datos objetivos) y es importante poder demostrar que ese juicio es matemáticamente consistente. Es el caso típico en los TPs de esta materia.

### Paso 5: Construir la matriz de criterios AHP

**Inputs que el grupo debe decidir (y justificar):**

1. **Los criterios** (idealmente 4-6; más de 6 hace la presentación muy pesada).
2. **La importancia relativa entre cada par de criterios** usando la escala de Saaty:

| Valor | Significado |
|---|---|
| 1 | Igual importancia |
| 2 | Preferencia débil |
| 3 | Importancia moderada |
| 5 | Importancia fuerte |
| 7 | Muy fuerte |
| 9 | Extrema |
| 2, 4, 6, 8 | Valores intermedios |

**Truco si el grupo tiene pesos directos (%):** calcular ratios wi/wj y redondear al entero Saaty más cercano. Verificar que RC ≤ 0,10.

**Qué mostrar en el informe:**
- Tabla de criterios con peso AHP y justificación narrativa de cada peso (por qué ese criterio tiene ese nivel de importancia).
- Mencionar que la matriz completa y su verificación de consistencia están en la planilla adjunta.
- Solo el resultado: RC = X,XXX → consistente / no consistente.

**Qué NO mostrar en el informe:** sumas de columnas, normalización paso a paso, cálculo de λmax. Todo eso va en el Excel.

### Paso 6: Construir matrices de alternativas

Para cada criterio, una matriz 3×3 comparando las tres alternativas.

**Cómo derivar los valores AHP desde puntuaciones (escala 1-5):**
- Diferencia de 1 punto → valor AHP 2
- Diferencia de 2 puntos → valor AHP 4
- Diferencia de 3 puntos → valor AHP 6

**Qué mostrar en el informe:** una tabla con una fila por criterio, el orden (C>B>A o el que corresponda) y **una oración explicando por qué** — el razonamiento sustantivo, no el cálculo. Ejemplo:

| Criterio | Orden | Juicio principal |
|---|---|---|
| C1 – Impacto | C > B > A (débil entre pares) | C multiplica el impacto via mentorías y comunidad; A solo genera impacto el día del evento. |

### Paso 7: Generar la planilla Excel

Generar un script Python con openpyxl que produzca un Excel con el formato de la cátedra:
- Celdas de input en gris (`FFC0C0C0` fill), celdas de fórmulas en blanco.
- Recíprocos calculados con fórmulas (`=1/B3`, etc.), no valores hardcodeados.
- Sumas de columna, normalización, vector wt, A×wt, λmax, IC, IA, RC — todo con fórmulas.
- Una hoja o sección por matriz (criterios + una por alternativa).
- Tabla de síntesis al final con prioridades globales y ranking.

Guardar el Excel en la misma carpeta del TP como `AHP_{nombre}.xlsx`.

Verificar numéricamente que los resultados sean correctos antes de reportarlos en el informe.

**IA de referencia por tamaño de matriz:**
- n=3 → IA=0,58
- n=4 → IA=0,90
- n=5 → IA=1,12
- n=6 → IA=1,24

### Paso 8: Escribir el informe final

Archivo: `informe_final.md` en la carpeta del TP.

**Reglas de formato:**
- El informe es un documento de decisión, no un apunte de cálculo. Los números que van en el informe son los inputs que el grupo decidió y los outputs del ranking. Los cálculos intermedios van en el Excel.
- Tildes y ñ correctas (es un documento entregable).
- Sin em dashes (—). Usar coma o punto y coma.
- Sin párrafos internamente cortados con saltos de línea.
- Tablas para comparaciones, no listas de párrafos.
- La sección de comparación de alternativas por criterio: **una tabla**, no un párrafo por criterio.

**Estructura del informe:**

```
# Título del TP

Materia / Integrantes / Año

## 1. Presentación del problema
## 2. Desarrollo del problema y sus posibles soluciones
   ### 2.1 Benchmarking
   ### 2.2 Alternativas propuestas
   ### 2.3 Selección de la herramienta de análisis
   ### 2.4 Aplicación del método AHP
       #### Criterios y ponderación (tabla con justificación)
       #### Comparación de alternativas por criterio (una tabla)
       #### Resultados (ranking final)
## 3. Definición de la propuesta
   ### 3.1 Alternativa seleccionada + propuesta concreta
   ### 3.2 Por qué no se selecciona A
   ### 3.3 Por qué no se selecciona B
   ### 3.4 Orden de preferencia
## 4. Anexos, fuentes y bibliografía
   ### Anexo 1: Referencia a la planilla Excel
   ### Anexo 2: Escala de Saaty
   ### Anexo 3: Tabla de IA
   ### Anexo 4: Benchmarking detallado (si corresponde)
   ### Fuentes y bibliografía
```

**Bibliografía mínima:**
- Saaty, T. L. (1980). *The Analytic Hierarchy Process.* McGraw-Hill.
- Saaty, T. L. (1990). How to make a decision. *European Journal of Operational Research*, 48(1), 9-26.
- Slides de clase TD16 (o el número correspondiente al tema AHP).
- Fuentes del tema del TP (sitio institucional, LinkedIn, notas periodísticas, etc.).

### Paso 9: Symlink en Obsidian

```bash
ln -s "<ruta_absoluta>/informe_final.md" \
  "/home/berni/Desktop/Facultad_Obsidian/11.85 - Toma de Decisiones/TP1/informe_final.md"
```

Verificar que la carpeta TP1 exista en Obsidian antes de crear el symlink.

---

## Checklist de entrega

- [ ] Rubrica leída y las 4 secciones cubiertas
- [ ] Problema presentado como problema (causas + consecuencias), no solo descripción
- [ ] 3 alternativas con pros/contras
- [ ] Justificación de por qué AHP sobre otros métodos
- [ ] Tabla de criterios con pesos AHP y justificación narrativa
- [ ] Tabla de alternativas por criterio (una fila por criterio, no un párrafo)
- [ ] RC ≤ 0,10 en todas las matrices
- [ ] Excel generado y verificado numéricamente
- [ ] Ranking explícito con porcentajes
- [ ] Sección 3 explica por qué NO se eligieron las otras alternativas
- [ ] Orden de preferencia explícito (1° / 2° / 3°)
- [ ] Bibliografía incluye Saaty 1980
- [ ] Symlink creado en Obsidian
