# Tabla de servicios AWS — resumen + donde ampliar

Basado en `Cloud - Servicios AWS.xlsx` de la catedra. Columnas: **Vive** (scope para dibujar el
diagrama: Region / AZ / VPC / Edge / global AWS) y **Costo** (clave para justificar optimizacion).
Cada categoria referencia su **modulo** (vault Obsidian, ver SKILL.md) y **carpeta de slides**.

Original parseado completo: `.../Cloud - Useful/Cloud - Servicios AWS.md`.

---

## Networking — VPC y conectividad basica
Ref: **Modulo 1** (`2026-03-28 Modulo 1.md`) · Slides `2026-03-04/`, `2026-03-11/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **VPC** | Red virtual logicamente aislada; define el espacio IP (CIDR /16). | Region | Gratis |
| **Subred** | Segmento de IPs dentro de la VPC. Publica (ruta a IGW) o Privada. | AZ | Gratis |
| **Internet Gateway (IGW)** | Da a la VPC salida/entrada a internet; NAT 1:1 IP privada<->publica. | Region | Gratis |
| **NAT Gateway** | Salida a internet de subredes privadas SIN exponerlas a entrantes. Necesita EIP, va en subred publica. | AZ | Pago/hora fijo + por GB |
| **VPC Endpoint** | Conexion privada a servicios AWS sin pasar por internet. Interface (ENI con IP privada) / Gateway (entry en route table, solo S3 y DynamoDB). | AZ (Interface) / Region (Gateway) | Interface: hora+GB · Gateway: **gratis** |
| **Security Group** | Firewall **stateful** a nivel de recurso (ENI/instancia). Reglas in/out, permite referenciar otro SG. | Region | Gratis |
| **NACL** | Firewall **stateless** a nivel de subred. Reglas numeradas, requiere regla de ida Y vuelta. | Region | Gratis |

## Computo
Ref: **Modulo 1** · Slides `2026-03-11/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **EC2** | Maquinas virtuales (instancias). Config: tipo (CPU/RAM), AMI, EBS, key pair, IAM role. | AZ | On-Demand / Reserved / Savings Plans / Spot |
| **Auto Scaling Group (ASG)** | Escala instancias EC2 por demanda (min/desired/max + policies). Da HA y optimiza costo. | Region | Por las instancias activas |
| **Elastic Load Balancing (ELB)** | Distribuye carga, fully managed, DNS unico. **ALB** = L7 HTTP/S, ruteo por path. **NLB** = L4 TCP/UDP, ultra performance, IP estatica. | Region | Por hora + capacidad procesada |

## Almacenamiento
Ref: **Modulo 1** · Slides `2026-03-18/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **EBS** | Disco a nivel bloque persistente para EC2. SSD (gp3 general / io2 critico), HDD (st1 throughput / sc1 economico). | AZ | Pago por uso |
| **EFS** | File system jerarquico, acceso simultaneo multi-instancia, **cross-AZ**. Standard / Infrequent Access. | Region/VPC | Pago por uso |
| **S3** | Objetos en buckets, durabilidad 11 nueves, escala ilimitada. Tiers (Standard, Intelligent-Tiering, IA, One-Zone-IA, Glacier, Deep Archive), versionado, SSE. | Region | Pago por uso |
| **S3 Transfer Acceleration** | Acelera subida a S3 desde clientes lejanos via Edge Location. | Edge | Por datos transferidos |
| **Snowball / Snowmobile** | Dispositivo fisico / camion para mover TB-PB de datos a AWS. | - | Por uso/logistica |

## Redes Hibridas (on-premise <-> AWS)
Ref: **Modulo 1** · Slides `2026-03-25/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **Site-to-Site VPN** | Tunel cifrado IPsec por internet publica entre red local y VPC. Siempre 2 tuneles (HA). VGW (AWS) + Customer Gateway (cliente). | Entre VGW y CGW | Por hora + datos salida |
| **Transit Gateway** | Router central que conecta masivamente muchas VPCs y redes locales. Soporta ECMP. | Region | Por attachment/hora + GB |
| **Direct Connect** | Enlace fisico dedicado (fibra) datacenter<->AWS, sin internet, latencia minima. VIF privada/publica/transito. | Ubicacion DX fisica | Por puerto/hora |

## Edge Networking
Ref: **Modulo 1** · Slides `2026-03-25/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **Route 53** | DNS de AWS + registro de dominios + health checks. Hosted Zones, Alias (gratis), politicas: Simple, Failover, Geolocation, Geoproximity, Latency, Multivalue, Weighted, IP-Based. | AWS global | Por zona + consultas |
| **CloudFront** | CDN: acerca contenido estatico/dinamico al usuario via Edge Locations. Integra WAF, SSL, geo-restriccion. | Edge Locations | Por transferencia salida + requests |
| **Global Accelerator** | Mejora performance (HTTP y no-HTTP) via red privada AWS con IPs Anycast estaticas. TCP/UDP. | AWS global | Tarifa horaria + transferencia |

## Bases de Datos
Ref: **Modulo 2** (`2026-04-19 ... Modulo 2 Guia Estudio.md`) · Slides `2026-04-01/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **RDS** | Relacional administrada (MySQL/PostgreSQL/MariaDB/Oracle/SQL Server). Multi-AZ (HA) y Read Replicas (lectura). | Subred privada | Por instancia + storage |
| **RDS Proxy** | Pool de conexiones administrado; evita saturar puertos, ideal con muchas Lambdas. | Subred privada | Por uso |
| **Aurora** | Relacional compatible MySQL/PostgreSQL, mas performance/HA. Serverless v2 (autoescala), Global Database (multi-region). | Subred privada | Por capacidad (serverless) o instancia+storage |
| **Redshift** | Data warehouse (OLAP) para analisis complejos. Columnar. Redshift Spectrum consulta S3 directo. | VPC | Por nodo/hora + datos (Spectrum) |
| **Athena** | Consultas SQL **serverless** sobre archivos en S3. Schema on read, sin infra. | Region | Por datos escaneados |
| **DMS** | Migra/replica bases manteniendo origen activo. Homogenea/heterogenea + replicacion continua. | VPC | Por instancia + storage |
| **DynamoDB** | NoSQL clave-valor/documento, ms a cualquier escala. LSI/GSI, Global Tables, consistencia eventual o fuerte. On-demand vs provisioned. | Regional | Por requests R/W + storage |
| **DocumentDB** | Documental compatible con MongoDB (JSON). Autoscaling storage a 128 TiB. | VPC | Por instancia + storage |
| **ElastiCache** | Cache en memoria (Redis / Memcached) para bajar latencia. | VPC | Por instancia/nodo |
| **QuickSight** | BI: dashboards y visualizaciones interactivas. Acceso por roles. | AWS/Region | Por autor o por sesion de lector |

## Seguridad
Ref: **Modulo 2** · Slides `2026-04-15/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **IAM** | Identidades y accesos: Usuarios, Roles, Grupos, Policies (JSON). | AWS | Gratis |
| **Cognito** | Auth de usuarios finales en apps web/mobile. User Pools (autenticar quien) + Identity Pools (autorizar en AWS, dan credenciales temporales). | Region | Por usuarios activos mensuales |
| **KMS** | Crea/gestiona claves criptograficas para cifrar. Simetricas/asimetricas, firmas, MAC. | Region | Por clave + requests |
| **CloudHSM** | Hardware dedicado (HSM) con control fisico exclusivo de claves. | VPC | Por instancia/hora |
| **Secrets Manager** | Guarda credenciales/API keys/tokens. **Rotacion automatica**, integra RDS y Lambda. | Region | Por secreto + requests |
| **Shield** | Proteccion **DDoS**. Standard (auto, gratis) / Advanced (avanzada, suscripcion). | AWS/Edge | Gratis (Std) / suscripcion (Adv) |
| **WAF** | Firewall de apps web contra **SQLi/XSS**. Reglas propias o managed. | Asociado a CloudFront/ALB/API Gateway | Por regla + requests |
| **GuardDuty** | Deteccion de amenazas con ML; monitorea continuo (VPC flow, DNS logs, CloudTrail). | Region | Por eventos analizados |
| **Macie** | ML para descubrir/proteger datos sensibles (PII) en **S3**. | Region (S3) | Por buckets + datos |
| **Inspector** | Gestion de vulnerabilidades: analiza EC2, imagenes ECR, Lambda. | En el computo (conectado al recurso) | Por recurso analizado |
| **ACM (Certificate Manager)** | Certificados SSL/TLS para HTTPS, renovacion automatica (ELB, CloudFront). | Region | Gratis |
| **Config** | Audita continuamente la configuracion de recursos vs compliance; correcciones automaticas. | Region | Por recurso + reglas |
| **Security Hub** | Consolida hallazgos de GuardDuty/Inspector/Macie/Config en un panel unico. | Region | Por hallazgos |
| **Detective** | Investiga incidentes (CloudTrail, VPC Flow Logs, GuardDuty). | Region | Por volumen analizado |

## Containers
Ref: **Modulo 3** (`2026-05-10 ... Modulo 3 Guia Estudio.md`) · Slides `2026-04-22/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **ECS** | Orquestacion de contenedores administrada. Launch type EC2 (gestionas instancias) o Fargate (serverless). | VPC | Por recursos subyacentes |
| **ECR** | Registry de imagenes de contenedor; integra con ECS/EKS. | Region | Por storage + salida |
| **Fargate** | Compute **serverless** para contenedores (sin gestionar servidores). Sirve para ECS y EKS. | VPC | Por uso |
| **EKS** | Kubernetes administrado (control plane gestionado). Nodos self-managed / managed / Fargate. | Control plane en AZ, nodos en VPC | Por cluster + compute |

## Serverless y mensajeria
Ref: **Modulo 3** · Slides `2026-04-29/`, `2026-05-06/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **Lambda** | Ejecuta codigo por eventos sin servidores. Multi-lenguaje, **hasta 10 GB RAM**, **max 15 min**. | Subred privada (buena practica) o Region | Por requests + duracion + memoria |
| **API Gateway** | Crea/publica/segura APIs escalables hacia Lambda/EC2. Versiones, ambientes, throttling. | Region | Por requests + salida |
| **Step Functions** | Orquesta multiples Lambdas con workflows visuales (state machine, ASL/JSON). Maneja errores, timeouts, reintentos, rollback. | Region | Por transiciones de estado |
| **SQS** | Colas de mensajes, **desacopla** componentes. Standard (al-menos-una-vez, sin orden) / FIFO (exacta, orden). DLQ, long polling. Consumo **pull**. | Region | Por uso |
| **SNS** | Mensajeria **Pub-Sub push** a multiples suscriptores. Topics, protocolos: Email, SMS, HTTP/S, Lambda, SQS. | Region | Por uso |

## Data Analytics
Ref: **Modulo 4** (`2026-05-24 ... Modulo 4 Guia Estudio.md`) · Slides `2026-05-13/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **Glue** | ETL **serverless**. Data Catalog (metadatos), Crawlers (detectan esquema), ETL Jobs. | Region | Por uso |
| **EMR** | Cluster administrado (EC2) para big data: Spark, Hadoop, Flink. Map-reduce. | VPC | Por el cluster EC2 |
| **Kinesis** | Ingesta/analisis en **tiempo real**. Data Streams / Data Firehose (carga a destino) / Data Analytics (SQL/Flink) / Video Streams. | Region | Por volumen y tipo de flujo |
| **SES** | Envio/recepcion de **email** (marketing y transaccional), con analiticas. | Region | Por correo enviado/recibido |
| **Redshift Spectrum** | Extension de Redshift: SQL directo sobre S3 usando Glue Data Catalog (Parquet/CSV/JSON). | Region | Por datos procesados |

## Disaster Recovery
Ref: **Modulo 4** · Slides `2026-05-20/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **AWS Backup** | Copias de seguridad centralizadas y automatizadas, cross-region/cross-account. Politicas (frecuencia/retencion/lifecycle). | Region | Por volumen respaldado |
| **DMS** | (ver Bases de Datos) Migracion/replicacion continua para Pilot Light / Warm Standby. | VPC | Por instancia + storage |
| **Elastic Disaster Recovery (DRS)** | Replica continua de servidores fisicos/virtuales a AWS; failover/failback automatico, pruebas sin afectar prod. | Region | Por servidores replicados |

## Costos, Gobernanza y Observabilidad
Ref: **Modulo 5** (`2026-06-10 ... Modulo 5 Guia Estudio.md`) · Slides `2026-05-27/`, `2026-06-03/`

| Servicio | Que es | Vive | Costo |
|---|---|---|---|
| **Cost Explorer** | Visualiza y analiza costos/uso en el tiempo; filtros y pronosticos. | Consola AWS | Gratis (consultas); pago por API export |
| **Budgets** | Presupuestos con alertas al superar umbrales; acciones automaticas (SCP restrictiva). | Cuenta management | Por presupuesto activo/dia |
| **Organizations** | Administra multiples cuentas: facturacion consolidada, OUs, **SCPs** (permisos maximos). | AWS | Gratis |
| **RAM (Resource Access Manager)** | Comparte recursos (subredes, Transit GW) entre cuentas de la org. | AWS/Region | Gratis |
| **Control Tower** | Automatiza entorno multi-cuenta seguro (Landing Zone) con guardrails. | Region | Gratis |
| **CloudWatch** | Monitoreo/observabilidad: metricas, logs, eventos, dashboards, alarmas (disparan auto-scaling). | Region | Por uso (capa gratuita) |
| **CloudTrail** | Registra **quien hizo que y cuando** (API calls) para auditoria. Historial 90 dias, Trails a S3, Insights. | Region (+ Global) | Gratis (management events); pago (data events) |
| **Systems Manager** | Gestion operativa centralizada. Session Manager (sin SSH), Patch Manager, Parameter Store, Run Command. | Region | Por uso |
| **Trusted Advisor** | Recomendaciones en tiempo real: 5 pilares (Costos, Rendimiento, Seguridad, Tolerancia a fallos, Cuotas). | AWS | Gratis (basico) / soporte premium |
| **Well-Architected** | Marco para evaluar arquitecturas: 6 pilares (Excelencia operativa, Seguridad, Fiabilidad, Eficiencia, Optimizacion de costos, Sostenibilidad). | - | - |

---

## Atajos de scope (para dibujar bien el diagrama)
- **Dentro de VPC/subred privada:** EC2, RDS, Aurora, DocumentDB, ElastiCache, ECS/EKS nodos, Fargate, EMR, Lambda (buena practica), CloudHSM.
- **Regional (fuera de VPC pero en la region):** S3, DynamoDB, SQS, SNS, Athena, Glue, Kinesis, SES, Step Functions, API Gateway, ECR, KMS, Secrets Manager, Cognito, la mayoria de seguridad/observabilidad.
- **Edge / global AWS:** CloudFront (edge), Route 53 (global), Global Accelerator (global), IAM (global), Shield/WAF (asociado a edge/ALB/APIGW).
- **Gratis (no cuesta dibujarlos):** VPC, subred, IGW, SG, NACL, IAM, ACM, Organizations, RAM, Control Tower, Cost Explorer (consultas), Gateway Endpoint.
