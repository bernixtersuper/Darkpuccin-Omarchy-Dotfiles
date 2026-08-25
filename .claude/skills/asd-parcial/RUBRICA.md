# Rubrica de correccion: Parcial ASD 2025

Fuente: criterios del parcial 2025-2C (AutoSeguro). Usar para validar cada respuesta antes de entregarla.

---

## Escala por pregunta (0-3)

| Nivel | Nombre | Criterio general |
|-------|--------|-----------------|
| 3 | Logrado | Cumple todos los criterios; listo para entregar |
| 2 | Parcial | Falta una pieza menor; mejorar antes de entregar |
| 1 | Inicial | Respuesta vaga o generica; reescribir |
| 0 | Sin evidencia | No responde la pregunta |

Si la autoevaluacion da 2 o menos, REESCRIBIR la respuesta.

---

## Criterios por pregunta

### P1.1 - Diagrama de contexto

- **3:** Diagrama claro y legible; actores y flujos (principales) completos; limites bien definidos.
- **2:** Diagrama correcto con omisiones menores o rotulado parcial.
- **1:** Diagrama confuso o incompleto; actores o limites poco claros.
- **0:** No presenta o es ilegible.

**Que buscar:**
- Limites del sistema claros (lo que esta adentro vs. afuera)
- Actores externos completos: usuarios, operadores internos, reguladores si aplica
- Todos los sistemas externos mencionados en el enunciado presentes
- Flechas con direccion que indican flujo de informacion

---

### P1.2 - Drivers + Atributos de calidad + Restricciones

- **3:** Drivers y atributos pertinentes, medibles y trazados al caso; justificacion clara; al menos un atributo con escenario de 6 componentes.
- **2:** Pertinentes pero con metricas vagas o justificacion superficial.
- **1:** Genericos; sin metricas o sin relacion clara con el caso.
- **0:** Ausentes.

**Que buscar:**
- Drivers de negocio priorizados y justificados con el escenario (no genericos)
- Atributos medibles con numeros concretos (%, segundos, dias)
- Relacion con los datos sensibles, regulacion o picos de demanda del caso
- Restricciones coherentes con el dominio (PCI DSS, GDPR, soberania de datos, legacy)

---

### P1.3 - Comparacion arquitectonica (microservicios vs monolito)

- **3:** Posicion clara; desventajas concretas; mitigaciones accionables; reconoce trade-offs.
- **2:** Enumera desventajas validas con mitigaciones genericas.
- **1:** Lista desventajas sin mitigacion o con confusiones conceptuales.
- **0:** No responde.

**Que buscar:**
- Al menos 2 ventajas justificadas con el escenario (no solo "escala mejor")
- Al menos 2 desventajas con mitigaciones ACCIONABLES: SAGA, Kubernetes, OpenTelemetry, contract testing
- Reconocimiento del trade-off: no hay arquitectura perfecta
- Coherencia: si recomienda microservicios, el diagrama de capas de P2.1 debe tenerlos

---

### P1.4 - CI/CD en contexto critico

- **3:** Pipeline conciso con pruebas clave (unitarias / integracion / contrato), despliegue gradual (canary o blue/green) y rollback automatico; justificado para el dominio.
- **2:** Pipeline razonable con alguna pieza faltante (sin rollback o sin pruebas de contrato).
- **1:** Ideas vagas ("testear y desplegar"); sin medidas de control.
- **0:** No responde.

**Que buscar:**
- Multiples entornos: dev, QA, pre-produccion, produccion
- Testing exhaustivo: unitarios, integracion, contrato, seguridad (SAST/DAST), carga
- Despliegue gradual nombrado explicitamente (canary o blue/green)
- Rollback automatico ante metricas de error
- Justificacion del enfoque en el contexto del negocio (por que es critico en seguros/salud/finanzas)

---

### P2.1 - Evolucion del servicio + diagrama en capas

- **3:** Explica la expansion de forma coherente con P1; nuevo driver identificado; diagrama en capas legible con responsabilidades por capa.
- **2:** Idea valida con diagrama basico o faltan capas o responsables.
- **1:** Descripcion difusa; diagrama confuso o ausente.
- **0:** No responde.

**Que buscar:**
- Al menos 1 nuevo driver que justifique la expansion (ej: "interoperabilidad y procesamiento en tiempo real" para IoT)
- Actualizacion del diagrama de contexto con el nuevo sistema/actor
- Diagrama en capas con: Presentacion, API Gateway, Microservicios, Integracion (nueva), Datos, Seguridad transversal
- Coherencia con la arquitectura propuesta en P1.3

---

### P2.2 - Confiabilidad / continuidad del servicio (SRE)

- **3:** Presenta 2-3 practicas SRE concretas y viables, justificadas para el dominio especifico del escenario.
- **2:** Menciona disponibilidad o continuidad pero no ambas; acciones generales sin justificacion del dominio.
- **1:** Ideas muy vagas; sin acciones concretas.
- **0:** No responde.

**Que buscar:**
- Practicas SRE nombradas correctamente (SLOs, Error Budgets, Toil Reduction, Postmortems sin culpa, Chaos Engineering, Observabilidad)
- Cada practica justificada con el escenario: por que es relevante PARA ESE negocio especificamente
- Metricas concretas en los SLOs (ej: 99.95% de siniestros respondidos en < 3s)
- No alcanza con nombrar la practica: hay que explicar su aplicacion al caso

---

### P2.3 - Riesgos criticos + mitigacion

- **3:** 2 riesgos bien elegidos, coherentes con los drivers de P1; acciones de mitigacion concretas y especificas.
- **2:** Riesgos validos con acciones genericas ("implementar seguridad").
- **1:** Riesgos genericos sin relacion con el caso; sin acciones.
- **0:** No responde.

**Que buscar:**
- Riesgos relacionados con los drivers y atributos definidos en P1 (coherencia transversal)
- Estructura clara: causa, impacto en el negocio, 2-3 acciones de mitigacion
- Acciones CONCRETAS: "cifrado TLS + RBAC + pentesting trimestral" no "mejorar la seguridad"
- Coherencia: si en P1 se definieron seguridad y disponibilidad, los riesgos deben atacar esas areas

---

## Coherencia transversal

Ajuste de -1 a +1 sobre la nota final. Verificar:

- [ ] Actores del diagrama de contexto (P1.1) aparecen en los escenarios de atributos (P1.2)
- [ ] Drivers de P1.2 se ven reflejados en los riesgos de P2.3
- [ ] Si P1.3 recomienda microservicios, el diagrama de capas de P2.1 tiene microservicios
- [ ] Las medidas de CI/CD de P1.4 son coherentes con las practicas SRE de P2.2
- [ ] Los riesgos de P2.3 atacan los mismos atributos de calidad definidos en P1.2

**Ejemplos de incoherencia que bajan nota:**
- Driver de confiabilidad en P1 pero sin medidas de continuidad en P2.2
- Atributos de tiempo de respuesta en P1 sin observabilidad en P1.4 o P2.1
- Expansion que contradice el alcance del contexto definido en P1.1

---

## Formula de calculo de nota

```
Parte 1 (P1.1 a P1.4): pondera 40% del total  → max 12 puntos
Parte 2 (P2.1 a P2.3): pondera 60% del total  → max 9 puntos

% total = (suma_P1 / 12 * 0.4 + suma_P2 / 9 * 0.6) * 100

Alternativa simplificada: Nota (%) = (suma_total / 21) * 10
Aplicar ajuste de coherencia transversal al final: -1 a +1.
```

| % total | Nota |
|---------|------|
| < 60% | 2 (desaprobado) |
| 60-65% | 4 |
| 66-80% | 6 |
| 81-90% | 8 |
| > 90% | 9 (+ punto conceptual si corresponde) |

Se aprueba con nota 4 (60%).
