---
version: 0.4.0
name: hf-mai
description: |
  Generate images of Kitano Mai, the AI influencer character.
  Use when: generating new content for Mai, placing her in a
  new scene, outfit, or pose, iterating on her face/look, or
  training Soul ID. Covers model selection, CLI patterns,
  approved references, and lessons learned.
argument-hint: "[scene or content description]"
allowed-tools: Bash
---

# Kitano Mai — Higgsfield Generation Skill

AI influencer project. All assets live at `/home/berni/Desktop/Dev/kitano-mai/`.

## Character Identity

**Name:** Kitano Mai (北野 麻衣)
**Age:** 19-20, gap year, half Japanese half Argentine (haafu)
**Style:** Japanese 清楚 (seiso) — clean, modest, feminine

**Core references — always use these, never the old generated/ files:**

| File | Upload ID | Use for | Priority |
|---|---|---|---|
| `core/mai-headphones-canvas-perfect.png` | `ce162aa4-e5f6-4e64-8fdf-060705ed3e14` | PRIMARY identity ref — dramatic light, natural face in context | ★★★ |
| `core/mai-headphones-seedream.png` | `e816a5c7-69f0-49c8-8f81-2d47cfcaf731` | SECONDARY identity ref — extreme close-up, moles clearly visible | ★★★ |
| `core/mai-portrait-closed-gpt2.jpg` | `b0d7d911-e340-4810-aa5f-2fe0cf5ae5cb` | **MOST REALISTIC** — closed mouth, moody light, use as second ref for natural aesthetic scenes | ★★★ |
| `core/mai-portrait-closed-nano.jpg` | `48c83625-fd24-427f-bdd4-5b3ad7741c9f` | Closed mouth, warm side light, slightly wider framing — good for outdoor/daylight scenes | ★★ |
| `core/mai-portrait-closed-seedream.jpg` | `35a87d79-c857-4df1-a5d2-e9af72d9ec29` | Closed mouth, extreme close-up, natural texture — best for skin/face detail shots | ★★ |
| `core/mai-face-portrait.png` | `9900fc9b-3c86-4067-befb-27dc87834797` | Avoid as scene ref — too literal, produces face-swap look | ✗ |

**When to use the closed-mouth portraits as second ref:**
- Any scene where you want natural, non-AI-looking output — add as ref 2 alongside the headphones canvas
- The closed-mouth aesthetic pulls output away from AI polish toward real photography texture
- `mai-portrait-closed-gpt2.jpg` confirmed most photorealistic, use it by default for this purpose

**Why the headphones shots are better refs than the portrait:**
- The face exists in real light and context — not isolated
- Produces natural integration when used as identity ref in scene swaps
- The portrait is too "clean" — generators copy it too literally, creating uncanny face-paste results
- Use the portrait only for Soul ID training, not as a scene generation reference

**Confirmed features — must appear in every generation:**

**Eyes:**
- Large, wide-set (more spacing between them than average)
- Full natural double eyelids
- Warm dark brown iris
- **涙袋 (namida bukuro) — prominent and puffy under both eyes. Non-negotiable.**

**Nose:**
- High straight haafu nose bridge, elevated and casting a visible shadow
- Soft rounded tip
- Mixed-heritage — more defined than purely Japanese, not Western-sharp

**Lips:** Full, naturally pink, slightly parted at rest

**Beauty marks — exact positions:**
```
[ her LEFT eye ]              [ her RIGHT eye ]
      ●  ← dot UNDER her LEFT lower eyelid, below the 涙袋

          [ nose bridge ]
               ·  ← small dot near TOP of bridge, slightly left of center

  [ her RIGHT side of nose ] = viewer's LEFT side
          ●●  ← two moles close together, mid-nose height,
                near nose-cheek junction on HER right
```

1. **Nose bridge dot** — upper bridge, near the inter-eye space, slightly left of center
2. **Twin moles** — her RIGHT side of nose, close together, mid-height near cheek
3. **Under-eye dot** — below her LEFT lower eyelid, just under the tear bag

**Hair:** Dark brown (near black), straight, slightly past shoulders, wispy straight-cut bangs just above eyebrows, slightly parted in the middle

**Skin:** Fair, luminous, natural texture — not airbrushed

**Prompt anchor — always read `/home/berni/Desktop/Dev/kitano-mai/appearance.md` and paste the full "Image Generation Reference" block (line ~111) verbatim into every generation prompt.** Do not summarize or paraphrase it — use it word for word. This ensures all features including exact beauty mark positions are passed to the generator.

The block ends with: `Photorealistic, natural light, no filters, no retouching.`

**Beauty mark clarification for prompts:** The nose bridge mole is ON THE NOSE ITSELF (on the bridge of the nose, not the forehead or glabella). Always specify: "small mole on the nose bridge — on the nose itself, not the forehead". Generators frequently place it on the forehead otherwise.

---

## Project Structure

```
/home/berni/Desktop/Dev/kitano-mai/
  references/          # source references (Yuzu, body, gamergirl, etc.)
  generated/           # all AI outputs, named YYYYMMDD_label.png
  prompts.md           # full generation log with prompts + URLs
  generate.sh          # CLI wrapper: ./generate.sh "label" "prompt"
  identity.md          # character backstory, personality, content pillars
  appearance.md        # detailed physical description + image gen prompt
```

---

## Model Selection

| Use case | Model | Quality |
|---|---|---|
| **FINALS — professional, social-media ready** | `nano_banana_2` in Canvas | ★★★★★ |
| **Most photorealistic portrait / natural look** | `imagegen_2_0` (GPT Image 2) | ★★★★★ |
| **Exploration — face only, creative headphones/scene** | `seedream_v4_5` with 1 ref (face) | ★★★★ |
| **Faithful scene swap — copies both refs closely** | `seedream_v4_5` with 2 refs (face + scene) | ★★★ realistic but rough |
| Face portrait iteration (loose) | `text2image_soul_v2` + `--image` | ★★ drifts every generation |
| Locked identity | `text2image_soul_v2` + `--soul-id` | ★★★★★ (not yet trained) |
| Cinematic / video | `soul_cinema_studio` | — chain with Soul ID |

### Model behavior breakdown (confirmed from outputs)

**Nano Banana 2 (Canvas) — use for finals**
- Most professional, polished result
- Adds creative realistic details not in the reference (imagined AirPods Pro Max on a reference that didn't even have them)
- Best social-media quality — looks like a real photo shoot
- Use in Canvas with face ref + scene ref

**Seedream 4.5 with 1 reference (face only) — use for exploration**
- Insanely good results when given just the face and a scene description in text
- Creative, fills in scene details intelligently
- More natural than the two-ref approach

**Seedream 4.5 with 2 references (face + scene) — use when you need exact fidelity**
- Faithful to both references — copies them closely
- Slightly rough/literal — what you give it is what you get
- Still realistic, still usable
- Best when the scene reference has very specific elements you need to preserve exactly

**GPT Image 2 (`imagegen_2_0`) — most photorealistic portraits**
- Produces the most natural, non-AI-looking results for portrait/face shots
- Only accepts a single `--image` ref (not `--input_images` array)
- Use for clean face portraits, core ref generation, or when naturalness matters most
- Confirmed best among seedream/nano/imagegen for realistic skin and face rendering

---

## CLI Patterns

### Single reference (Soul 2.0)
```bash
URL=$(higgsfield generate create text2image_soul_v2 \
  --image path/to/ref.png \
  --prompt "delta description only" \
  --aspect_ratio 3:4 --quality 2k --wait)
curl -sL "$URL" -o generated/LABEL.png
```

### Two references (Seedream 4.5) — face + scene
```bash
# Upload images first (one-time, save the IDs)
ID1=$(higgsfield upload create face-ref.png --json | jq -r '.id')
ID2=$(higgsfield upload create scene-ref.png --json | jq -r '.id')

URL=$(higgsfield generate create seedream_v4_5 \
  --prompt "use face from first image exactly. place in scene from second image." \
  --input_images "[{\"id\":\"$ID1\",\"type\":\"media_input\"},{\"id\":\"$ID2\",\"type\":\"media_input\"}]" \
  --aspect_ratio 3:4 --quality high --wait)
curl -sL "$URL" -o generated/LABEL.png
```

### GPT Image 2 (`imagegen_2_0`) — single ref only
```bash
URL=$(higgsfield generate create imagegen_2_0 \
  --image ce162aa4-e5f6-4e64-8fdf-060705ed3e14 \
  --prompt "same face as reference. [description]. photorealistic." \
  --aspect_ratio 3:4 --quality high --wait)
curl -sL "$URL" -o generated/LABEL.png
```

### Nano Banana 2 — note: uses `--resolution` not `--quality`
```bash
URL=$(higgsfield generate create nano_banana_2 \
  --prompt "..." \
  --input_images "[{\"id\":\"$ID1\",\"type\":\"media_input\"},{\"id\":\"$ID2\",\"type\":\"media_input\"}]" \
  --aspect_ratio 3:4 --resolution 2k --wait)
curl -sL "$URL" -o generated/LABEL.png
```

### Parallel jobs — correct pattern (subshell vars don't propagate)
```bash
# Fire all jobs, save IDs to temp files
higgsfield generate create seedream_v4_5 --prompt "..." --json 2>&1 | jq -r '.[0]' > /tmp/job1.txt &
higgsfield generate create imagegen_2_0  --prompt "..." --json 2>&1 | jq -r '.[0]' > /tmp/job2.txt &
wait
# Wait for results
URL1=$(higgsfield generate wait $(cat /tmp/job1.txt) --json 2>&1 | jq -r '.result_url')
URL2=$(higgsfield generate wait $(cat /tmp/job2.txt) --json 2>&1 | jq -r '.result_url')
```

### Via generate.sh wrapper
```bash
cd /home/berni/Desktop/Dev/kitano-mai
./generate.sh "label" "prompt"   # saves + logs automatically
```

---

## Saved Upload IDs

| File | Upload ID | Notes |
|---|---|---|
| `core/mai-face-portrait.png` | `9900fc9b-3c86-4067-befb-27dc87834797` | PRIMARY — use as identity ref in all generations |
| `core/mai-headphones-seedream.png` | `e816a5c7-69f0-49c8-8f81-2d47cfcaf731` | Close-up face + headphones, dramatic light |
| `core/mai-headphones-canvas-perfect.png` | `ce162aa4-e5f6-4e64-8fdf-060705ed3e14` | Best quality output to date |
| `references/gamergirl.png` | `1568996e-c67a-497d-8522-313502b5af87` | Pose/scene reference for headphones content |
| `generated/20260603_face-mai-BEST-canvas-v1.png` | `d6955ea2-9dc3-4649-b679-85cd0f70a8c4` | Old ref, superseded by core/ |
| `core/mai-portrait-closed-gpt2.jpg` | `b0d7d911-e340-4810-aa5f-2fe0cf5ae5cb` | MOST REALISTIC portrait — use as 2nd ref for natural aesthetic |
| `core/mai-portrait-closed-nano.jpg` | `48c83625-fd24-427f-bdd4-5b3ad7741c9f` | Closed mouth, warm side light |
| `core/mai-portrait-closed-seedream.jpg` | `35a87d79-c857-4df1-a5d2-e9af72d9ec29` | Closed mouth, extreme close-up |
| `references/argentina/barrio-chino-mon.jpg` | `6e008bd6-5639-46c0-a20a-ee83a96b8e85` | Barrio Chino gate — real person scene ref, no NSFW issues |
| `generated/20260603_mai-bathroom-gpt2-v2.png` | `dd1c7b0d-6cd4-4541-91d0-725dd6e8b5f1` | Bathroom Argentina shirt — correct watch orientation |

---

## Key Lessons

1. **`--image` on Soul 2.0 is not identity-locking.** It influences loosely. Every generation looks like a different person. Only Soul ID locks the face.

2. **Soul ID needs 8-12 clean training photos** — varied angles, no costume, no heavy filters. We don't have these yet for Mai.

3. **The Influencer Studio doesn't match a specific face.** It's for generic archetypes, not recreating a specific look.

4. **Seedream 4.5 `input_images` accepts multiple refs** via `[{"id": "uuid", "type": "media_input"}]` array. The type field must be `media_input` (not `image`).

5. **Three tiers of output quality confirmed:**
   - Nano Banana 2 (Canvas) = most professional, adds creative details, PERFECT for finals
   - Seedream with 1 ref = insanely good creative result, best for exploration
   - Seedream with 2 refs = faithful/literal, slightly rough, good when exact scene fidelity matters

6. **Long prompts compete with the reference image and cause drift.** For face consistency, keep the prompt minimal — only describe what changes from the reference.

7. **Approved face:** `canvas-mainobesutoichimai.png` from Canvas generation. Has the right eyes, moles, 涙袋, and haafu nose. This is the canonical Mai reference.

8. **Next milestone:** Generate 8-10 clean face shots (no costume, varied angles) from the approved face → train Soul ID → all content locked to that identity.

10. **Fire multiple jobs in parallel by omitting `--wait`, then wait for all job IDs at once.** The CLI has no native batch flag, but launching N jobs without `--wait` queues them all server-side simultaneously. Pattern:
   ```bash
   ID1=$(higgsfield generate create <model> --prompt "..." --json 2>&1 | jq -r '.[0]') &
   ID2=$(higgsfield generate create <model> --prompt "..." --json 2>&1 | jq -r '.[0]') &
   wait
   # then wait for results in parallel
   higgsfield generate wait $ID1 --json &
   higgsfield generate wait $ID2 --json &
   wait
   ```
   Or inline without capturing IDs: fire all creates, grab IDs from output, then `higgsfield generate wait <id> --json &` for each, then `wait`. Total wall time = slowest single job, not sum of all.

11. **Mai's appearance always takes priority over the reference scene image.** The reference provides pose, background, framing, and lighting context only. Mai's face, hair (curtain bangs 2cm below eyebrows, dark brown), beauty marks, eyes, and skin must be reproduced from appearance.md — never let the reference person's features bleed through. In the prompt, state her appearance FIRST, then describe what to take from the reference.

12. **Never use Flux Kontext for touch-up edits on existing generated images.** It degrades image quality significantly ("deep fries" the result). For targeted fixes (watch angle, phone color, etc.), regenerate from scratch with the original model and correct the description in the prompt instead.

13. **`imagegen_2_0` (GPT Image 2) is the best model for scene swaps — not just portraits.** Confirmed across Obelisco and Ateneo shots: GPT2 perfectly preserves scene composition, real photography aesthetic, and lighting. Seedream produces visibly AI-looking results for scene swaps. Default to GPT2 for any "place Mai in this photo" request. Use seedream only when you need to anchor her face more prominently in frame.

**`imagegen_2_0` (GPT Image 2) produces the most photorealistic portraits.** Confirmed best for natural face/portrait generations. Only accepts single `--image`, not `--input_images`. Use when naturalness is the priority.

**`imagegen_2_0` acepta `--resolution 1k/2k` ademas de `--quality`.** `--quality high` sin `--resolution` puede output 2k (mas caro). Para 1024x1024: usar `--quality high --resolution 1k`. NUNCA hacer test runs para verificar params — cuesta creditos. Usar `higgsfield model get imagegen_2_0` para inspeccionar schema.

14. **`nano_banana_2` uses `--resolution` (not `--quality`).** Accepted values: `1k`, `2k`, `4k`. Using `--quality` will error.

15. **Anime murals / illustrated figures in scene refs trigger NSFW consistently.** The model interprets drawn characters as potentially sensitive. Always use real person photos as scene references for populated scenes. A photo of a real person at the same location works fine.

19. **Always use the full verbatim beauty marks description from appearance.md in GPT2 prompts — never shorten it.** Shortened versions ("beauty marks: dot on nose bridge, two moles right side") cause mole positions to drift slightly. The full block: "small dot on upper nose bridge slightly left of center, two small moles close together on her right side of the nose near the cheek junction, small dot just below her left lower eyelid." Also always add: "nose bridge dot is ON THE NOSE BRIDGE ITSELF — not the forehead."

16. **Product flat shots (watch on white bg, jersey on hanger) cause wrong orientation when used as refs.** The model copies the display orientation literally — a vertical product shot becomes a vertically-strapped watch on the wrist. Instead: describe the item in text, or use an image that shows it worn/in-context as the reference.

17. **A natural aesthetic portrait as 2nd ref dramatically improves realism.** Pairing headphones canvas (face identity) + closed-mouth portrait (aesthetic anchor) produces far more natural output than headphones canvas alone. The 2nd ref sets the photographic style, grain, and skin texture.

18. **For parallel job launches, save IDs to temp files — don't use subshell variable assignment.** Background subshells (`VAR=$(cmd) &`) don't propagate vars to parent shell. Use `cmd | jq ... > /tmp/id.txt &` then `wait`, then read with `$(cat /tmp/id.txt)`.

9. **When asked to edit or re-create an existing shot (e.g. "same pose but no headphones", "same framing but different expression"), preserve the original context exactly:** same background, same lighting color/direction, same framing/crop, same outfit, same camera angle and distance. Only change what was explicitly requested. Using Seedream with a fresh text prompt drifts the context -- prefer Flux Kontext for targeted object removal/changes on existing images, or use the original image as a second reference to anchor the scene.

---

## Standard Generation Workflow

For any new content request, follow this decision path:

### 1. Exploration / draft (CLI, Seedream + 1 core ref)
```bash
URL=$(higgsfield generate create seedream_v4_5 \
  --prompt "same face as reference. [scene description]. photorealistic." \
  --input_images "[{\"id\":\"9900fc9b-3c86-4067-befb-27dc87834797\",\"type\":\"media_input\"}]" \
  --aspect_ratio 9:16 --quality high --wait)
curl -sL "$URL" -o projects/PROJECTNAME/generated/YYYYMMDD_label.png
```

### 2. Scene swap / pose match (CLI, Seedream + 2 refs)
```bash
# face ref = core portrait, pose ref = upload the scene image first
ID_SCENE=$(higgsfield upload create projects/PROJECTNAME/references/scene.png --json | jq -r '.id')
URL=$(higgsfield generate create seedream_v4_5 \
  --prompt "face from first image exactly. place in scene from second image. keep moody aesthetic." \
  --input_images "[{\"id\":\"9900fc9b-3c86-4067-befb-27dc87834797\",\"type\":\"media_input\"},{\"id\":\"$ID_SCENE\",\"type\":\"media_input\"}]" \
  --aspect_ratio 9:16 --quality high --wait)
curl -sL "$URL" -o projects/PROJECTNAME/generated/YYYYMMDD_label.png
```

### 3. Final content (Canvas, Nano Banana 2)
- Load `core/mai-face-portrait.png` as identity ref
- Load scene/pose reference
- Model: Nano Banana 2
- Prompt: face anchor + scene description (see Canvas Workflow below)

---

## Canvas Workflow (recommended for finals)

1. Open Higgsfield Canvas
2. Add `projects/profile/generated/20260603_face-mai-BEST-canvas-v1.png` as character/identity reference
3. Add scene/pose reference image
4. Use this prompt structure:
```
use the face from the first image exactly — same large wide-set brown eyes, 涙袋,
mole on nose bridge, wispy bangs, fair luminous skin, full lips.
Place her in the pose and scene from the second image: same [outfit/setting/framing].
Keep the [aesthetic description]. Photorealistic, no filters.
```
5. Model: Nano Banana 2 for final quality

---

## Generation Logging — MANDATORY

**Every generation attempt (successful or not) must be logged to the project's GENERATIONS.md.**

### Project structure

All work lives under `projects/<project-name>/`:
```
projects/
  dance/
    generated/        # output videos/images
    references/       # source refs specific to this project
    GENERATIONS.md    # generation log (always update this)
  bathroom/           # same structure
  obelisco/
  ateneo/
  barriochino/
  bunnygirl/
  glasses/
  headphones/
  profile/
  sunkissed/
core/                 # global identity refs — never move or overwrite
fails/                # failed experiments
references/           # global references (accessories, places, misc)
```

### GENERATIONS.md entry format

Add an entry for every attempt, even failures and NSFW blocks:

```markdown
## YYYY-MM-DD — label (model name)

**File:** `generated/filename.ext` (or "blocked — NSFW" / "not saved")
**Tool:** Higgsfield / Kling / Viggle / etc.
**Model:** model_name
**References used:** list refs
**Prompt:**
[full prompt verbatim]

**Quality:** X/5

**What was good:**
- bullet points

**What was bad:**
- bullet points

**Lessons:**
- actionable takeaways for future attempts
```

**Rules:**
- Log failures and NSFW blocks with the reason and open questions
- If a generation is "not yet reviewed", mark it and fill in later — do not skip the entry
- After every session, check that every output file in `generated/` has a corresponding log entry
- Save output files as `YYYYMMDD_label.ext` inside `projects/<project>/generated/`
