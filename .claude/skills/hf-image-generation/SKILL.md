---
version: 0.1.0
name: hf-image-generation
description: |
  Generate illustrations, stickers, and graphic design assets via
  Higgsfield imagegen_2_0 (GPT Image 2). Use for: Tech Trek stickers,
  brand illustrations, flat vector designs, logo-anchored compositions.
  NOT for: character/face generation (use hf-mai), video (use higgsfield-generate).
argument-hint: "[description of sticker or illustration]"
allowed-tools: Bash
---

# Higgsfield Image Generation — Stickers & Illustrations

Genera imagenes de diseno grafico (stickers, ilustraciones, brand assets) usando `imagegen_2_0` con la CLI de Higgsfield.

---

## Modelo principal: `imagegen_2_0` (GPT Image 2)

El mejor modelo para diseno grafico plano, stickers, ilustraciones con logos de referencia.

### Parametros clave

```bash
higgsfield generate create imagegen_2_0 \
  --image "<upload_id_o_path>" \
  --prompt "..." \
  --aspect_ratio 1:1 \
  --quality high \
  --resolution 1k \
  --wait
```

| Parametro | Valores | Notas |
|---|---|---|
| `--quality` | `medium`, `high` | `high` sin `--resolution` puede dar 2k (mas caro) |
| `--resolution` | `1k`, `2k` | Usar `1k` para mantener 1024x1024 sin subir costo |
| `--aspect_ratio` | `1:1`, `16:9`, etc. | `1:1` para stickers circulares |
| `--image` | UUID o path local | Acepta un solo ref de imagen |

**Regla critica:** `--quality high --resolution 1k` = alta calidad a 1024x1024.
`--quality high` solo puede output 2k y cuesta mas.

---

## Workflow: sticker con logo de referencia

```bash
# 1. Subir el logo de referencia (solo si no tiene ID guardado)
LOGO_ID=$(higgsfield upload create "/path/to/logo.png" --json | jq -r '.id')
echo "Logo ID: $LOGO_ID"

# 2. Generar
higgsfield generate create imagegen_2_0 \
  --image "$LOGO_ID" \
  --prompt "..." \
  --aspect_ratio 1:1 --quality high --resolution 1k \
  --json 2>&1 | jq -r '.[0]' > /tmp/job_id.txt

echo "Job ID: $(cat /tmp/job_id.txt)"

# 3. Esperar y descargar
URL=$(higgsfield generate wait $(cat /tmp/job_id.txt) --json 2>&1 | jq -r '.result_url')
curl -sL "$URL" -o "/path/to/output/YYYYMMDD_label.png"
echo "Saved."
```

### Patron paralelo (multiples variantes)

```bash
higgsfield generate create imagegen_2_0 --image "$ID" --prompt "..." --json 2>&1 | jq -r '.[0]' > /tmp/job1.txt &
higgsfield generate create imagegen_2_0 --image "$ID" --prompt "..." --json 2>&1 | jq -r '.[0]' > /tmp/job2.txt &
wait

URL1=$(higgsfield generate wait $(cat /tmp/job1.txt) --json 2>&1 | jq -r '.result_url')
URL2=$(higgsfield generate wait $(cat /tmp/job2.txt) --json 2>&1 | jq -r '.result_url')
curl -sL "$URL1" -o /tmp/v1.png
curl -sL "$URL2" -o /tmp/v2.png
```

---

## Tech Trek — Assets

### Logo de TT subido

| Archivo | Upload ID |
|---|---|
| `Tech Trek Logo-02.png` (blanco sobre transparente) | `0e50ae79-6503-400b-93dd-fba7dd569dfd` |

Path local: `/home/berni/Desktop/Facultad/TechTrek/00 - Images/Tech Trek Logo-02.png`

### Carpeta de stickers

```
/home/berni/Desktop/Facultad/TechTrek/Stickers/
```

Convencion de nombres: `YYYYMMDD_sticker-<label>-v<n>.png`

### Stickers generados (2026-06-04)

| Archivo | Descripcion | Estado |
|---|---|---|
| `20260604_sticker-founders-fuel-mate.png` | Mate circular amarillo, "FOUNDERS FUEL" | Aprobado |
| `20260604_sticker-hockey-stick-v1.png` | Palo de hockey real sobre bar chart de stocks | Aprobado |
| `20260604_sticker-thinkit-shipit-v1.png` | Logo TT con avion saliendo y creciendo a la derecha | Aprobado (PREFERRED sobre v2) |
| `20260604_sticker-thinkit-shipit-v2.png` | Igual pero high quality — logo menos definido | Descartado |

---

## Prompt tips para stickers TT

### Estetica TT
- `golden yellow filled circle, white line art, thick white double-ring border, pure white background outside`
- Siempre especificar `No text` — el usuario agrega texto en Canva despues

### Para disenos dinamicos (avion, cohete, movimiento)
- `hard black drop shadows underneath`
- `bold thick black outlines`
- `comic/pop art style`
- `bold flat colors, no gradients`

### Composicion dentro del circulo
- Especificar `LEFT SIDE` / `RIGHT SIDE` / `lower-left corner` para guiar la composicion
- Para escenas horizontales: el formato es 1:1 pero la composicion va de izquierda a derecha

### Referencia de logo en el prompt
Cuando el logo de TT esta como `--image`, describir en el prompt:
> "Match the exact visual style of the reference: golden yellow filled circle, white line art illustration, thick white double-ring border"

Para que el avion "salga" del logo:
> "The airplane from inside the logo BREAKS OUT and flies toward the RIGHT SIDE, growing progressively larger as it moves right"

---

## Lecciones aprendidas

1. **NUNCA hacer test runs para verificar parametros.** Cada generacion cuesta creditos. Usar `higgsfield model get <model>` para inspeccionar schema sin costo.

2. **`--quality high` sin `--resolution` puede salir 2k.** Siempre especificar `--resolution 1k` para mantener 1024x1024.

3. **v1 (medium quality) puede superar a v2 (high quality)** cuando la fidelidad al logo de referencia importa. Mayor calidad no siempre = mejor resultado para composiciones con logos.

4. **`imagegen_2_0` acepta solo UN `--image`** (no `--input_images` array). Si se necesitan dos refs, usar `seedream_v4_5`.

5. **El trail de color** (blanco cerca del logo → amarillo con borde negro afuera) se logra describiendolo explicitamente en el prompt: `"trail: thin and white near the logo, then widening and turning golden yellow with bold black outline"`.

6. **Sombras duras negras** (`hard black drop shadows`) dan el estilo pop art / comic que funciona para stickers de marca.

7. **Para verificar parametros de un modelo:** `higgsfield model get imagegen_2_0 --json`
