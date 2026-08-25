# Como justificar la practica (arquitectura) — lo que separa un 7 de un 10

En la practica la consigna repite: **"Es indispensable que justifique la eleccion de todo
componente. Aquellas arquitecturas no justificadas no seran validas."** La debilidad tipica
(incluso en las soluciones de catedra) es justificar en 3 palabras. El objetivo del coaching
es que Berni justifique **atando cada servicio a un requisito textual del enunciado**.

## Metodo de resolucion en 6 pasos
1. **Subrayar requisitos.** Cada bullet del enunciado (CEO/CTO/CFO/CISO/etc.) es un requisito puntuable. Hacer una lista.
2. **Mapear requisito -> servicio.** Para cada requisito, elegir el servicio AWS y anotar por que.
3. **Ordenar por capas:** Edge/global -> Front -> Auth -> API/App/Compute -> Mensajeria/Desacople -> Datos -> Analytics -> Seguridad -> Networking/VPC -> Gobernanza/DR.
4. **Dibujar dentro de VPC** lo que corresponda (compute, datos privados) y marcar subnets publicas/privadas + AZs. Usar VPC endpoints para servicios AWS.
5. **Chequear restricciones globales:** "100% administrados", "optimizar costos", "buenas practicas", "region prohibida", "solo Python", "sin Cognito", CIDRs sin overlap. Estas restricciones **cambian** decisiones.
6. **Justificar cada componente** con la formula de abajo. Marcar supuestos explicitos donde falte info ("Asumo X, por lo tanto Y").

## Formula de justificacion (1-2 frases por servicio)
> **[Servicio]** porque el enunciado pide **[requisito textual]**; lo elijo sobre **[alternativa]** porque **[criterio: costo / managed / latencia / escalabilidad / desacople / seguridad]**.

Ejemplos buenos:
- "Uso **SQS** entre API Gateway y el compute porque el enunciado pide *desacoplar el procesamiento priorizando la elasticidad*; una cola absorbe picos y evita perder mensajes si el consumidor se satura, cosa que una invocacion sincronica no garantiza."
- "**CloudFront** delante de S3 porque piden *baja latencia a usuarios globales en EEUU y China*; cachea el contenido estatico en edge locations cercanas al usuario. Complemento con **Route53 geolocation** para dirigir a la region correcta."
- "**ECS con Fargate** (no Lambda) para el procesamiento AI porque el algoritmo es in-house y pesado; Lambda tiene limite de 15 min y 10 GB, insuficiente. Fargate es serverless (sin gestionar servidores = *100% administrado*) y escala por demanda (*optimiza costos*)."

Ejemplo malo (lo que hace la catedra y hay que superar): "Cognito para auth. S3 para el front. SNS para notificar."

## Checklist de requisitos -> servicio (memoria rapida)
- "plataforma global / baja latencia mundial" -> CloudFront + Route53 (+ regiones multiples).
- "alta disponibilidad 99.99%" -> Multi-AZ + ALB + Auto Scaling Group.
- "miles de usuarios concurrentes / escalable" -> ASG + ALB, o serverless (Lambda/Fargate) + DynamoDB.
- "front-end estatico responsivo" -> S3 static website + CloudFront.
- "autenticarse con Google/Apple/Amazon/X" -> Cognito (User Pools + Identity Pools con IdP externo).
- "dos tipos de usuario / roles" -> Cognito groups o IAM (RBAC).
- "conexiones seguras / solo HTTPS" -> ACM (certificado) + HTTPS en CloudFront/ALB.
- "datos del usuario / relacional" -> RDS/Aurora. "clave-valor / patrones de acceso" -> DynamoDB.
- "contenido audiovisual / videos / slides / archivos" -> S3.
- "panel / dashboard de metricas" -> QuickSight (+ datos en Redshift/Athena).
- "procesar pagos" -> integrar API externa (Stripe/Talo) via API Gateway; desacoplar con SQS/Step Functions.
- "notificar / recordatorios" -> SNS (push/SMS) o SES (email). Colas de trabajo -> SQS.
- "mostrar contenido progresivamente" -> logica en app + control de acceso a objetos S3.
- "evaluaciones online con resultado inmediato" -> Lambda + DynamoDB (baja latencia).
- "orquestar pasos / rollback / saga" -> Step Functions.
- "analytics sobre archivos de texto" -> Athena (+ Glue catalogo/ETL); data warehouse -> Redshift.
- "monitoreo de seguridad continuo de datos almacenados" -> Macie (S3).
- "proteger de SQLi/XSS" -> WAF. "DDoS" -> Shield. "vulnerabilidades EC2" -> Inspector.
- "detectar amenazas en tiempo real" -> GuardDuty (+ Detective para investigar).
- "encriptar en transito y reposo" -> TLS/ACM en transito; KMS + SSE en reposo.
- "MFA para todos" -> IAM MFA / Cognito MFA.
- "datos historicos / retencion N anios / optimizar costo storage" -> S3 lifecycle -> Glacier / Intelligent-Tiering.
- "replicar datos entre regiones por regulacion" -> S3 CRR / DynamoDB Global Tables / Aurora Global DB.
- "picos de trafico estacionales" -> Auto Scaling (ASG) o serverless (escala solo).
- "microservicios" -> ECS/EKS o Lambda por servicio, desacoplados con SQS/SNS/EventBridge.
- "servicios 100% administrados / reducir carga operativa" -> preferir serverless/managed (Lambda, Fargate, DynamoDB, Aurora Serverless, S3, API Gateway) sobre EC2 auto-gestionado.
- "conectar red on-premise" -> Site-to-Site VPN (CIDR sin overlap) o Direct Connect (dedicada).
- "region secundaria activo-pasivo / DR" -> Route53 failover + replicacion + strategy (pilot light/warm/hot).
- "prohibir region / multiples ambientes / gobernanza" -> Organizations + SCP + IAM Groups + Cross Account roles.
- "ciclo de vida de desarrollo (dev/staging/prod)" -> cuentas separadas en Organizations.

## Errores que restan puntos
- Agregar componentes que no atan a ningun requisito (si el enunciado dice "no agregar componentes sin valor", RESTA).
- Poner CloudFront/S3 y olvidar la restriccion global (ej: "solo Python", "2 regiones").
- Front dinamico en S3 (S3 es estatico; lo dinamico va en compute).
- Usar Lambda para procesos > 15 min o que necesitan acceso al OS.
- No separar tiers en subnets privadas; exponer la base de datos.
- Olvidar VPC endpoints y hacer que todo salga por NAT/IGW.
- No justificar, o justificar con una sola palabra.
