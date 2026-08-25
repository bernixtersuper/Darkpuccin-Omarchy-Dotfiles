---
name: tt-simon
description: >
  Skill para trabajar en TT Simon, el juego Simon Says de Tech Trek para ITBA Future Day 2026.
  Usar cuando el usuario quiera agregar features, arreglar bugs, cambiar estilos, tocar la
  lógica del juego, la leaderboard, los sonidos, o el layout del sitio.
---

# TT Simon — Skill de proyecto

## Rutas clave

```
REPO     = /home/berni/Desktop/Dev/tt-simon/
DEPLOY   = https://tt-simon.vercel.app  (o el dominio que se asigne)
TT WEB   = https://techtrek-web.vercel.app
```

## Stack técnico

- **Framework:** Next.js 16.2.6 (App Router, RSC + Client Components)
- **DB:** Neon Postgres (serverless) + Drizzle ORM
- **UI:** Tailwind CSS v4 + Framer Motion
- **Fuentes:** Syne (headings, `var(--font-syne)`) + Inter (body, `var(--font-inter)`)
- **Audio:** Web Audio API (síntesis de tonos, sin archivos externos)
- **Deploy:** Vercel (env var: `DATABASE_URL`)
- **Sin auth** — público, cualquiera puede jugar

## Estructura del proyecto

```
app/
  layout.tsx                  # fonts Syne + Inter, metadata + KeyboardHintsProvider wrapper
  page.tsx                    # server component, fetch inicial de leaderboard (top 20)
  globals.css                 # mismos estilos base que techtrek-web (btn-gold, scrollbar, etc.)
  api/
    leaderboard/
      route.ts                # GET top 20, POST nuevo score → devuelve {id, position, entries}

components/
  Nav.tsx                     # logo TT + botones ⚡ hard y ⌨ teclas + link a techtrek-web
  SimonGame.tsx               # orchestrador principal (client component, ~700 líneas)
  Leaderboard.tsx             # tabla de ranking reutilizable (muestra ⚡ en scores de hard mode)
  TTEvents.tsx                # panel izquierdo desktop con cards de eventos de TT
  KeyboardHintsProvider.tsx   # context de settings del juego: hints + hardMode

db/
  schema.ts                   # tabla leaderboard: id, name(20), email, score, hard_mode, created_at
  index.ts                    # conexión Neon + drizzle
  migrate.ts                  # CREATE TABLE + ALTER TABLE hard_mode + índice

lib/
  simon.ts                    # constantes del juego, sonidos, velocidades, mensajes multilingüe
```

## Schema de la DB

```typescript
leaderboard: id, name (VARCHAR 20), email (VARCHAR 255, nullable), score (INTEGER), hardMode (BOOLEAN default false), created_at
```

## Lógica del juego

### State machine (dentro de SimonGame.tsx)

```
'idle' → startGame() → gameLoop() async:
  while (!cancelled):
    extender secuencia
    fase 'showing': mostrar botones uno a uno con sonido
    fase 'player':  esperar inputs del usuario con timer por botón (non-blocking feedback)
    si correcto: score++ → siguiente ronda
    si error/timeout: fase 'gameover' → submitScore()
```

### Velocidades

| Parámetro   | Speed A (score ≤ 3) | Speed B (techo) |
|-------------|---------------------|-----------------|
| flashMs     | 820 ms              | 180 ms          |
| gapMs       | 230 ms              | 50 ms           |
| timerMs     | 5000 ms             | 1800 ms         |

Curva **exponencial** desde score 3: `t = 1 - e^(-0.3 * (score - 3))` via `getSpeed(score)` en `lib/simon.ts`.
El techo se alcanza prácticamente en score ~13. Hard mode usa SPEED_B desde el primer round.

### Input del jugador — non-blocking feedback

Después de cada press correcto, la animación del botón corre via `setTimeout` (non-blocking). Un `litGenRef` de generación previene que un clear stale borre el botón nuevo:

```typescript
const gen = ++litGenRef.current;
setLitButton(input);
playButton(input, pressDuration);
setTimeout(() => { if (litGenRef.current === gen) setLitButton(null); }, pressDuration);
// No await — el loop avanza inmediatamente al siguiente botón
```

Al inicio de la fase showing, `litGenRef.current++` invalida cualquier pending clear de la fase player.

### Teclado

Teclas: **Q** = verde, **E** = rojo, **A** = amarillo, **D** = azul (layout 2×2 en QWERTY).
Hints (letras en cada botón) controlados por `useKeyboardHints().hints`.

### Botones y sonidos (Web Audio API)

| Botón  | Frecuencia | Border-radius CSS   |
|--------|-----------|---------------------|
| green  | 415 Hz    | `100% 0 0 0`        |
| red    | 310 Hz    | `0 100% 0 0`        |
| yellow | 252 Hz    | `0 0 0 100%`        |
| blue   | 209 Hz    | `0 0 100% 0`        |

Glow: radial-gradient con origen en la esquina interior (hacia el centro del tablero).
Reposo: `rgba(color, 0.22)`. Encendido: gradiente + box-shadow.
Error sound: onda sawtooth 160 Hz → 80 Hz en 0.7s.

### Timer visual

- Barra bajo el tablero que drena de lleno a vacío
- Color: dorado (`#eec416`) > 50%, naranja (`#f97316`) 25–50%, rojo (`#ef4444`) < 25%
- Durante fase `showing`: muestra mensajes multilingüe random en lugar del timer
- El timer es por botón, arranca inmediatamente después de aceptar el input anterior

### Mensajes multilingüe (fase showing)

Array `SHOWING_MESSAGES` en `lib/simon.ts`. Incluye: ES, JP, ZH, EN, PT, RU, IT, SV, TH, KO, DE, FR.

## Context: KeyboardHintsProvider

Envuelve toda la app en `layout.tsx`. Expone:
- `hints` / `toggleHints` — muestra/oculta las letras de teclado en cada botón
- `hardMode` / `toggleHardMode` — fuerza SPEED_B desde el primer round; se guarda en DB al terminar

Importar con `useKeyboardHints()` (alias de `useGameSettings()`).

## Leaderboard

- Top 20 entradas ordenadas por `score DESC, created_at ASC` (empates: el primero en llegar gana)
- **Posición = fila exacta**: `COUNT(*) WHERE score > mio OR (score = mio AND created_at < mio)` + 1
- Polling cada 15s en el cliente
- Scores de hard mode muestran ⚡ junto al nombre
- Mostrada a la derecha del Simon en desktop; debajo en mobile (siempre visible, dimmed durante el juego)

## Game over screen

- **#1**: mensaje gold "¡[NAME] se adelanta y roba el primer puesto!" + 🥇
- **#2**: mensaje silver + 🥈
- **#3**: mensaje bronze + 🥉
- **#4+**: tabla de contexto (2 filas arriba + fila del usuario resaltada en dorado + 2 filas abajo)
- Mismo layout de 3 columnas que la pantalla del juego (TTEvents sticky izq., resultado centrado, leaderboard sticky der.)

## Layout desktop (3 columnas) — tanto en juego como en game over

```
[TTEvents: w-64 sticky]   [contenido centrado: flex-1]   [Leaderboard: w-64 sticky]
```

- `max-w-7xl`, `px-10`, `gap-16`

## Layout mobile

```
[Simon / game over content — full width]
[Leaderboard (top 20, scroll para ver)]
[TTEvents (3 cards de eventos)]
```

Leaderboard y eventos se dimmean durante el juego activo (`opacity-30 pointer-events-none`).

## TTEvents (panel izquierdo)

3 cards: TT Hub, TT Visits, TT Talks — foto real, tag translúcido dorado, número grande, descripción.
Links: `/events/hub`, `/events/visits`, `/events/talks` en techtrek-web.vercel.app.
Imágenes copiadas en `public/images/`.

## Estética (igual a techtrek-web y tt-crm)

- Fondo `#0d0d0d`, cards `#111`, inputs `#111`
- Acento dorado `#eec416` (hover: `#f5d038`)
- Borders `#1f1f1f`
- Headings: Syne uppercase + tracking-widest
- Botones primarios: `btn-gold` + `rounded-full` + `bg-[#eec416] text-black`
- Sin box-shadows, border-color para depth

## Comandos útiles

```bash
npm run dev          # desarrollo local
npm run db:migrate   # migrar tabla (requiere .env.local con DATABASE_URL)
node_modules/.bin/tsc --noEmit --project tsconfig.json  # typecheck
vercel deploy        # deploy a producción
```

## API

### GET /api/leaderboard
```json
{ "entries": [{ "id": 1, "name": "Berni", "score": 42, "hardMode": false, "createdAt": "..." }] }
```

### POST /api/leaderboard
```json
// Body:    { "name": "Berni", "email": "b@itba.edu.ar", "score": 42, "hardMode": true }
// Returns: { "id": 7, "position": 3, "entries": [...top 20...] }
```

## Bugs conocidos / decisiones de diseño

- `db/index.ts` usa URL placeholder cuando `DATABASE_URL` no está seteado (para evitar crash en dev sin DB)
- `submitScore` siempre hace fallback a `lbEntries` si la API falla o devuelve `entries: undefined`
- El leaderboard context (`useMemo leaderboardCtx`) verifica `Array.isArray(entries)` antes de hacer `findIndex`
- La posición mostrada en game over siempre coincide con la fila visual en el leaderboard (posición exacta)
- `litGenRef` previene que clears stale de animaciones anteriores borren el botón activo

## Orientación inicial

Al invocar este skill, leer en paralelo:
1. `lib/simon.ts` — constantes del juego (velocidades, tonos, mensajes)
2. `components/SimonGame.tsx` — state machine y lógica principal
3. `db/schema.ts` — modelo de datos
