# Arquitecturas resueltas por la catedra (patrones de referencia)

Estas 4 soluciones fueron corregidas/validadas por los profesores. Los diagramas son
imagenes: aca esta transcrita cada infraestructura componente por componente. Sirven como
plantilla mental. NO hay una unica solucion correcta, pero estos son el "gold standard" de
que servicios usar y como conectarlos. La justificacion en el original es breve; en el examen
hay que justificar MEJOR (ver `../guides/como_justificar.md`).

---

## 1) comelibros.ai — Parcial 2024 Q1 (resumenes de PDF con AI)
Archivo enunciado+teoria: `catedra_parcial_2024Q1.md` | Diagrama: pag 2 del PDF.

**Flujo de entrada (edge):**
- **Route 53** con routing policy **geolocation** (excluir Rusia/Australia en otros casos; aca baja latencia global).
- **CloudFront** para baja latencia (CDN global).
- **AWS Shield** para prevenir DDoS.
- **Front-end estatico en S3**.
- **ACM** para forzar/terminar HTTPS.
- **Cognito** para autenticacion con proveedores externos (Amazon / X / Google).

**Capa de aplicacion (dentro de VPC, multi-AZ, subnets privadas):**
- **API Gateway + Lambda + S3** para la subida de archivos.
- **SQS (Queue)** para **desacoplar** el procesamiento de la subida (elasticidad).
- **ECS (launch type EC2)** para generar el resumen con AI (algoritmos in-house -> imagen propia en **ECR**). Se usa EC2 launch type porque el procesamiento AI es intensivo/largo.
- **SNS** para notificar al usuario que el resumen esta listo Y para disparar el sistema de analytics.
- Segundo **ECS** para catalogar metadata y almacenarla en **S3**.
- **DynamoDB** capa de datos del usuario + registro de resumenes.
- **VPC Endpoints** para acceder a S3/Dynamo/servicios sin salir a internet.

**Seguridad / transversal:**
- **IAM roles**: perfiles software / devops / analistas de datos.
- **Macie** para monitoreo de seguridad automatico y continuo de datos almacenados (S3).
- **ECR** guarda los algoritmos desarrollados in-house.
- **Athena** para analytics sobre los archivos de texto en S3.

**Idea clave del patron:** front estatico S3+CloudFront -> API Gateway+Lambda -> SQS desacopla -> compute (ECS/Lambda) -> SNS notifica + dispara analytics -> Athena sobre S3.

---

## 2) Multi-region activo-pasivo — Parcial 2022 Q2 (Python-only, 2 regiones)
Archivo: `catedra_parcial_2022Q2.md` | Diagrama: pag 2.

**Global:**
- **Route 53** con **Weighted routing policy 99.9% / 0.01%** (activo-pasivo entre `us-east-1` y `sa-east-1`).

**Cada region (espejadas):**
- **ACM + SSL Certificate** (itba.edu.ar) para HTTPS.
- **WAF (XSS)** delante del ALB.
- **ALB internet-facing** + **Auto Scaling Group** (min 1, desired 1, max 2).
- **EC2 OnDemand m4x.large** en la region PRIMARIA (carga estable) / **EC2 spot t2.nano** en la region DR (barato, pasiva).
- Segundo **ALB internal-facing** + WAF + otra capa EC2 (app tier separado del web tier).
- **RDS Primary (Oracle)** + **RDS Replica** dentro de la region; entre regiones **Cross Region Replication** de S3 (snapshots).
- **VPC endpoint (vpce)** hacia S3.

**Seguridad / auditoria (por region):**
- **Conformance Pack** + **AWS Config** (audit infra).
- **SNS -> Lambda (terminate on flight)** para remediacion.
- **AWS Inspector**, **GuardDuty**, **Amazon Detective**.
- **IAM**: grupos DevOps / Desarrollo / Plataformas / InfoSec.

**Otras opciones validas (dictadas por catedra):** usar ECS (con ECR + vpce), ECS + Fargate/EKS, o modelo BYOL con host propio en lugar de RDS.
**Opciones NO validas:** front en S3 ignorando la restriccion de Python para toda la solucion; usar CloudFront as-is sin contemplar las 2 regiones.

**Idea clave:** DR activo-pasivo con Route53 weighted, region primaria robusta (OnDemand) + region DR barata (spot), replicacion RDS+S3, auditoria completa (Config/Inspector/GuardDuty/Detective).

---

## 3) Seven Sports — Parcial 2023 Q2 (game-keys, DR + on-premise + Step Functions)
Archivo: `catedra_parcial_2023Q2.md` | Diagrama: pag 2.

**Global / edge:**
- **Route 53 Failover routing policy** activo-pasivo (`us-east-1` primaria / `us-west-1` DR).
- **ACM** para HTTPS. **Cognito** para registro con Google/Apple.
- **3 buckets S3** para el front-end estatico. **API Gateway**.
- **API externa Talo Payments** (crypto) via IGW.

**Region primaria (VPC 10.10.0.0/16 para NO solapar con on-premise 10.0.0.0/16):**
- Public subnets (10.10.0.0/24, 10.10.1.0/24) con **NAT Gateway**.
- Private subnets (10.10.3.0/24, 10.10.4.6/24) con **AWS Step Functions workflow**: Generacion juego -> Procesar pago -> Registrar compra -> Obtener juegos (orquesta Lambdas, permite **rollback** con Step Functions si falla algun paso).
- **Amazon EventBridge** para promociones. **VPC endpoints** (S3, SNS, DynamoDB).
- **DynamoDB** (Descargas / Pagos / Juegos disponibles). **Bucket S3 con juegos** (versionado, distintas versiones ultimos 3 anios). **SNS** para notificaciones.

**On-premise + DR:**
- **Site-to-Site VPN** hacia Backup Server on-premise (10.0.0.0/16) donde hay copia extra de los juegos.
- Region DR `us-west-1` espejada (front replicado, Dynamo global tables, bucket con juegos replicado).
- **GuardDuty** para detectar vulnerabilidades en la capa de aplicacion.
- **Amazon SES** (via SES Endpoint) para mails de promociones mensuales y notificaciones.

**Idea clave:** transaccion de compra con **Step Functions** (rollback), **Dynamo Global Tables** para multi-region, **Site-to-Site VPN** con CIDR sin overlap, **versionado S3** para versiones de juego.

---

## 4) Scloudoneta — Parcial 2023 Q1 (gobernanza multi-cuenta, sin Cognito)
Archivo: `catedra_parcial_2023Q1.md` | Diagrama: pag 2.

**Gobernanza (lo distintivo de este examen):**
- **AWS Organizations** con **SCPs** aplicadas a la OU **Workloads** (para prohibir levantar recursos en us-west-2 se usa una SCP con condicion de region).
- Cuentas: **development / staging / production** (ciclo de vida, 3 instancias) + cuenta **identity**.
- **Cross Account roles** para acceso entre cuentas.
- **IAM Groups**: jugadores / cuerpo tecnico / directivos (>50 usuarios internos). Sin Cognito (restriccion) -> IAM users/groups.

**Aplicacion:**
- **Route 53 -> CloudFront -> AWS WAF (bot control)**.
- **API Gateway -> S3 (www / logs)**; logs encriptados con **KMS Key**.
- **VPC 10.0.0.0/16 en 3 AZs**: public subnets con **NAT Gateway**, private subnets con **Lambdas**.
- **VPC endpoints (vpce)** hacia **SES** (mails: ultimos 3 partidos + MasterClass semanal), **DynamoDB** (tablas Partidos/Users/Clases), **SNS**.
- **API externa** (ChiquiTapia MasterClass / last Scaloneta games) via IGW.

**Idea clave:** cuando el enunciado habla de "prohibir region", "multiples cuentas/ambientes", "50+ usuarios por rol" -> **Organizations + SCPs + IAM Groups + Cross Account roles**. WAF con **bot control** para el requisito de proteccion contra bots.

---

## Patrones que se repiten en TODOS los examenes
1. **Front estatico** -> siempre S3 + CloudFront (+ ACM para HTTPS, + Shield/WAF).
2. **Auth con proveedor externo (Google/Apple/Amazon/X)** -> Cognito (User Pools + Identity Pools). Si prohiben Cognito -> IAM.
3. **Baja latencia global** -> CloudFront + Route53 (geolocation / latency / geoproximity).
4. **Desacoplar procesamiento** -> SQS (colas) o SNS (fan-out/pub-sub). "Priorizar elasticidad" = SQS.
5. **Notificar por email** -> SES (mails transaccionales/masivos) o SNS (notificaciones/push). Ojo: SES = correo, SNS = notif/SMS/push.
6. **Procesamiento con codigo propio corto/event-driven** -> Lambda. Largo/pesado/AI -> ECS (Fargate o EC2 launch type) con imagen en ECR.
7. **Orquestar pasos con rollback** -> Step Functions.
8. **Capa de datos usuario** -> DynamoDB (NoSQL, patrones de acceso conocidos) o RDS/Aurora (relacional). **Contenido audiovisual/archivos** -> S3.
9. **Analytics sobre archivos en S3** -> Athena (+ Glue para ETL/catalogo). Dashboards -> QuickSight. Data warehouse -> Redshift.
10. **DDoS** -> Shield. **XSS/SQLi** -> WAF. **Monitoreo seguridad de datos (S3)** -> Macie. **Vulnerabilidades EC2** -> Inspector. **Deteccion de amenazas en tiempo real** -> GuardDuty (+ Detective para investigar).
11. **Alta disponibilidad 99.99%** -> Multi-AZ + ASG + ALB. **DR / region secundaria** -> Route53 failover/weighted + replicacion (RDS replica, S3 CRR, Dynamo Global Tables).
12. **Conexion on-premise** -> Site-to-Site VPN (cuidar CIDR sin overlap) o Direct Connect (dedicada, baja latencia).
13. **Gobernanza / prohibir region / multi-ambiente / muchos usuarios** -> Organizations + SCP + IAM Groups + Cross Account roles.
14. **Retencion larga / datos historicos / optimizar costo storage** -> S3 lifecycle a Glacier / Intelligent-Tiering.
15. **Todo dentro de VPC accede a servicios AWS sin internet** -> VPC Endpoints (Gateway para S3/Dynamo, Interface para el resto).
