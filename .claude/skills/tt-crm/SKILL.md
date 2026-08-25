---
name: tt-crm
description: >
  Skill para trabajar en el CRM de Tech Trek 2026. Usar cuando el usuario quiera
  agregar features, arreglar bugs, diseñar la UI, o entender la arquitectura del
  CRM de sponsors y talks. Cubre schema, migraciones, pipeline kanban, auth y dashboard.
---

# TT CRM - Skill de proyecto

## Rutas clave

```
REPO          = /home/berni/Desktop/Dev/tt-crm/
CSV_SPONSORS  = /home/berni/Desktop/Facultad/TechTrek/Programa/Contactos 2026 - Sponsors.csv
CSV_TALKS     = /home/berni/Desktop/Facultad/TechTrek/Programa/Contactos 2026 - Charlas.csv
OBS_CRM       = /home/berni/Desktop/Facultad_Obsidian/00.00 - 2026 - Tech trek/CRM/
```

## Stack tecnico

- **Framework:** Next.js 16.2.6 (App Router, RSC + Client Components)
- **Auth:** NextAuth v5 beta (Google OAuth, whitelist ITBA en `lib/team-emails.ts`)
- **DB:** Neon Postgres (serverless) + Drizzle ORM
- **UI:** Tailwind CSS v4 + shadcn/ui (Base UI, NO Radix, NO asChild)
- **Animaciones:** Framer Motion + @dnd-kit/core (drag-and-drop)
- **Charts:** recharts (AreaChart, BarChart, ResponsiveContainer, Cell)
- **Fuentes:** Syne (headings, `var(--font-syne)`) + Inter (body, `var(--font-inter)`)
- **Deploy:** Vercel (env vars en Vercel dashboard)
- **Middleware:** `proxy.ts` (Next.js 16 usa export `proxy`, no `middleware`)

## Estetica

- Fondo `#0d0d0d`, cards `#0f0f0f`, inputs `#141414`
- Acento dorado `#eec416` (hover: `#f5d038`)
- Borders `#1f1f1f`
- Headings: `font-family: var(--font-syne)` + uppercase + tracking-widest
- Botones primarios: `btn-gold` + `rounded-full` + `bg-[#eec416] text-black` (tiene glare sweep en hover)
- Botones secundarios: `border border-[#1f1f1f] rounded-full hover:border-[#eec416]`
- Sin box-shadows, usar border-color para depth

## Estructura del proyecto

```
app/
  page.tsx                    # Pipeline sponsors (server → PipelineView)
  talks/page.tsx              # Pipeline talks (server → TalksView)
  seguimiento/page.tsx        # Follow-ups y proximas acciones (server → SeguimientoView)
  team/page.tsx               # Team Overview dashboard (server → TeamOverview)
  empresa/[id]/page.tsx       # Ficha de empresa
  talks/[id]/page.tsx         # Ficha de speaker/talk
  login/page.tsx              # Login Google
  unauthorized/page.tsx       # Error de acceso
  api/
    companies/                GET (lista, ?estado=X), POST
    companies/[id]/           GET, PATCH, DELETE
    companies/[id]/contacts/  GET, POST (sincroniza companies.contacto si esPrincipal)
    contacts/[id]/            PATCH, DELETE (sincroniza companies.contacto si esPrincipal)
    talks/                    GET, POST
    talks/[id]/               GET, PATCH, DELETE
    interactions/             POST (actualiza ultimaInteraccionFecha + estado)
    interactions/[id]/        PATCH, DELETE (recalcula ultimaInteraccionFecha)
    drafts/                   POST
    drafts/[id]/              PATCH, DELETE
    auth/[...nextauth]/       NextAuth handlers

components/
  PipelineView.tsx            # Kanban sponsors (DnD, busqueda, filtros, boton Team)
  TalksView.tsx               # Kanban talks (DnD, busqueda, filtros)
  SeguimientoView.tsx         # Vista de seguimiento con filtros cliente
  TeamOverview.tsx            # Dashboard equipo (charts, heatmap, proximas acciones)
  GlobalNav.tsx               # Nav compartido con shortcuts 1-4 (client component)
  InteractionsPanel.tsx       # Historial con edicion/borrado inline (client, useEffect sync)
  DraftsPanel.tsx             # Borradores con edicion/borrado inline (client, useEffect sync)
  ContactsPanel.tsx           # CRUD de contactos por empresa (client, llama router.refresh)
  ProximaAccionPanel.tsx      # Inline add/edit/clear proxima accion (discriminated union: companyId|talkId)
  CompanyQuickEdit.tsx        # Inline edit de categoria y responsable en ficha de empresa
  AddCompanyDialog.tsx        # Crear empresa + contacto opcional en mismo form
  AddTalkDialog.tsx           # Crear speaker/talk
  EditCompanyDialog.tsx       # Editar empresa (datalist para categoria, incluye eliminar empresa con confirmacion doble)
  EditTalkDialog.tsx          # Editar talk (datalist para categoria)
  AddInteractionDialog.tsx    # Registrar interaccion (discriminated union: companyId|talkId)
  ParseInteractionDialog.tsx  # Importar interacciones desde JSON generado por IA (array o objeto)
  AddDraftDialog.tsx          # Guardar borrador (discriminated union: companyId|talkId)
  HotToggle.tsx               # Toggle 🔥 (prop entity: 'companies'|'talks')
  ColdToggle.tsx              # Toggle ❄️ (prop entity: 'companies'|'talks')
  GoatToggle.tsx              # Toggle 🐐 (prop entity: 'companies'|'talks')
  EstadoBadge.tsx             # Badge de estado con colores dark
  ResponsableBadge.tsx        # Avatar + badge de miembro

hooks/
  useLocalStorage.ts          # Hook que persiste estado en localStorage (SSR-safe)

db/
  schema.ts                   # Drizzle schema (ver abajo)
  index.ts                    # Conexion Neon + drizzle instance
  seed-sponsors.ts            # Upsert sponsors desde CSV (idempotente)
  seed-talks.ts               # Upsert talks desde CSV (idempotente)
  migrate.ts                  # Migraciones incrementales (ADD COLUMN IF NOT EXISTS)
  reset.ts                    # Trunca todas las tablas (DESTRUCTIVO)
  check.ts                    # Conteos y distribucion por estado

lib/
  constants.ts                # ESTADOS, ESTADOS_TALKS, TEAM, CANALES, tipoColor(), etc.
  cooling.ts                  # coolingLevel(), daysSince(), COOLING_UI
  team-emails.ts              # EMAIL_TO_KEY: whitelist de emails ITBA → clave de equipo

auth.ts                       # NextAuth v5 config (Google, whitelist, jwt/session callbacks)
proxy.ts                      # Middleware de auth (Next.js 16: export { auth as proxy })
```

## Schema de la DB

```typescript
companies:    id, name, categoria, estado, responsable, tipoSponsor, contexto,
              proximaAccion, proximaAccionFecha,
              ultimaInteraccionFecha,   // MAX(fecha) de todas las interacciones
              ultimaRespuestaFecha,     // MAX(fecha) de interacciones con respuesta != ''
              hot, cold, goat,          // boolean tags
              // campos legacy: contacto, email, telefono, linkedin, ig

contacts:     id, companyId, nombre, cargo, email, telefono, linkedin, ig, notas, esPrincipal

talks:        id, name, empresa, cargo, categoria, tema, estado, responsable,
              fechaDefinida, contexto, hot, cold, goat,
              ultimaInteraccionFecha, ultimaRespuestaFecha,
              proximaAccion, proximaAccionFecha

interactions: id, companyId(nullable), talkId(nullable), contactId(nullable),
              fecha, tipo, canal, responsable, estadoResultante, mensaje, respuesta

messageDrafts: id, companyId(nullable), talkId(nullable), canal, asunto, contenido
```

## Estados del pipeline

### Sponsors (ESTADOS)
1. No contactado | 2. Warm intro | 3. Primer contacto | 4. En conversacion
5. Reunion agendada | 6. A punto de cerrar | 7. Confirmado | 8. No participa

### Talks (ESTADOS_TALKS)
1. No contactado | 2. Primer contacto | 3. En conversacion | 4. Definiendo fecha
5. Fecha definida | 6. Realizada | 7. No participa

## Equipo Tech Trek 2026

| Clave  | Nombre              | Color      | Hex      |
|--------|---------------------|------------|----------|
| Tade   | Tadeo Scardilli     | Amarillo   | #f5d038  |
| Berni  | Bernardo Ortiz      | Rojo       | #f87171  |
| Tommy  | Tommy Varas         | Celeste    | #60a0fe  |
| Vic    | Victoria Escobar    | Rosa       | #f9a8d4  |
| Fran   | Francisco Galan     | Violeta    | #a78bfa  |
| Oli    | Olivia Grosso       | Lila       | #c4b5fd  |

## Comandos utiles

```bash
npm run dev               # levantar local
npm run db:migrate        # migraciones incrementales (SIEMPRE para schema changes)
npm run db:seed           # importar sponsors desde CSV (idempotente)
npm run db:seed:talks     # importar talks desde CSV (idempotente)
npm run db:reset          # truncar todo - DESTRUCTIVO
npx tsx db/check.ts       # ver conteos en la DB
npx tsc --noEmit          # typecheck
vercel deploy             # deploy a produccion
```

### Regla de DB

- **Schema changes** → solo `db:migrate`, nunca `db:reset`
- **Empezar de cero** → `db:reset` + `db:migrate` + `db:seed` (borra el progreso del pipeline)
- **Seeds idempotentes**: upsert por `name` UNIQUE, nunca pisan estado/responsable/contexto/interacciones

## Orientacion inicial

Al invocar este skill, leer en paralelo:
1. `db/schema.ts` para el modelo de datos actual
2. `lib/constants.ts` para estados y colores vigentes
3. `FUTURE_PLAN.md` para contexto de proximos features

## Keyboard shortcuts (global)

| Tecla | Accion |
|-------|--------|
| `1`   | Ir a Sponsors (`/`) |
| `2`   | Ir a Talks (`/talks`) |
| `3`   | Ir a Seguimiento (`/seguimiento`) |
| `4`   | Ir a Team (`/team`) |
| `/`   | Enfocar barra de busqueda (Sponsors, Talks, Seguimiento) |
| `f`   | Abrir/cerrar "Mas filtros" y enfocar search de categoria |
| `Esc` | Limpiar busqueda / cerrar dropdown de filtros |

Todos los shortcuts se ignoran cuando el foco esta en un `<input>`, `<textarea>` o `<select>`.

## Features del kanban (Sponsors y Talks)

- **Busqueda**: `/` para activar, `Esc` para cerrar/limpiar. Busca por empresa O contacto.
- **Filtro equipo**: chips animados por miembro con color e iniciales. Hover muestra tinte del color del miembro. Combinable con busqueda y mas filtros.
- **Mas filtros** (`f`): dropdown con search de categoria + dias sin contacto (rangos: <4, 4-7, 8-14, 15+) + Con/Sin respuesta. `Esc` cierra cuando el search esta enfocado. Presente en PipelineView Y TalksView (ver regla de features en multiples lugares).
- **Persistencia**: filtros de miembro, categoria y dias se guardan en `localStorage` por seccion. Se restauran al volver de una carta.
- **Paginacion cliente**: 5 cards iniciales, chevron para ver todas. Datos completos en el primer fetch.
- **Drag**: cards colapsan (height:0) al arrastrar. Hitbox = columna entera incluyendo header.
- **Tags en card**: 🔥 hot, ❄️ cold, 🐐 goat, badge de categoria, pill de dias sin contacto.
- **Sync de kanban**: `PipelineView` y `TalksView` sincronizan su `useState` con `useEffect` al recibir nuevas props del servidor, por lo que cualquier `router.refresh()` se refleja instantaneamente.

## SeguimientoView

Client component con los mismos filtros que el kanban:
- Busqueda por empresa o contacto (`/`)
- Chips de miembro con persistencia
- Mas filtros con search de categoria (`f` → auto-enfoca el search)
- `Esc` cierra el dropdown de filtros cuando el search esta activo
- Secciones: "Con fecha de seguimiento" (ordenadas por fecha, vencidas en rojo) y "En curso sin fecha asignada"
- Cada fila muestra: nombre, badge de categoria con color, contacto principal, proxima accion, responsable, estado

## CompanyQuickEdit

Permite editar categoria y responsable directamente desde la ficha de empresa sin abrir el dialog completo:
- Click en el valor → aparece input (categoria) o select (responsable)
- `Enter` o blur guarda via PATCH a `/api/companies/[id]`
- `Esc` cancela sin guardar
- Llama `router.refresh()` para que el kanban reciba los datos nuevos

## Contactos y kanban sync

- Al agregar/editar un contacto con `esPrincipal: true`, la API actualiza `companies.contacto` automaticamente
- Al borrar el contacto principal, la API asigna el siguiente disponible o limpia el campo
- `ContactsPanel` llama `router.refresh()` tras cada mutacion
- Esto combinado con el `useEffect` sync de `PipelineView` hace que el nombre en la card del kanban siempre este actualizado

## Canal de interaccion (libre)

El campo "Canal" en `AddInteractionDialog`, `InteractionsPanel` y `ParseInteractionDialog` es un `<input list>` con `<datalist>`, no un `<select>`. Acepta cualquier valor libre ademas de las opciones predefinidas en `CANALES`.

CANALES oficiales: Email, LinkedIn, WhatsApp, WeChat, Instagram, Reunion presencial, Telefono

TIPOS_INTERACCION: Mail inicial, Primer contacto, Follow-up, Warm intro recibida, Reunion presencial, Reunion virtual, Respuesta recibida, Llamada, Mensaje LinkedIn, DM Instagram, DM WhatsApp, Otro

## InteractionsPanel y DraftsPanel

Client components con estado local sincronizado al servidor via `useEffect`:
```typescript
useEffect(() => { setInts(initialInteractions); }, [initialInteractions]);
```
Edicion y borrado son inline. Al borrar o editar una interaccion, el API recalcula `ultimaInteraccionFecha` y `ultimaRespuestaFecha` con `MAX(fecha)` de las restantes.

El form de edicion incluye selector de contacto (cuando la empresa tiene contactos cargados). El PATCH acepta `contactId` como entero nullable.

El header del panel tiene dos botones: **Importar** (ParseInteractionDialog) y **+ Registrar interaccion** (AddInteractionDialog).

## ParseInteractionDialog

Flujo: copiar prompt → pegar en cualquier IA junto al chat → pegar el JSON devuelto → Aplicar → revisar/editar cards → Guardar N interacciones.

- Acepta array `[{...}, {...}]` o objeto suelto `{...}` (normaliza a array)
- Cada interaccion parseada se muestra como card editable con X para eliminar
- "Guardar N interacciones" postea todas en paralelo
- El prompt copia el schema completo con descripcion de cada campo, tipos validos y miembros del equipo

## ProximaAccionPanel

Reemplaza el bloque estatico de proxima accion en la sidebar. Tres estados:
- Sin accion: boton dashed `+ Agregar proxima accion`
- Con accion: card dorada con Editar / Limpiar
- Editando: form inline con descripcion + fecha limite

Usa discriminated union `companyId | talkId` y construye la patchUrl internamente. Presente en `empresa/[id]/page.tsx` y `talks/[id]/page.tsx`.

## Team Overview (/team)

- **Header**: igual al de las otras secciones (logo + GlobalNav a la derecha)
- **Filtros** en el main: periodo (Hoy/Semana/Mes/Todo/Custom) + chips de miembro animados con colores
- **Persistencia**: periodo y miembro se guardan en localStorage
- **Heatmap**: 52 semanas, tono dorado, filtrable por miembro
- **Charts**: interacciones por periodo (area), por miembro (bar coloreado), por estado sponsors/talks (bar), por categoria (grouped bar)
- **Proximas acciones**: lista paginada, overdue en rojo, badge Sponsor/Talk, clickeable
- **Dias sin contacto**: lista top 10, toggle mas/menos, coloreado por urgencia, clickeable
- **Interacciones recientes**: tabla con tipo, fecha, responsable

## GlobalNav

Client component compartido que se monta en el header de todas las paginas principales. Detecta la ruta activa con `usePathname` y registra un listener global para los shortcuts `1`-`4`. Muestra hints `[1]`-`[4]` debajo de cada label.

## Deploy y produccion

- **URL de produccion**: https://tt-crm-nine.vercel.app
- **Repo GitHub**: tt-crm (privado)
- **DB**: misma Neon DB para local y produccion (la URL va en Vercel env vars)

### Google OAuth en produccion

**Authorized JavaScript origins:**
```
http://localhost:3000
https://tt-crm-nine.vercel.app
```

**Authorized redirect URIs:**
```
http://localhost:3000/api/auth/callback/google
https://tt-crm-nine.vercel.app/api/auth/callback/google
```

### Vercel env vars requeridas

```
DATABASE_URL      # Neon connection string (pooled, empieza con postgresql://)
AUTH_SECRET       # NextAuth secret
AUTH_GOOGLE_ID    # Google OAuth client ID
AUTH_GOOGLE_SECRET # Google OAuth client secret
```

## Features que viven en multiples lugares — REGLA CRITICA

Cuando se agrega o modifica algo visual o funcional, hay que actualizarlo en TODOS los lugares donde aparece. Los lugares en paralelo son:

### Pills / indicadores en cards y en header de la ficha
| Que         | Kanban card                        | Header de la ficha detail page         |
|-------------|------------------------------------|-----------------------------------------|
| Dias sin contacto | `PipelineView.tsx` DraggableCard + `TalksView.tsx` DraggableCard | `empresa/[id]/page.tsx` header + `talks/[id]/page.tsx` header |
| Dias sin respuesta (↩Xd) | idem arriba — pill separada, cuenta desde `ultimaRespuestaFecha` | idem arriba — solo mostrar si fecha distinta a ultimaInteraccionFecha |
| Tags 🔥❄️🐐  | inline en la card | via HotToggle/ColdToggle/GoatToggle en el header |

### Filtros en "Mas filtros"
Cualquier filtro nuevo va en **ambos**: `PipelineView.tsx` Y `TalksView.tsx`:
- Estado local + `useLocalStorage`
- Logica de filtrado en `filtered`
- UI en el dropdown
- Count en `activeMoreFilters`
- Reset en el boton "Limpiar filtros adicionales"

### Campos en formularios de interaccion
Los mismos campos (TIPOS_INTERACCION, CANALES, estados) aparecen en tres lugares:
- `AddInteractionDialog.tsx` (form de creacion)
- `InteractionsPanel.tsx` (form de edicion inline)
- `ParseInteractionDialog.tsx` (form de revision post-parse)

Al agregar un tipo o canal nuevo en `lib/constants.ts`, tambien actualizar el prompt en `ParseInteractionDialog.tsx` (el string `PROMPT` hardcodea los valores validos).

### Proxima accion
`ProximaAccionPanel` se monta en `empresa/[id]/page.tsx` Y `talks/[id]/page.tsx`. Usa discriminated union internamente para construir la patchUrl correcta.

### API interactions: campos derivados
`interactions/route.ts` (POST) y `interactions/[id]/route.ts` (PATCH/DELETE) deben mantener sincronizados los mismos campos derivados:
- `ultimaInteraccionFecha`: MAX(fecha) de todas las interacciones
- `ultimaRespuestaFecha`: MAX(fecha) WHERE respuesta IS NOT NULL AND respuesta != ''

Al agregar un nuevo campo derivado, agregarlo en ambos routes.

## Bugs conocidos y sus fixes

### Dialog: form con estado stale al reabrir
`useState` inicializa una sola vez al montar el componente. Si un dialog se cierra, el servidor refresca datos (via `router.refresh()`), y el dialog se vuelve a abrir, el form sigue mostrando los valores viejos. Al guardar, sobrescribe los datos nuevos con los stale.

**Fix**: `useEffect` que reinicializa el form CADA VEZ que `open` pasa a `true`:
```typescript
useEffect(() => {
  if (open) {
    setForm({ ...valoresDesdeProp });
    setOtroEstado(defaultValue);
  }
}, [open]);
```
Aplica a TODOS los dialogs de edicion (EditCompanyDialog, EditTalkDialog, etc).

### PATCH API: empty string en columnas date
Cuando el form envia `proximaAccionFecha: ''` (empty string — campo de fecha vacio), Postgres rechaza el update con "invalid input syntax for type date". La request falla silenciosamente porque el componente no verifica el status de la respuesta.

**Fix**: sanitizar en el handler antes de pasarlo a Drizzle:
```typescript
if (body.proximaAccionFecha === '') body.proximaAccionFecha = null;
```
Aplica a `app/api/companies/[id]/route.ts` y `app/api/talks/[id]/route.ts`.

### Pills sin contacto vs sin respuesta: son DOS pills distintas
Son counters con semanticas diferentes y AMBAS se muestran:
- `Nd sin contacto` — dias desde `ultimaInteraccionFecha` (cooling color)
- `↩Md sin respuesta` — dias desde `ultimaRespuestaFecha` (solo si difiere de ultimaInteraccionFecha)

NO intentar mergearlas en una sola pill. El diseño intencional es mostrar las dos cuando son diferentes, ya que dan informacion distinta.

## Guia de estilo para nuevos features

- **Paginas**: server component por default, extraer interactividad a client components
- **Dialogs**: `<Dialog>` de shadcn/ui (Base UI). NO `asChild`. Controlar con `useState` + button nativo.
- **Categorias**: `<input list="id">` + `<datalist>` para libre escritura con sugerencias
- **Tags (hot/cold/goat)**: patron GoatToggle.tsx — prop `entity` ('companies'|'talks'), PATCH directo
- **Al agregar columna**: schema.ts + migrate.ts con `ADD COLUMN IF NOT EXISTS` + `npm run db:migrate`
- **Features para ambas entidades**: usar discriminated union props (ver AddInteractionDialog, DraftsPanel, ProximaAccionPanel)
- **Cooling**: no aplica a No contactado, Confirmado, No participa, Realizada (ver `lib/cooling.ts`)
- **Filtros persistidos**: usar `useLocalStorage` con clave `tt-crm:<seccion>:<filtro>`
- **Keyboard shortcuts**: agregar al `useEffect` con handler `onKey`, siempre verificar `isInput` antes de actuar
- **Chips de miembro**: patron de PipelineView — `motion.button` con `animate` + `whileHover={{ backgroundColor: \`\${m.color}15\`, borderColor: m.color, opacity: 1 }}`
- **Header mobile**: dos filas — fila 1: breadcrumb + action buttons; fila 2: badges/pills con `flex-wrap`
