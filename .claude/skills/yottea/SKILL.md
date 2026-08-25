---
name: yottea
description: >
  Skill para trabajar en Yottea, un copiloto de IA para fuerzas de seguridad que permite
  rastrear vehiculos y personas mediante lenguaje natural sobre una red de camaras simulada.
  Usar cuando el usuario mencione Yottea, el demo de Endeavor, el mapa de vehiculos,
  la simulacion de trafico, o quiera agregar decisiones/features al proyecto.
---

# Yottea - AI Copilot for Law Enforcement

## Rutas clave

```
REPO    = /home/berni/Desktop/Dev/yottea/
APP     = /home/berni/Desktop/Dev/yottea/web/
SKILLS  = /home/berni/.claude/skills/yottea/
```

## Orientacion inicial obligatoria

Al invocar este skill, SIEMPRE hacer esto primero (en paralelo):

1. Listar archivos en `REPO` para ver el estado actual del proyecto
2. Leer `REPO/decisions.md` para recordar decisiones tomadas
3. Revisar estructura del codigo: `find APP/src -type f | sort`

Despues de orientarse, reportar al usuario:
- Estado del codigo (que esta construido, que falta)
- Las ultimas decisiones registradas
- Si `APP/public/routes.json` existe (requerido para que la simulacion use calles reales)

## Estructura del repo

```
REPO/
  VISION.md          # concepto del producto y escenario de demo
  PLAN_DEMO.md       # plan de construccion, stack, demo script (actualizado con estado)
  PITCH.md           # argumentos diferenciadores y analisis competitivo
  IDEAS.md           # ideas exploratorias sin compromiso
  FUTURE_PLAN.md     # features descartadas del scope actual (FP-01 a FP-05)
  STACK.md           # stack con justificaciones y comparacion de alternativas
  decisions.md       # decisiones tecnicas y de producto (ultimo: Decision 17)
  web/               # app Next.js
    src/
      app/
        page.tsx     # layout principal (split chat/mapa, singleton engine)
        layout.tsx
        globals.css
      components/
        MapView.tsx  # Maplibre GL + layers: base/highlighted/target + radius circle
        ChatPanel.tsx # chat UI, query engine, respuestas de Yottea
      lib/
        types.ts     # Vehicle, ChatMessage, SearchQuery, Incident
        caba.ts      # CABA_BOUNDS, BARRIOS (30 barrios), randomInCABA
        vehicles.ts  # generateFleet(750) con distribucion realista
        simulation.ts # SimulationEngine: rAF loop, carga routes.json async
        matcher.ts   # parseQuery + filterVehicles (keyword matching + regex)
        yottea.ts    # generadores de mensajes (buildActivationMessage, etc.)
      stores/
        useChatStore.ts    # mensajes del chat, isTyping
        useIncidentStore.ts # highlighted, target, searchRadius, incidentCenter
    public/
      routes.json    # 800 rutas reales sobre calles de CABA (611 KB) - GENERADO
      caba-polygon.json # poligono de la ciudad (1911 vertices) - GENERADO
    scripts/
      generate_routes.py # script Python para regenerar routes.json con osmnx
```

**Diferencia entre IDEAS.md y FUTURE_PLAN.md:**
- `IDEAS.md`: brainstorm libre, sin evaluacion de factibilidad
- `FUTURE_PLAN.md`: features concretas con ID (FP-XX), prerequisitos tecnicos documentados

## Formato de decisions.md

```
## Decision N - Titulo breve

**Fecha:** YYYY-MM-DD

**Que decidimos:** que se decidio.

**Por que:** razonamiento detras de la decision.

**Alternativas descartadas:** opciones evaluadas y no elegidas.

**Consecuencias:** que implica para el resto del proyecto.
```

## Como correr el proyecto

```bash
# Dev server
cd /home/berni/Desktop/Dev/yottea/web
npm run dev -- --port 3030

# Regenerar rutas (si cambia el grafo vial o se necesitan mas)
python3 scripts/generate_routes.py

# Build de produccion
npm run build
```

## Contexto del producto

- **Que es:** copiloto conversacional para fuerzas de seguridad. El operador describe un objetivo en lenguaje natural y Yottea rastrea vehiculos coincidentes, notifica patrullas, y construye un cuadro de situacion.
- **Filosofia:** Yottea amplifica decisiones humanas, no las reemplaza. El operador decide, Yottea multiplica el impacto.
- **Demo target:** Endeavor Experience, 2026-06-11
- **Escenario de demo:** usuario juega a ser operador policial. Incidente inicial pre-cargado (robo de moto Yamaha FZ negra en Villa Crespo). El usuario manda comandos NL y Yottea responde con acciones concretas: marca vehiculos, notifica patrullas, rastrea objetivo.
- **Ciudad:** CABA. 750 vehiculos moviendose por calles reales (grafo OSM via osmnx).
- **Sin APIs de IA:** matching determinista sobre atributos pre-generados. Arquitectura modular para swapear por modelo real en v1.

## Stack real (post-implementacion)

| Capa | Tecnologia | Nota |
|---|---|---|
| Framework | Next.js 16 + TypeScript | |
| Mapa | Maplibre GL JS + react-map-gl v8 | import desde `react-map-gl/maplibre` |
| Tiles | CARTO dark matter (URL publica) | Sin API key, estilo oscuro |
| Rutas | osmnx random walk (Python, offline) | 800 rutas, 611 KB, se commitean |
| Animacion | requestAnimationFrame + @turf/turf | turf.along() para interpolacion sobre ruta |
| Query engine | Keyword matching + regex propio | Sin compromise.js (overhead innecesario) |
| Estado | Zustand v5 | 2 stores: useChatStore, useIncidentStore |
| Estilos | Tailwind CSS v4 | |
| Deploy | Vercel (root dir: `web/`) | |

## Modelo de datos: Vehicle

```typescript
interface Vehicle {
  id: string          // "v0001"
  plate: string       // "AB 123 CD" (formato Mercosur)
  make: string        // "Yamaha", "Ford", etc.
  model: string       // "FZ", "Ranger", etc.
  type: 'auto' | 'moto' | 'camioneta'
  color: string       // "negro", "blanco", etc.
  speedKmh: number
  routeCoords: [number, number][]  // [lng, lat]
  routeLengthKm: number
  progressKm: number  // posicion actual sobre la ruta
  lat: number
  lng: number
  heading: number
  highlighted: boolean
  isTarget: boolean
}
```

## Distribucion del parque automotor simulado (750 vehiculos)

- Autos 70%: VW Gol/Polo, Fiat Cronos/Palio, Renault Sandero/Logan, Peugeot 208, Chevrolet Onix, Toyota Corolla, Ford Ka/Focus, Nissan Versa
- Camionetas/SUVs 15%: Toyota Hilux, Ford Ranger, VW Amarok, Renault Duster, Chevrolet Tracker, Toyota SW4, Jeep Renegade
- Motos 15%: Honda Wave/CB 190, Yamaha FZ/YBR, Bajaj Pulsar/Boxer, Zanella ZR
- Colores: blanco 28%, negro 20%, gris 15%, plata 10%, rojo 8%, azul 7%, resto 12%

## Motor de queries (matcher.ts)

Extraccion de keywords con normalize + listas de sinonimos:
- Color: negro/negra, blanco/blanca, rojo/roja, azul, gris, plata/plateada, etc.
- Marca: yamaha, honda, ford, toyota, chevrolet, volkswagen/vw, renault, peugeot, fiat, etc.
- Modelo: ranger, hilux, fz, ybr, sandero, etc.
- Tipo: moto/motocicleta, camioneta/pickup/4x4/suv, auto/coche
- Radio: "X km" -> radiusKm
- Barrio: cualquiera de los 30 barrios en BARRIOS -> center + radiusKm default 2.5km
- Patente: regex sobre formato Mercosur, acepta wildcards (`AB 4**`)

**Defaults de busqueda (Decision 17):**
- Query con barrio pero sin km: radio 2.5km
- Query sin ninguna ubicacion: centro = `incidentCenter` del store, radio 3km
- Query con km pero sin centro: usar `incidentCenter`

## Capas del mapa (MapView.tsx)

- `vehicles-base`: todos los vehiculos no marcados (circulo, color del vehiculo, ~4px)
- `vehicles-highlighted`: coincidencias de busqueda (cyan #00E5FF, borde blanco, ~7px)
- `vehicles-target`: objetivo activo (rojo #FF3B30, borde naranja, ~10px)
- `radius-fill` + `radius-border`: circulo de busqueda (cyan translucido, borde punteado)

El mapa NO re-renderiza en React en cada frame. El SimulationEngine llama directamente a `map.getSource('vehicles').setData()` en cada tick del rAF.

## Intents del chat (ChatPanel.tsx)

- `search`: busqueda por atributos (default)
- `patrol`: "notificar/alertar patrullas" -> buildPatrolMessage
- `track`: "seguila/rastrear/rastrea" -> buildTrackMessage sobre primer resultado activo
- `clear`: "limpiar/borrar/cancelar" -> clearHighlights

## Incidente inicial pre-cargado

```
Patrulla 07 - Villa Crespo: "Robo de moto en Av. Corrientes y Thames.
Victima describe: moto negra, Yamaha FZ, dos ocupantes, escaparon hacia el norte."
```
`incidentCenter` default: [-58.448, -34.599] (Villa Crespo)

## Estado del proyecto (al 2026-06-09)

- Planificacion: completa (VISION, PLAN_DEMO, PITCH, IDEAS, FUTURE_PLAN, STACK, decisions.md D17)
- App: construida y corriendo
- routes.json: generado (800 rutas reales OSM)
- Bugs conocidos resueltos: agua/edificios, radio filter, default center, speed decimales
- Pendiente: deploy a Vercel, polish UI, demo script rehearsal

## Formato de respuesta al usuario

- Hablar en espanol
- Sin tildes en nombres de archivos y codigo
- Conciso en archivos `.md`: concepto + razonamiento, sin relleno
- Priorizar el demo sobre features
