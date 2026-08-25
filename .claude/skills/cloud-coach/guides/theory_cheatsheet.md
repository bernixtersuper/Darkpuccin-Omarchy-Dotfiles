# Cheatsheet de teoria — trampas que se repiten en los examenes

Fuente: MC, completar y V/F de los parciales/finales 2022-2024. Las V/F con respuesta
confirmada vienen del Final 2024 Q2 2do llamado y los parciales catedra.

## Verdadero / Falso — trampas confirmadas
| Enunciado | V/F | Por que |
|---|---|---|
| Terraform/CloudFormation levanta un recurso para GCP **y** AWS con la **misma sentencia** | **F** | Terraform soporta multiples providers pero necesita bloques distintos por provider. CloudFormation es **solo AWS**. |
| CIDR de una VPC puede estar entre /16 y /32 | **F** | Rango valido **/16 a /28**. |
| Redshift es base de **grafos** | **F** | Redshift es **columnar / data warehouse (OLAP)**. Grafos = **Neptune**. |
| Redshift es columnar y permite queries de agrupacion | **V** | Correcto. |
| No se pueden crear **GSIs** en DynamoDB luego de crear la tabla | **F** | GSI se pueden agregar despues. **LSI solo al crear** la tabla. |
| No se pueden crear **LSIs** luego de crear la tabla | **V** | Correcto, LSI solo en creacion. |
| Fargate aprovisiona/maneja/escala clusters de contenedores o K8s | **F** | Fargate es **compute serverless** para containers; **no gestiona clusters**. ECS/EKS gestionan. |
| **ECS** aprovisiona/escala clusters de contenedores o **Kubernetes** | **F** | ECS es orquestador propio de AWS, **no** K8s. K8s = **EKS**. |
| **CloudWatch** registra todas las actividades de usuarios/servicios por defecto | **F** | Eso es **CloudTrail** (API/management events). CloudWatch = metricas/logs/alarmas. |
| En SNS los mensajes se transmiten haciendo **push** | **V** | SNS = push (fan-out). |
| En SQS los mensajes se consumen haciendo **push** | **F** | SQS = **pull/poll** por el consumidor. |
| Mejor ahorro EC2 largo plazo = OnDemand + **Infrequent Access** + Spot | **F** | Infrequent Access es clase de **S3**, no EC2. Correcto: **OnDemand + Reserved + Spot**. |
| Mejor ahorro EC2 = OnDemand + **Reserved** + Spot | **V** | Correcto. |
| Puedo definir **SCPs** con **IAM groups** | **F** | SCPs son de **Organizations** sobre OUs/cuentas, no IAM groups. |
| Site-to-Site VPN conecta red on-premise a la VPC | **V** | Correcto. |
| Una AMI proporciona la info necesaria para lanzar una instancia | **V** | Correcto. |
| Cross-region replication requiere **versioning** activado en el bucket | **V** | Correcto (en origen y destino). |
| Puedo attachear un **rol** a una instancia EC2 | **V** | Via instance profile. |
| SQS permite enviar **notificaciones** | **F** | SQS es cola, no notifica. Notificaciones = **SNS**. |
| Terraform usa un lenguaje basado en **JSON** | **F** | Usa **HCL** (HashiCorp Configuration Language). |
| Activar MFA es obligatorio al asignar una policy a un usuario | **F** | La policy define permisos; MFA es capa extra sobre el login. |
| S3 Intelligent-Tiering mueve a tier mas frio luego de 30 dias sin acceso | **V** | Correcto. |
| Aurora Serverless escala automaticamente | **V** | Correcto. |
| Elastic Beanstalk = plataforma administrada para desplegar apps en la nube (gratis, pago recursos) | **V** | El servicio es gratis, pagas los recursos que levanta. |
| CloudFormation define infra como codigo y automatiza su gestion | **V** | Correcto. Ojo: si el enunciado dice CloudFront -> F. |
| Direct Connect = conexion dedicada on-premise<->AWS, baja latencia y alta disp. | **V** | Correcto. |
| EFS se monta sobre una **unica** instancia EC2 | **F** | EFS es **cross-AZ**, multiples instancias montan simultaneamente. |
| Se puede pasar de Glacier a Standard sin pasar por Infrequent Access | **F** | Para "descongelar" hay que **restaurar**; no se transiciona directo. |
| Se puede correr una imagen Docker en una Lambda | **V** | Lambda soporta container images (hasta 10 GB). |
| Local Zone tiene region padre porque no tiene conectividad propia con AWS | **F** (segun catedra) | La razon del enunciado es incorrecta. |

## Multiple choice — respuestas tipo
| Pregunta | Respuesta |
|---|---|
| Credenciales **temporales** de AWS a usuarios de app mobile para acceder a servicios directamente | **Cognito Identity Pools** (dan credenciales AWS temporales via STS). |
| Conexion de red **dedicada** datacenter local <-> AWS | **Direct Connect**. |
| Consultas **ocasionales** sobre 5 TB en S3, lo mas **rentable** | **Athena** (serverless, pago por query). |
| Conectar **multiples VPCs** de forma **escalable** | **Transit Gateway** (peering no escala bien). |
| Lambda accede a un secreto de Secrets Manager | **IAM role**. |
| Batch **stateless, tolerante a fallos**, max 3h, optimizar costo | **Spot Instances**. |
| Identificar **cuando se termino** una instancia EC2 | **CloudTrail** (registra la API call). EventBridge sirve para **reaccionar** al evento. |
| Credenciales RDS en archivo, minimizar gestion | **Secrets Manager con rotacion automatica**. |
| Sitio "oferta del dia", millones req/hora, baja latencia, menor overhead | S3+CloudFront (front) + **API Gateway+Lambda** (backend) + **DynamoDB + DAX**. |
| Mitigar **XSS** en web server | ALB + **WAF**. (Shield = DDoS, no XSS.) |
| Entorno **aislado** en AWS | **VPC** independiente. |
| Route53 politica por **ubicacion geografica** del usuario | **Geolocation**. (Geoproximity = por distancia/bias; Latency = por menor latencia.) |
| Gateway de internet en una VPC sirve para | Comunicacion entre la VPC e **internet**. |
| Migrar tarea periodica corta (<=5min) + datos JSON a **menor costo operativo** | **Lambda** (compute) + **EventBridge** (schedule) + **DynamoDB** (JSON). |

## Completar (fill-in-the-blank) — respuestas frecuentes
- Almacenamiento **durable** a una EC2 -> se adjunta un **volumen EBS**.
- Orquestar el llamado de multiples **Lambdas** con workflows visuales -> **Step Functions**.
- Seccion logicamente **aislada** dentro de la nube -> **VPC**.
- Message broker ideal para **migracion** de apps a la nube -> **Amazon MQ**.
- Reserved instances: compromiso de **1 o 3 anios**.
- Servicio **gratuito** para desplegar apps web facilmente -> **Elastic Beanstalk**.
- Un **peering** enruta trafico entre VPCs de forma **privada**.
- Analiza configuraciones y **vulnerabilidades** en EC2 -> **Inspector**.
- SLA de S3: **durabilidad 99.999999999% (11 nueves)**, **disponibilidad 99.99%**.
- **NLB** opera en **capa 4 (transporte)**; **ALB** en capa 7 (aplicacion).
- RDS **Multi-AZ** -> **failover automatico** y alta disponibilidad (la replica standby NO sirve lecturas; para leer se usan **Read Replicas**).
- **EFS** para compartir archivos en red con acceso simultaneo.
- **Lambda** escala automaticamente, sin aprovisionar.
- **S3 versioning** mantiene multiples variantes de un objeto.
- **VPC endpoint** para conectar servicios fuera/dentro de una VPC sin internet.
- **terraform.tfstate** hace seguimiento del estado actual de la infra.
- **CloudTrail** monitorea las **internal API calls**.
- **versions.tf** indica versiones de providers; **variables.tf / terraform.tfvars** los parametros; **locals.tf** valores locales.

## Diferencias que suelen preguntar "a desarrollar"
- **API Gateway vs ALB**: APIGW = puerta para APIs REST/HTTP/WebSocket, serverless, integra Lambda, throttling, auth (Cognito/IAM), pago por request. ALB = balanceo L7 HTTP/HTTPS a targets (EC2/ECS/IP), reglas por path/host, pago por hora + LCU. APIGW para serverless/APIs administradas; ALB para apps con backend siempre-on.
- **RBAC vs ABAC**: RBAC asigna permisos por **rol** (grupos); ABAC por **atributos/tags** (`aws:PrincipalTag`, `ResourceTag`). ABAC escala mejor con muchos usuarios/recursos. Ejemplo policy ABAC: `Condition: StringEquals { "aws:ResourceTag/Project": "${aws:PrincipalTag/Project}" }`.
- **Invalidar cache en CloudFront** (3 formas): 1) **Invalidation** (path explicito, cuesta, inmediato); 2) **Versioned object names / query strings** (nombre nuevo por version, no cuesta, mejor practica); 3) **TTL bajo / Cache-Control headers** (expira solo, sin control fino).
- **Modulo de Terraform**: `main.tf` + `variables.tf` + `outputs.tf`. Ventaja: **reusabilidad** y organizacion. Desventaja: esfuerzo de modularizar. Casos: modulo de networking (VPC+subnets+SG), modulo de ECS/containers.
- **Estrategias DR (costo/RTO creciente)**: Backup&Restore < Pilot Light < Warm Standby < Multi-Site (Hot). RTO = tiempo de recuperacion, RPO = perdida de datos tolerable.
