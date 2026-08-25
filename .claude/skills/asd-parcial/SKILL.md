---
name: asd-parcial
description: |
  Resuelve un parcial de Arquitectura de Soluciones Digitales (81.57 - ITBA).
  Usarla cuando el usuario diga "resolver el parcial de ASD", "responder el examen de Arquitectura",
  o proporcione un escenario de empresa con preguntas sobre arquitectura (drivers, atributos de
  calidad, diagrama de contexto, microservicios, CI/CD, SRE, riesgos).
  La skill cubre los 4 tipos de preguntas del parcial tipo: diagrama de contexto, drivers/atributos,
  comparacion arquitectonica, CI/CD, evolucion con capas, SRE, y analisis de riesgos.
---

# Parcial de Arquitectura de Soluciones Digitales (ITBA 81.57)

## Materiales de referencia

**Resumen general** (base de conocimiento principal):
`/home/berni/Desktop/Facultad/3A1Q/81.57 - Arquitectura de soluciones digitales/Recursos/Resumenes/RESUMEN ARQUI.md`

**Slides convertidos a MD** (leer cuando el tema corresponda):

| Unidad | Tema | Archivo |
|--------|------|---------|
| U1 | Requerimientos, Atributos de Calidad, Drivers | `.../Slides/U1/01 - Clase 1 - Requerimientos, Atributos de Calidad y Drivers.md` |
| U1 | Introduccion a Arquitecturas, Proceso, Drivers | `.../Slides/U1/ITBA - Introduccion a las Arquitecturas - Concepto, Proceso, Drivers_v4.md` |
| U2 | Integracion de aplicaciones | `.../Slides/U2/01 - Integracion de aplicaciones.md` |
| U2 | API as Product | `.../Slides/U2/02 - API as Product_v3.md` |
| U2 | Frontend / Presentacion | `.../Slides/U2/02 - Arch Design - Clase Frontend_Presentación.md` |
| U2 | Lenguajes y frameworks | `.../Slides/U2/02 - Arch Design - Lenguajes y frameworks.md` |
| U2 | Logica de negocio | `.../Slides/U2/02 - Arch Design - Lógica de Negocio.md` |
| U2 | Persistencia de datos | `.../Slides/U2/02 - Arch Design - Persistencia de Datos.md` |
| U2 | Microservicios | `.../Slides/U2/03 - Arquitectura Técnica 3 - Estilos de Arquitectura actuales (Microservicios).md` |
| U3 | Kubernetes | `.../Slides/U3/Diseño de Arquitectura Tecnológica - Kubernetes con minions.md` |
| U3 | Infraestructura, Virtualización, Containers | `.../Slides/U3/Unidad 04 - Infraestructura, Virtualizacion, Containers.md` |
| U4 | CI/CD, CI, CT | `.../Slides/U4/Presentación de PowerPoint - 04 - Cloud Native Apps - CI, CD, CT_v1_todo integradoprint.md` |
| U4 | SRE | `.../Slides/U4/Modelos Operativos - SRE I - Diseño.md` |

Ruta base: `/home/berni/Desktop/Facultad/3A1Q/81.57 - Arquitectura de soluciones digitales/Recursos`

**Apuntes de clase en Obsidian** (prioridad alta: contienen lo que el profesor enfatizo en cada clase):

| Fecha | Archivo | Temas probables |
|-------|---------|-----------------|
| 2026-03-02 | `.../Facultad_Obsidian/81.57 - Arquitectura de soluciones digitales/2026-03-02 ASD.md` | Introduccion, definicion de arquitectura, tipos |
| 2026-03-09 | `.../2026-03-09 ASD.md` | Viewpoints, proceso de arquitectura |
| 2026-03-16 | `.../2026-03-16 ASD.md` | Atributos de calidad, escenarios |
| 2026-03-23 | `.../2026-03-23 ASD.md` | Drivers, restricciones |
| 2026-03-30 | `.../2026-03-30 ASD.md` | Diseno tecnico, capas |
| 2026-04-06 | `.../2026-04-06 ASD.md` | Microservicios, integracion |
| 2026-04-13 | `.../2026-04-13 ASD - Charla Uala.md` | Charla invitado: CTO de Ualá |
| 2026-04-20 | `.../2026-04-20 ASD.md` | Infraestructura, containers |
| 2026-04-27 | `.../2026-04-27 ASD Cloud.md` | Cloud, Kubernetes |
| 2026-05-04 | `.../2026-05-04 ASD - Charla Macro.md` | Charla invitado: Macro |
| 2026-05-11 | `.../2026-05-11 ASD.md` | CI/CD, SRE |

Ruta base Obsidian: `/home/berni/Desktop/Facultad_Obsidian/81.57 - Arquitectura de soluciones digitales/`

**Criterio de uso:** leer primero los apuntes de la fecha que corresponde al tema de la pregunta. Si hay algo que contradice o complementa los slides, el apunte tiene prioridad (refleja lo que el profesor dijo en clase).

**Parciales de ejemplo** (para calibrar el nivel esperado):

| Año | Archivo | Escenario |
|-----|---------|-----------|
| 2024 2C | `.../Parciales/Parcial2024/Parcial 2024 - 2do cuatrimestre.md` | MoviFlex - plataforma de movilidad urbana con carpooling; monolito bajo presion, pagos, disponibilidad |
| 2025 2C | `.../Parciales/Parcial 2025 - 2do cuatrimestre.md` | (ver archivo) |

---

## Flujo de resolución

### Paso 0: Leer y parsear el enunciado

Antes de responder nada:
1. Identificar el **escenario** (empresa, contexto, problema).
2. Listar explícitamente todas las **preguntas** de Parte 1 y Parte 2.
3. Marcar el tipo de cada pregunta (ver mapa abajo).
4. Leer el resumen general para refrescar el vocabulario de la materia.
5. Si alguna pregunta toca un tema especifico, leer el slide MD correspondiente antes de responder.

### Paso 1: Mapa de tipos de preguntas

> **VALIDACION OBLIGATORIA:** despues de redactar cada respuesta, leer `/home/berni/.claude/skills/asd-parcial/RUBRICA.md` y autoevaluar con la escala 0-3. Si la respuesta obtiene 2 o menos, REESCRIBIRLA antes de continuar con la siguiente pregunta. No entregar respuestas que no alcancen el nivel 3.

| Tipo | Descripcion | Slides relevantes |
|------|-------------|-------------------|
| **DIAGRAMA DE CONTEXTO** | Sistema central + sistemas externos + actores | U1 ambos slides |
| **DRIVERS + ATRIBUTOS + RESTRICCIONES** | 3 drivers de negocio, 3 atributos de calidad con escenario, restricciones | U1 ambos slides |
| **COMPARACION ARQUITECTONICA** | Monolito vs microservicios, ventajas/desventajas, mitigaciones | U2 microservicios |
| **CI/CD** | Pipeline, testing, despliegue gradual, rollback | U4 CI/CD |
| **EVOLUCION + CAPAS** | Agregar nueva capacidad (IoT, IA, etc.), actualizar drivers, diagrama en capas | U1 + U2 microservicios |
| **SRE** | Practicas SRE, SLOs, toil, postmortems, error budgets | U4 SRE |
| **RIESGOS** | 2 riesgos criticos + mitigacion, relacionados con drivers previos | U1 + U3 |

---

## Guia de respuesta por tipo

### DIAGRAMA DE CONTEXTO

El diagrama de contexto muestra los limites del sistema y sus relaciones externas. Nunca mostrar internos del sistema.

**Estructura obligatoria:**
- **Sistema central**: nombrar la plataforma/servicio del escenario
- **Actores** (personas que interactuan):
  - Usuario final / cliente
  - Operadores internos (admins, liquidadores, agentes, etc. segun el escenario)
  - Reguladores si el dominio los menciona
- **Sistemas externos minimos**: los que el enunciado nombra explicitamente
- **Sistemas externos opcionales** que son razonables segun el dominio:
  - Gateway de pagos (si hay transacciones)
  - Sistema de notificaciones (SMS/Push/Email)
  - Registros gubernamentales (si hay validacion de datos regulados)
  - Proveedor de identidad / autenticacion

**Como representarlo en texto (si no hay herramienta de diagramas):**
```
[Usuario / Cliente] ──→ [SISTEMA CENTRAL]
[Operador / Admin]  ──→ [SISTEMA CENTRAL]
[SISTEMA CENTRAL]   ──→ [Servicio Externo A]
[SISTEMA CENTRAL]   ──→ [Servicio Externo B]
[Gateway de Pagos]  ←── [SISTEMA CENTRAL]
```

**Rubrica (3 puntos):** Limites claros + actores completos + flujos (flechas con direccion) + sistemas externos del enunciado todos presentes.

---

### DRIVERS + ATRIBUTOS DE CALIDAD + RESTRICCIONES

**Definiciones clave:**
- **Driver**: necesidad del negocio o tecnica que MOTIVA las decisiones arquitectonicas. Suele ser un requerimiento prioritario de los stakeholders. Ej: "crecimiento exponencial obliga a escalar", "regulacion nueva requiere compliance".
- **Atributo de calidad**: propiedad no funcional que moldea la calidad del sistema. Pueden ser determinisricos (garantia exacta) o probabilisticos (expresados como porcentaje o nivel esperado).
- **Restriccion**: factor que LIMITA las decisiones del arquitecto (costo, tiempo, regulacion, tecnologia existente, datos geograficos).

**Atributos de calidad vistos en clase** (son un trade-off constante: nunca se pueden lograr todos con excelencia):

| Atributo | Definicion | Metricas tipicas | Tip de parcial |
|----------|------------|-----------------|----------------|
| **Disponibilidad** | Grado de operabilidad del sistema. Formula: MTBF / (MTBF + MTTR) | % uptime (ej: 99.9%), tiempo de recuperacion | SIEMPRE incluirla: "si no esta corriendo la app no hay negocio" |
| **Usabilidad** | Grado de facilidad para que los usuarios operen el sistema. Ej: modo simple para manejar en Waze/Spotify | Tasa de error, tiempo de aprendizaje, satisfaccion UX | Muy facil de justificar en cualquier escenario con usuarios finales |
| **Seguridad** | Resistencia a usos no autorizados. Incluye donde y como se guardan los datos | Tiempo de deteccion, intentos bloqueados, cumplimiento de auditoria | Obligatoria cuando el escenario menciona datos personales, pagos o regulacion |
| **Rendimiento** | Que tan rapido anda el sistema, especialmente bajo cargas altas (ej: Cyber Monday) | Response time, throughput, escalabilidad, carga pico | Usar cuando el enunciado menciona picos de demanda o lentitud |
| **Modificabilidad** | Que tan facil es incorporar nuevos requerimientos al sistema | Dias/horas para implementar un cambio | Usar cuando el escenario menciona expansion, nuevas features o integraciones futuras |
| **Testabilidad** | Facilidad para probar las funcionalidades del sistema | % cobertura, tiempo de ejecucion de la suite | Menos frecuente en parciales, pero valida si se habla de CI/CD |

> Nota de clase: "No importa tanto la terminologia como la capacidad de comunicar conceptos. Si hay problemas de nomenclatura o clasificacion, debemos ser capaces de entender el problema para luego resolverlo."
>
> Existen muchos otros atributos de calidad validos (portabilidad, escalabilidad, auditoria, etc.). No limitarse a estos 6 si el escenario lo pide.

**Sub-dimensiones de Modificabilidad (vistas en clase):**
- **Maintainability**: facilidad para resolver problemas existentes
- **Extensibility**: facilidad para agregar nuevas funcionalidades
- **Restructuring**: facilidad para reorganizar modulos
- **Interoperability**: facilidad para integrarse con otros sistemas

**Sub-dimensiones de Seguridad (vistas en clase):**
- **No Repudio**: el sistema puede demostrar quien hizo que, cuando y donde
- **Confidencialidad**: la informacion solo puede ser vista por quienes estan autorizados
- **Integridad**: los datos no pueden ser alterados incorrectamente
- **Disponibilidad**: el sistema sigue accesible para usuarios legitimos
- **Auditoria**: capacidad de registrar y rastrear lo que ocurrio en el sistema

**Fault vs Failure (Disponibilidad) — concepto de clase:**
- **Fault (desperfecto)**: problema interno que existe pero no necesariamente impacta al usuario todavia (ej: bug en codigo, RAM danada)
- **Failure (falla)**: cuando el desperfecto provoca un comportamiento incorrecto visible (ej: app caida, datos incorrectos, respuesta lenta)
- Los faults son observables, los failures, en general, no.

**Como identificar 3 drivers del escenario:**
Buscar en el enunciado:
1. El problema principal que tiene la empresa (ej: monolito sobreexigido → *driver: escalabilidad*)
2. El mandato de negocio o regulacion nueva (ej: nueva ley de seguros digitales → *driver: compliance regulatorio*)
3. La expansion o innovacion mencionada (ej: IoT, IA, nuevo mercado → *driver: integracion de nuevas tecnologias*)

**Como construir el escenario de atributo de calidad (6 componentes):**

| Componente | Descripcion | Quien / Que |
|------------|-------------|-------------|
| Origen del estimulo | Quien genera la situacion | Usuario, sistema externo, atacante, tiempo |
| Estimulo | El evento concreto que ocurre | Request, falla, cambio de requerimiento |
| Componentes | Partes del sistema involucradas | API, BD, frontend, load balancer |
| Contexto | Cuando/bajo que condicion ocurre | Horario pico, mantenimiento, alta demanda |
| Respuesta | Lo que el sistema debe hacer | Procesar, redirigir, bloquear, recuperar |
| Medida de la respuesta | Metrica concreta y cuantificable | Segundos, %, dias, cantidad de requests |

**Ejemplos de escenarios dados en clase:**

*Rendimiento:*
```
Origen:    Usuarios
Estimulo:  1.000 transacciones X por minuto (probabilistico)
Contexto:  Procesamiento normal, de 9 a 18hs, carga normal
Componente: Todo el sistema
Respuesta: Transaccion procesada
Medida:    Latencia menor a 3 segundos
```

*Disponibilidad:*
```
Origen:    Usuario final
Estimulo:  Inicio de sesion
Contexto:  Procesamiento normal, de 9 a 18hs, carga normal
Componente: Pantalla de Login
Respuesta: Servicio disponible
Medida:    99.99% de las veces
```

*Modificabilidad:*
```
Origen:    Stakeholder
Estimulo:  Agregar nueva funcionalidad (publicar servicio existente para otra app)
Contexto:  Etapa de mantenimiento (sistema ya en produccion)
Componente: Core Services e Interfaces
Respuesta: Cambio realizado correctamente implementado
Medida:    No supere 14 dias desde la aprobacion del Change Request
```

**Restricciones tipicas segun dominio:**
- Datos personales → GDPR, ley de proteccion de datos local
- Pagos → PCI DSS
- Seguros, salud, finanzas → regulacion sectorial + auditoria completa
- Datos geograficos → soberania de datos (servidores locales)
- Legacy existente → restriccion de arquitectura

**Rubrica (3 puntos):** Drivers pertinentes con justificacion + atributos con metricas medibles trazados al escenario + restricciones coherentes. Usar escenarios de 6 componentes para al menos un atributo.

---

### COMPARACION ARQUITECTONICA (microservicios vs monolito)

**Posiciones validas:**
1. Migrar a microservicios (gradual o directo) — recomendada en escenarios de escala
2. Mantener monolito mejorado (Modular Monolith) — valido para MVP o restricciones de tiempo/equipo
3. Arquitectura hibrida — separar los servicios de mayor demanda, mantener el core monolitico

**Ventajas de microservicios (las mas valoradas por la materia):**
- Escalabilidad independiente por servicio segun demanda
- Aislamiento de fallos: un servicio caido no tumba el sistema entero
- Despliegue independiente por equipo
- Tecnologia heterogenea (polyglot)

**Desventajas de microservicios (con mitigacion obligatoria):**

| Desventaja | Mitigacion concreta |
|------------|---------------------|
| Complejidad de datos distribuidos y consistencia | Patron SAGA para transacciones distribuidas; "datos por servicio" desde el inicio |
| Overhead operativo (monitoreo, deploy, red) | Kubernetes/orquestador + observabilidad (logs, metricas, tracing con OpenTelemetry) |
| Latencia entre servicios | Comunicacion asincrona con mensajeria (Kafka/SQS) para flujos no criticos |
| Complejidad de testing | Contract testing (Pact), pruebas de integracion por servicio |

**Ventajas del monolito:**
- Menor complejidad operativa inicial
- Transacciones ACID simples (una sola BD)
- Equipo pequeno puede iterar rapido

**Rubrica (3 puntos):** Posicion clara + 2 ventajas justificadas + 2 desventajas con mitigaciones ACCIONABLES (no genericas). Reconocer trade-offs es clave.

---

### CI/CD EN CONTEXTO CRITICO

**Pipeline recomendado para dominio de alto riesgo (seguros, finanzas, salud):**

```
[Commit] → [Build] → [Tests unitarios] → [Tests de integracion]
         → [Contract tests] → [SAST/DAST] → [Tests de carga]
         → [Deploy staging] → [Smoke tests] → [Deploy canary (5-10%)]
         → [Monitoreo automatico] → [Deploy full o rollback]
```

**Elementos obligatorios para puntaje maximo:**
1. **Multiple entornos**: dev → QA → pre-produccion → produccion
2. **Testing exhaustivo**: unitarios, integracion, contrato, seguridad, carga
3. **Despliegue gradual**: Canary release o Blue/Green deployment
4. **Rollback automatico**: si metricas de error superan umbral → revertir sin intervencion manual
5. **Criterios de calidad**: quality gates (no pasar sin X% cobertura, sin vulnerabilidades criticas)

**Diferencias CI / CD:**
- **CI (Continuous Integration)**: integrar cambios frecuentes, correr builds y tests automaticamente
- **CD (Continuous Delivery)**: despliegue automatico hasta pre-produccion; produccion requiere aprobacion manual
- **CD (Continuous Deployment)**: despliegue automatico hasta produccion sin intervencion

**Rubrica (3 puntos):** Pipeline conciso con etapas clave + despliegue gradual nombrado + rollback explicito + justificacion del enfoque en el contexto del negocio.

---

### EVOLUCION + DIAGRAMA EN CAPAS

Cuando el enunciado pide agregar una nueva capacidad (IoT, IA, marketplace, etc.):

**Que actualizar siempre:**
1. Un nuevo **driver** (ej: "interoperabilidad y procesamiento de datos en tiempo real")
2. El **diagrama de contexto**: agregar el nuevo sistema externo o actor
3. Una **decision arquitectonica**: como encaja la nueva capacidad en la arquitectura existente

**Diagrama de arquitectura en capas:**
```
┌──────────────────────────────────────────────────────┐
│  CAPA DE PRESENTACION    Apps movil / Web / Portal   │
├──────────────────────────────────────────────────────┤
│  API GATEWAY             Seguridad / Rate Limiting   │
├──────────────────────────────────────────────────────┤
│  MICROSERVICIOS          [Servicio A] [Servicio B]   │
│                          [Servicio C] [Servicio D]   │
├──────────────────────────────────────────────────────┤
│  CAPA DE INTEGRACION     [Nueva capa si aplica]      │
│  (ej. IoT / IA)          Ingesta / Procesamiento     │
├──────────────────────────────────────────────────────┤
│  CAPA DE DATOS           SQL / NoSQL / Data Lake     │
├──────────────────────────────────────────────────────┤
│  SEGURIDAD (transversal a todas las capas)           │
└──────────────────────────────────────────────────────┘
```

**Si se agrega IoT:**
- Nueva capa de integracion IoT (ingesta de alto volumen, procesamiento en tiempo real)
- Broker de mensajes (Kafka, MQTT) para manejar los eventos de los dispositivos
- Servicio de procesamiento de datos tematicos separado del core transaccional

**Rubrica (3 puntos):** Explicacion coherente con P1 + diagrama en capas legible con responsabilidades por capa.

---

### SRE (Site Reliability Engineering)

**Definicion concisa:** SRE aplica ingenieria de software a las operaciones. Es "lo que ocurre cuando un desarrollador diseña un equipo de operaciones" (Google).

**Practicas SRE mas relevantes para sistemas criticos:**

| Practica | Descripcion | Por que es clave |
|----------|-------------|-----------------|
| **SLOs + Error Budgets** | Objetivos de nivel de servicio medibles (ej: 99.95% disponibilidad para siniestros en < 3s) | Balancear innovacion y confiabilidad con datos |
| **Toil Reduction** | Automatizar tareas manuales y repetitivas | Reducir error humano en operaciones criticas |
| **Planificacion de capacidad** | Simulacion de eventos de alta demanda (ej: prueba de carga de granizada) | Evitar caidas en crisis reales |
| **Blameless Postmortems** | Analisis de incidentes sin culpar personas; enfoque en causa raiz | Aprender sistematicamente de los fallos |
| **Chaos Engineering** | Inyectar fallos controlados para validar resiliencia | Descubrir debilidades antes de que el negocio las descubra |
| **Observabilidad** | Logs, metricas, tracing distribuido | Entender el estado interno del sistema desde fuera |

**Relacion DevOps vs SRE:**
DevOps es la cultura; SRE es la implementacion ingenieril de esa cultura. El equipo SRE puede RECHAZAR la entrega si el sistema no cumple los estandares de observabilidad y calidad.

**Rubrica (3 puntos):** 2-3 practicas concretas y viables para el dominio del escenario + explicar POR QUE son relevantes para ese negocio especifico.

---

### RIESGOS CRITICOS + MITIGACION

Los riesgos deben ser **coherentes con los drivers y atributos de calidad definidos en P1**. Si en P1 se definio seguridad y disponibilidad, los riesgos deben relacionarse con esas mismas areas.

**Riesgos tipicos segun dominio:**

| Riesgo | Dominio tipico | Mitigacion concreta |
|--------|---------------|---------------------|
| Brecha de seguridad / filtracion de datos | Seguros, finanzas, salud | Cifrado TLS + en reposo; RBAC estricto; pentesting periodico; monitoreo de anomalias |
| Caida en pico de demanda | Cualquier sistema con carga variable | Multi-AZ; auto-scaling; circuit breakers; DRP probado |
| Inconsistencia de datos en sistema distribuido | Microservicios | SAGA; compensating transactions; idempotencia |
| Vendor lock-in | Cloud-native | Abstracciones sobre servicios cloud; IaC portabl |
| Baja adopcion del producto | Startups / MVP | Pilotos controlados; NPS; mecanismos de feedback rapido |

**Como estructurar la respuesta:**
```
Riesgo 1: [nombre claro y especifico]
- Causa: [por que puede ocurrir en este escenario]
- Impacto: [consecuencia para el negocio]
- Mitigacion:
  1. [accion concreta 1]
  2. [accion concreta 2]
  3. [accion concreta 3]
```

**Rubrica (3 puntos):** 2 riesgos bien elegidos y coherentes con el resto del examen + acciones de mitigacion CONCRETAS (no "implementar seguridad" sino "cifrado TLS + RBAC + pentesting trimestral").

---

## Coherencia transversal (criterio de ajuste ±10%)

La rubrica penaliza incoherencias entre partes. Verificar antes de entregar:

- [ ] Los actores del diagrama de contexto aparecen en los escenarios de atributos de calidad
- [ ] Los drivers de P1 se ven reflejados en los riesgos de P2
- [ ] Si se eligieron microservicios en P1.3, la arquitectura en capas de P2.1 tiene microservicios
- [ ] Las medidas de CI/CD (P1.4) son coherentes con las practicas SRE (P2.2)
- [ ] Los riesgos de P2.3 atacan los mismos atributos de calidad definidos en P1.2

---

## Reglas de formato

- Tildes y ñ correctas (es un documento entregable).
- Sin em dashes (---). Usar coma o dos puntos.
- Cada respuesta no debe superar 10 renglones cuando la consigna lo indica.
- Usar tablas para comparaciones, no parrafos repetitivos.
- Diagramas de texto con ASCII cuando no hay herramienta grafica.
- Numerar las respuestas igual que la consigna (P1.1, P1.2, P1.3, etc.).

---

## Checklist de entrega

**Calidad minima:** cada item debe tener puntaje 3 segun la rubrica en `RUBRICA.md`. Si algun item tiene 2 o menos, reescribir antes de continuar.

**Contenido:**
- [ ] P1.1: Diagrama de contexto con sistema central + actores + sistemas externos + flechas direccionales (puntaje: /3)
- [ ] P1.2: 3 drivers justificados + 3 atributos con metricas + al menos 1 escenario de 6 componentes + restricciones (puntaje: /3)
- [ ] P1.3: Posicion arquitectonica clara + 2 ventajas + 2 desventajas con mitigaciones accionables (puntaje: /3)
- [ ] P1.4: Pipeline CI/CD con multiples entornos + despliegue gradual + rollback automatico (puntaje: /3)
- [ ] P2.1: Nuevo driver + diagrama en capas legible + coherente con P1.3 (puntaje: /3)
- [ ] P2.2: 2-3 practicas SRE concretas justificadas para el dominio especifico (puntaje: /3)
- [ ] P2.3: 2 riesgos con causa + impacto + mitigaciones concretas, coherentes con P1.2 (puntaje: /3)

**Coherencia transversal (leer RUBRICA.md para el ajuste):**
- [ ] Actores de P1.1 aparecen en escenarios de P1.2
- [ ] Drivers de P1.2 reflejados en riesgos de P2.3
- [ ] Arquitectura de P1.3 coherente con diagrama de P2.1
- [ ] CI/CD de P1.4 coherente con SRE de P2.2
- [ ] Riesgos de P2.3 atacan los atributos de calidad de P1.2

**Puntaje estimado:** suma /21 → nota = (suma / 21) * 10. Aprobar requiere nota >= 4 (60%).
