---
name: iaan-churn
description: >
  Skill para trabajar en el TP3 de IAAN (Inteligencia Artificial Aplicada a los Negocios),
  modelo de clasificacion de churn. Usar cuando el usuario mencione el TP3 de IAAN, churn,
  el arbol de decision del trabajo practico, o quiera agregar aprendizajes/decisiones al proyecto.
---

# IAAN TP3 - Churn Classification Skill

## Rutas clave

```
REPO             = /home/berni/Desktop/Dev/TP3_Prediccion_Churn_IAAN_Grupo_04/
BASE_CONOCIMIENTO = /home/berni/Desktop/Facultad/3A1Q/81.91 - Inteligencia Artificial Aplicada a los Negocios/TP3-Churn/
SIA_SUMMARIES    = /home/berni/Desktop/Facultad/2A2Q/71.22 - Sistemas de Inteligencia Artificial/summaries/
```

## Orientacion inicial obligatoria

Al invocar este skill, SIEMPRE hacer esto primero (en paralelo):

1. Listar archivos en `REPO` para ver el estado del repo
2. Leer `REPO/decisions.md` para recordar decisiones tomadas
3. Leer el summary de SIA TP2 (`SIA_SUMMARIES/SIA_TP2_resumen.md`) ya que contiene el workflow de arbol de decision mas relevante para este TP

Despues de orientarse, reportar al usuario:
- Que notebooks y reports existen
- Las ultimas decisiones registradas en decisions.md
- Si hay dataset disponible en el repo

## Estructura del repo

```
REPO/
  .venv/                           # venv del proyecto (python3 -m venv .venv)
  data/
    raw/datos.csv                  # dataset original, nunca modificar
    processed/
      datos_limpios.csv            # output del notebook de limpieza
      datos_limpios_cat_cleaned.csv
      features_train.parquet       # features ya transformadas (33 cols), listas para modelado
      features_test.parquet
      target_train.csv             # columnas: CustomerID, Churn
      target_test.csv
      split/                       # CSVs del split: train.csv, test.csv, X_train.csv, etc.
  notebooks/
    1. Limpieza de datos.ipynb
    2. EDA guiado por hipotesis.ipynb
    3. Training.ipynb              # split + feature pipeline (NO entrena modelos)
    4. Modeler.ipynb               # modelos + SHAP + threshold tuning (EJECUTADO)
  outputs/
    eda/                           # graficos del EDA (H1-H8, heatmaps, etc.)
    models/                        # best_rf.pkl, confusion_matrix.png, roc_curve.png,
                                   # shap_summary.png, shap_bar.png, shap_waterfall_example.png,
                                   # dt_tree.png, precision_recall_tradeoff.png,
                                   # confusion_matrix_comparison.png
  src/
    features/
      pipeline.py                  # BusinessFeatureBuilder + ColumnTransformer
  reports/
    00_contexto_negocio.md
    01_hipotesis.md
    02_data_quality.md
    03_eda.md
  decisions.md                     # ultimo: Decision 28
  requirements.txt                 # incluye shap (agregado 2026-06-08)
  README.md
```

## Formato de decisions.md

Cada entrada sigue este formato exacto:

```
## Decision N - Titulo breve

**Fecha:** YYYY-MM-DD

**Que decidimos:** que se decidio o encontro.

**Por que:** razonamiento detras de la decision.

**Alternativas descartadas:** opciones que se evaluaron y no se eligieron.

**Consecuencias:** que implica esta decision para el resto del trabajo.
```

Cuando se agrega una entrada nueva, usar el numero correlativo siguiente al ultimo.

## Contexto del problema

- **Tarea:** clasificacion binaria (churn = se va / se queda)
- **Dataset:** 5.630 clientes, 20 columnas (1 ID + 1 target `Churn` + 18 features)
- **Desbalance:** ~17% clase positiva (churn=1), ~83% clase negativa (churn=0)
- **Modelo baseline:** `DecisionTreeClassifier` (requerido por catedra, sirve como piso)
- **Modelo potente:** `RandomForestClassifier` con GridSearchCV
- **Metrica principal:** ROC-AUC (no accuracy -- un modelo trivial de "nadie churna" tiene 83%)
- **class_weight:** usar `'balanced'` por defecto en ambos modelos
- **Split:** `train_test_split(X, y, stratify=y, test_size=0.2, random_state=42)` -- ANTES del preprocesamiento

### Variables clave del dataset

- `Tenure` -- meses como cliente. Predictor mas fuerte del EDA (effect size -0.61)
- `Complain` -- reclamo el ultimo año. Churn 31.7% con reclamo vs 10.9% sin reclamo. RIESGO DE LEAKAGE si el reclamo se registro despues de la decision de irse
- `CashbackAmount` -- predictor moderado, mediana 150 churners vs 166 activos
- `DaySinceLastOrder` -- NO usar como predictor de alerta temprana. Ver Decision 15: la variable es retroactiva, captura los dias desde la ultima compra al momento de registrar el churn, no inactividad previa
- `SatisfactionScore` -- resultado contraintuitivo: scores altos tienen mas churn. Ver Decision 13
- `OrderCount` -- efecto debil (effect size -0.05), medianas iguales entre grupos

### Variables con nulos (7 columnas)
`Tenure`, `WarehouseToHome`, `HourSpendOnApp`, `OrderAmountHikeFromlastYear`, `CouponUsed`, `OrderCount`, `DaySinceLastOrder`

Estrategia implementada en `src/features/pipeline.py`: `SimpleImputer(strategy="median")` + `RobustScaler()` para numericas. Decision 3 proponia KNN pero el pipeline final uso mediana (mas robusto, menos costoso, sin riesgo de leakage en imputacion).

### Fechas de entrega
- **05/06:** EDA + repo GitHub (ENTREGADO)
- **12/06:** Notebook modelado + decisions.md
- **19/06:** Reporte ejecutivo (PDF 4-6 pags) + defensa oral (15 min)

## Feature pipeline (src/features/pipeline.py)

El pipeline tiene 33 columnas de salida: 12 numericas base + 4 derivadas + 17 OHE.

**Features derivadas de negocio (BusinessFeatureBuilder):**
- `valor_cliente_proxy` = `OrderCount` * `CashbackAmount`
- `coupon_per_order` = `CouponUsed` / `OrderCount` (clip lower=1)
- `cashback_per_order` = `CashbackAmount` / `OrderCount`
- `complain_x_satisfaction` = `Complain` * `SatisfactionScore` (captura interaccion H7)

`DaySinceLastOrder` se droppea en el pipeline (Decision 15: variable retroactiva).

El pipeline aplica `BusinessFeatureBuilder` primero, despues `ColumnTransformer`:
- Numericas: `SimpleImputer(median)` + `RobustScaler()`
- Categoricas: `SimpleImputer(most_frequent)` + `OneHotEncoder(handle_unknown='ignore')`

El parquet con features ya transformadas esta en `data/processed/`. Para modelado nuevo, cargar directamente desde ahi en lugar de re-fitear el pipeline.

## Estrategia de modelos

Usar dos modelos en paralelo:

1. **DecisionTreeClassifier** - requerido por la catedra, baseline interpretable
2. **RandomForestClassifier** - modelo principal, mejor performance
3. **SHAP sobre Random Forest** - capa de explicabilidad para el negocio

Distincion clave: el arbol *explica el modelo*, SHAP *explica el fenomeno*. El dueno del negocio necesita lo segundo.

```python
import shap
explainer = shap.TreeExplainer(rf_model)
shap_values = explainer.shap_values(X_test)
# shap_values es lista [class0, class1] para RF binario
sv_churn = shap_values[1] if isinstance(shap_values, list) else shap_values[:, :, 1]
shap.summary_plot(sv_churn, X_test)   # drivers globales de churn
```

Visualizaciones para presentacion: summary plot (global), bar plot (audiencia no tecnica), waterfall plot (caso concreto de accion).

## Resultados del modelado (run 2026-06-08, test set 1126 filas)

| Modelo | ROC-AUC CV | ROC-AUC test | Recall test | F1 test |
|---|---|---|---|---|
| DT baseline (class_weight=balanced) | 0.8715 | - | - | - |
| DT optimizado | 0.9115 | 0.9415 | 77.9% | 77.9% |
| RF optimizado | 0.9791 | 0.9976 | 96.3% | 93.4% |

Mejores params RF: `n_estimators=200, max_depth=None, min_samples_leaf=1, max_features='sqrt', class_weight='balanced'`
Mejores params DT: `max_depth=None, min_samples_leaf=1, min_samples_split=10, class_weight=None`

## Threshold tuning para maximizar recall

Con ROC-AUC 0.9976 la separabilidad es excelente; el unico lever es el umbral. Tabla de tradeoffs (190 churners en test):

| Umbral | Recall | Precision | Churners detectados | Falsos positivos |
|---|---|---|---|---|
| 0.30 | 100% | 69.3% | 190/190 | 84 |
| 0.35 | 100% | 78.2% | 190/190 | 53 |
| 0.40 | 98.9% | 85.1% | 188/190 | 33 |
| **0.465** (F2-optimo) | **98.4%** | **89.5%** | **187/190** | **22** |
| 0.50 (default) | 96.3% | 90.6% | 183/190 | 19 |

Criterio F2 (recall pesa 2x): umbral optimo 0.465. Si el costo de accion de retencion es bajo, usar 0.35 para recall 100%.

```python
from sklearn.metrics import fbeta_score
f2_scores = [fbeta_score(y_test, (y_proba >= t).astype(int), beta=2) for t in thresholds]
optimal_threshold = thresholds[np.argmax(f2_scores)]
y_pred_opt = (y_proba >= optimal_threshold).astype(int)
```

## Workflow del TP

Orden critico -- el split va ANTES del preprocesamiento para evitar leakage:

1. **EDA** - estructura, nulos, distribucion de churn, hipotesis de negocio (LISTO)
2. **Split** - `train_test_split(stratify=y, test_size=0.2, random_state=42)` primero (LISTO)
3. **Preprocesamiento** - imputacion dentro de pipeline, encoding categoricas (OHE) (LISTO)
4. **Baseline** - arbol con parametros default, evaluar con ROC-AUC (LISTO)
5. **Modelo potente** - Random Forest con GridSearchCV (LISTO)
6. **Evaluacion final** - test set, matriz de confusion, recall/precision/F1/AUC-ROC (LISTO)
7. **SHAP analysis** - explicabilidad global y local sobre Random Forest (LISTO)
8. **Threshold tuning** - optimizar umbral segun costo de negocio (LISTO)

La imputacion del notebook de limpieza sirve para EDA solamente. Para modelado, la imputacion debe ir dentro de un Pipeline despues del split (Decision 5).

## Venv y dependencias

El venv esta en `REPO/.venv/`. Para activar y correr los notebooks:
```bash
# instalar dependencias (una sola vez)
.venv/bin/pip install -r requirements.txt

# correr jupyter
.venv/bin/jupyter lab
```

`shap` se agrego a `requirements.txt` el 2026-06-08. Si el equipo clona el repo, necesita correr `pip install -r requirements.txt` para tenerlo.

### Herramienta obligatoria: grill-me
Ante cualquier concepto dudoso del TP usar `/grill-me`. Conceptos que la catedra va a preguntar: churn, class imbalance, leakage, train/test split, stratified, baseline, recall vs precision, SHAP values.

## Referencia rapida de hiperparametros

```python
# Decision Tree (160 combinaciones)
dt_params = {
    'max_depth': [3, 5, 7, 10, None],
    'min_samples_leaf': [1, 5, 10, 20],
    'min_samples_split': [2, 5, 10, 20],
    'class_weight': [None, 'balanced'],
}

# Random Forest (48 combinaciones)
rf_params = {
    'n_estimators': [100, 200],
    'max_depth': [5, 10, 20, None],
    'min_samples_leaf': [1, 5, 10],
    'max_features': ['sqrt'],
    'class_weight': ['balanced', 'balanced_subsample'],
}

grid = GridSearchCV(
    estimator,
    params,
    cv=StratifiedKFold(n_splits=5, shuffle=True, random_state=42),
    scoring='roc_auc',
    n_jobs=-1,
)
```

## Aprendizajes clave de SIA TP2

Extraidos del summary en SIA_SUMMARIES:
- Arbol con `max_depth=2` sirve como baseline explicativo (sin necesitar train/test)
- GridSearch en 2 rondas: primera amplia, segunda fina alrededor del mejor resultado
- `plot_tree` con `dpi=300` para visualizaciones legibles
- Random Forest no siempre supera al arbol simple con datasets chicos

## Formato de respuesta al usuario

- Hablar en espanol
- Sin tildes en nombres de archivos y codigo (para evitar problemas de encoding)
- Ser conciso en los archivos `.md`: concepto + razonamiento, sin relleno
