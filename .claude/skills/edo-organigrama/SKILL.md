---
name: edo-organigrama
description: |
  Genera organigramas estante según la TON (Teoría de la Organización Natural) para la materia Estructura de las Organizaciones (EDO, 94.40 ITBA). Úsalo cuando el usuario pida diagramar una estructura organizacional, analizar una empresa por estratos de Jaques, o resolver un caso práctico que requiera proponer un organigrama según la TON. Triggers: "organigrama estante", "estructura TON", "estratos de Jaques", "diagrama JRG", casos de empresas con años/períodos a comparar.
allowed-tools:
  - Read
  - Edit
  - Write
---

# EDO — Organigrama Estante (TON / Jaques)

Genera organigramas estante para casos de la materia **Estructura de las Organizaciones** (94.40, ITBA), siguiendo la Teoría de la Organización Natural de Elliott Jaques.

---

## Reglas del diagrama

### 1. Lo que NO va en el diagrama
- **No se dibuja el Directorio ni la Asociación.** Son el gobierno de la organización, están por encima de la JRG y no forman parte del organigrama estante.
- Las funciones **sí aparecen** en el diagrama, pero como prefijos de rol dentro de cada estrato — **nunca como headers de columna ni como tabla**.
  - Correcto: `I — Jefe de Mercados`, `M — Gerente de Planta`, `RH — Gerente de RRHH`
  - Incorrecto: una fila de headers `[I]  [D]  [M]  [I]` con columnas debajo

### 2. Funciones que aparecen como prefijos de rol

| Prefijo | Función | Ejemplos de rol |
|---|---|---|
| **I-i —** | Intercambio identificatorio (marketing, inteligencia de mercado) | I-i — Jefe de Mercados, I-i — Gerente de Marketing |
| **D —** | Diseño / Desarrollo (I+D, producto, ingeniería) | D — Director de I+D, D — Maestro Chocolatero |
| **M —** | Materialización (producción, operaciones, logística) | M — Gerente de Planta, M — Gerente de Operaciones |
| **I-d —** | Intercambio devolutorio (ventas, comercialización, distribución) | I-d — Director Comercial, I-d — Gerente de Ventas |
| **RH —** | Recursos Humanos | RH — Gerente de RRHH |
| **T —** | Tecnología | T — Gerente de Tecnología |
| **Admin —** | Administración / Planeamiento | Admin — Gerente de Planeamiento, Admin — Administrador |

### 3. Estructura del diagrama

El organigrama se construye **de arriba hacia abajo**, un estrato por "estante":

```
    ROL — Descripción del rol                    ← estrato más alto (PRE o GdG)
    (Nombre propio si aplica)

──────────────────────────── fin En  ·  AT: X ───   ← separador al final del estrato

    I — Rol       D — Rol       M — Rol       RH — Rol    ← siguiente estrato con prefijos

──────────────────────────── fin En  ·  AT: X ───

    Operarios / personal de línea base              ← E1

──────────────────────────── fin E1  ·  AT: días–semanas ───
```

### 3. La línea separadora
- Va **al final** de cada estrato (es el piso del estante).
- Indica `fin En` y el **AT (Alcance Temporal)** de ese estrato.
- Formato: `──────────────── fin En  ·  AT: X ───`

### 4. Roles: siempre el rol primero
- El rol es lo central: "PRE — Director General", "Gerente de Planta", "Jefe Comercial".
- El nombre propio va entre paréntesis como referencia secundaria, si corresponde.
- Nunca poner solo el nombre de una persona sin su rol.

### 5. Alcances Temporales de referencia por estrato

| Estrato | Tipo de organización | AT típico |
|---|---|---|
| E1 | Operario / técnico de línea | Días–semanas |
| E2 | Mando directo (taller, pequeño negocio) | 3 meses–2 años |
| E3 | PyME / mando directo ampliado (~50-250 personas) | 1–5 años |
| E4 | Mando general (~900 personas) | 3–7 años |
| E5 | Mando general ampliado (~10.000 personas) | 5–10 años |
| E6–E8 | Corporación global | 10–50 años |

---

## Ejemplo mínimo — E2

```
    PRE — Fundador y Propietario

──────────────────────────── fin E2  ·  AT: 1–2 años ───────

    I-i — Identificación de mercado    D — Maestro Chocolatero
    M   — Operarios artesanales        I-d — Vendedor directo

──────────────────────────── fin E1  ·  AT: días–semanas ───
```

## Ejemplo medio — E3

```
    PRE — Director General

──────────────────────────── fin E3  ·  AT: 2–5 años ───────

    I-i — Jefe de Mercados   D — Director Técnico     M — Gerente de Planta A
    Admin — Administrador    I-d — Gerente de Ventas  M — Gerente de Planta B

──────────────────────────── fin E2  ·  AT: 6–18 meses ─────

    Operarios industriales por planta

──────────────────────────── fin E1  ·  AT: días–semanas ───
```

## Ejemplo completo — E4–E5 (forma divisional)

```
    PRE — CEO / Director Ejecutivo

──────────────────────────── fin E5  ·  AT: 5–10 años ──────

    GdG — Director División A      RH    — Gerente de RRHH Corporativo
    GdG — Director División B      T     — Gerente de Tecnología Corporativo
                                   Admin — Gerente de Planeamiento Corporativo

──────────────────────────── fin E4  ·  AT: 18–36 meses ────

    I-i — Gerente de Marketing   D — Gerente de I+D    M — Gerente de Operaciones    I-d — Director Comercial
    (por división)               (por división)        (por división)                (por división)

──────────────────────────── fin E3  ·  AT: 6–18 meses ─────

    Supervisores de área  ·  Jefes de turno  ·  Coordinadores

──────────────────────────── fin E2  ·  AT: 2–6 meses ──────

    Operarios  ·  Fuerza de ventas  ·  Técnicos y analistas

──────────────────────────── fin E1  ·  AT: días–semanas ───
```

---

## Proceso para resolver un caso

1. **Identificar el período/año** y el contexto histórico de la empresa.
2. **Determinar el estrato del PRE** en base al AT de sus decisiones más largas (expansión geográfica, lanzamiento de producto, fusión, etc.).
3. **Listar los roles** de cada estrato con su prefijo de función al frente:
   - `I-i — [rol]` → Jefe de Mercados, Gerente de Marketing, Agente Comercial
   - `D   — [rol]` → Maestro Chocolatero, Gerente de I+D, Director Técnico
   - `M   — [rol]` → Gerente de Producción, Gerente de Planta, Gerente de Operaciones
   - `I-d — [rol]` → Director Comercial, Gerente de Ventas, Jefe de Distribución
   - `RH  — [rol]` → Gerente de RRHH
   - `T   — [rol]` → Gerente de Tecnología
   - `Admin — [rol]` → Gerente de Planeamiento, Administrador
4. **Dibujar el estante** de arriba hacia abajo, un estrato por nivel, con los separadores al pie de cada uno.
5. **No incluir Directorio ni Asociación** en el diagrama.

---

## Notas de la materia relacionadas
- Notas EDO en Obsidian: `/home/berni/Desktop/Facultad_Obsidian/94.40 - Estructura de las Organizaciones/`
- Estratos y tipos de mando: `2026-05-13 EDO A Claude.md`
- Funciones operativas (I, D, M, I): `2026-03-25 EDO A Claude.md`
- JRG y estructura básica: `2026-04-08 EDO A Claude Repaso P1.md`
