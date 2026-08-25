---
name: cloud-menuqr
description: >
  Skill para trabajar en el proyecto de Cloud Computing (82.08) de ITBA.
  MenuQR es un SaaS de menus digitales para restaurantes. Usar cuando haya
  que hacer deploy, modificar infra Terraform, tocar el backend Java/Quarkus,
  el frontend React/TypeScript, o preparar la demo final (TP4).
---

# MenuQR - Cloud Computing ITBA (2026Q1-G3)

## Rutas clave

```
REPO_LOCAL       = /home/berni/Desktop/Dev/MenuQR/2026Q1-G3/
FORK_REMOTE      = https://github.com/bernixtersuper/2026Q1-G3
GRUPO_REMOTE     = https://github.com/CTepedino/2026Q1-G3
CONSIGNA_TP4     = /home/berni/Desktop/Facultad_Obsidian/82.08 - Cloud Computing/TP4/consigna.md
DEMO_PREP        = /home/berni/Desktop/Facultad_Obsidian/82.08 - Cloud Computing/TP4/Demo Prep - MenuQR TP4.md
APUNTES_OBSIDIAN = /home/berni/Desktop/Facultad_Obsidian/82.08 - Cloud Computing/
```

## Stack tecnico

- **Backend:** Java 21 + Quarkus, arquitectura hexagonal
- **Frontend admin:** React + TypeScript (port 5174 en local)
- **Frontend menu:** React + TypeScript (port 5173 en local)
- **Auth:** AWS Cognito (Amplify SDK en el frontend)
- **Infra:** ECS Fargate + Lambda (Python 3.12) + RDS PostgreSQL 18.3 + RDS Proxy + ALB + SQS + S3 + DynamoDB
- **IaC:** Terraform >= 1.8.5
- **CI/CD:** GitHub Actions
- **Deploy local:** `cp .env.example .env && docker-compose up`
- **Backend rebuild:** `docker-compose up --build backend`

## Arquitectura AWS (rama origin/tp4)

```
Internet -> [WAF] rate limit + KnownBadInputs -> ALB (HTTP 80)
                                                    |
                      ECS Fargate (512 CPU/1024 MB, circuit breaker + rollback)
                         auto scaling CPU (min/max en tfvars) | logs -> CloudWatch
                                         |
                               RDS Proxy -> RDS PostgreSQL 18.3 (Multi-AZ, db.t4g.micro)
                                         |
                               VPC Interface Endpoints: Secrets Manager, SQS, ECR API/DKR
                               VPC Gateway Endpoints: S3, DynamoDB

Frontend admin/menu -> S3 (sitios estaticos publicos, website hosting)
Imagenes platos -> S3 privado via presigned URLs (TTL 1h, sin proxy en Fargate)

EventBridge CRON -> Lambda Orchestrator (en VPC, SG db_client)
                         |
                    SQS ml-training-queue (Standard, visibility 360s, TTL 24h)
                    redrive -> SQS ml-training-dlq (tras 3 fallas, TTL 14 dias)
                         |
                    Lambda Worker (fuera de VPC, regional)
                         |
                    lee DynamoDB (ITEM_VIEW events) -> escribe S3 MREC .bin

CloudWatch Alarms (5) -> SNS {prefix}-alerts -> email opcional
CloudWatch Dashboard {prefix}-operations: ALB, ECS, SQS, Lambda
```

**VPC:** `one_nat_gateway_per_az = true` - 1 NAT GW por AZ (2 en total, HA). Cognito no tiene VPC Endpoint: JWKS descargadas al arrancar por NAT y cacheadas.

**RDS secret:** `manage_master_user_password = true` - RDS crea y rota el secreto automaticamente. ARN en `aws_db_instance.db.master_user_secret[0].secret_arn`.

**Modelo ML:** MREC binario custom (magic `0x4D524543` v4). Cuenta popularidad de ITEM_VIEW por tenant. No usa sklearn. Java lee con `RecommendationModelLoader`. Key S3: `recommendations/{tenantId}/model.bin`.

**Cognito MFA:** `mfa_configuration = "OPTIONAL"` con TOTP software. Cada admin lo activa en Admin > Security.

**ECR lifecycle:** conserva las 10 imagenes mas recientes, elimina el resto.

**AWS Academy constraints:** No CloudFront. LabRole hardcodeado en Terraform (`data.aws_iam_role.lab_role`).

## Deploy via GitHub Actions

**Secrets requeridos en el repo:**
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` (del Learner Lab, expiran en horas)
- `TF_STATE_BUCKET`, `TF_STATE_DYNAMODB_TABLE` (output del workflow "Terraform init remote")

**Orden de workflows (primera vez):**
1. "Terraform init remote" -> copia TF_STATE_BUCKET y TF_STATE_DYNAMODB_TABLE del Job Summary a secrets
2. "AWS deploy" con `use_remote_backend: true` (default)

**Orden de workflows (re-deploy):**
1. Renovar los 3 secrets `AWS_*` desde Learner Lab si expiraron
2. "AWS deploy" directo (el state ya existe en S3)

**Duracion estimada del deploy desde cero:** 20-30 min (RDS Proxy tarda en levantar).

## Build de Lambdas ML (obligatorio antes de terraform apply)

```bash
bash ml-training/scripts/build_lambda_dists.sh
# Usa Docker (public.ecr.aws/sam/build-python3.12) para producir:
# ml-training/lambda_dist/orchestrator/  <- psycopg2-binary compilado para Linux x86_64
# ml-training/lambda_dist/worker/        <- sin deps (boto3 en runtime Lambda)
# Terraform zipea esas carpetas con data.archive_file y las sube como codigo Lambda.
# En Linux sin Docker: LAMBDA_BUILD_NATIVE=1 bash ml-training/scripts/build_lambda_dists.sh
```

## Cognito - Crear usuarios sin email

`COGNITO_DEFAULT` tiene limite de 50 emails/dia y cae en spam. Para demos:

1. AWS Console -> Cognito -> User Pool -> Users -> Create user
2. Seleccionar "招待を送信しない" (no enviar invitacion)
3. Marcar "E メールアドレスを検証済みとしてマークする"
4. Poner password manual

5. Despues de crear, ejecutar via CLI para sacar el FORCE_CHANGE_PASSWORD:
```bash
aws cognito-idp admin-set-user-password \
  --user-pool-id <us-east-1_xxxxxxxx> \
  --username <email> \
  --password <password> \
  --permanent \
  --region us-east-1
```

**User Pool ID actual:** `us-east-1_YnY5ej72e`

**Password policy:** 12+ chars, mayus, minus, numero, simbolo.

## Costos estimados (AWS Academy)

| Recurso | $/hr | 72 hs |
|---|---|---|
| NAT Gateway (1, single) | $0.045 | ~$3.25 |
| VPC Endpoints x4 (Interface) | $0.04 | ~$3-6 |
| RDS Multi-AZ | $0.032 | ~$2.30 |
| RDS Proxy | $0.030 | ~$2.15 |
| ECS Fargate | ~$0.02 | ~$1.50 |
| ALB | $0.008 | ~$0.60 |
| **Total** | | **~$13-16** |

Presupuesto Academy: $100. Hacer `terraform destroy` despues de la demo.

## Archivos Terraform clave

```
terraform/
  vpc.tf              # VPC module (one_nat_gateway_per_az=true, 2 AZs, 6 subnets)
  vpc_endpoint.tf     # Gateway (S3/DynamoDB) + Interface (SM/SQS/ECR) endpoints + SGs
  waf.tf              # WAFv2 rate limit + KnownBadInputs (var.waf.enabled)
  rds.tf              # RDS PostgreSQL 18.3 + RDS Proxy + SGs (manage_master_user_password)
  cognito.tf          # User pool + MFA TOTP opcional (mfa_configuration=OPTIONAL)
  ecs.tf              # Fargate + circuit breaker + auto scaling CPU + CloudWatch logs
  alb.tf              # Load balancer (HTTP 80, health check /q/health/ready)
  lambdas.tf          # ml_orchestrator (VPC) + ml_worker (regional) + SQS + DLQ + EventBridge
  cloudwatch.tf       # Log groups + Dashboard operations + 5 alarmas -> SNS
  sns.tf              # Topic {prefix}-alerts + subscripcion email (var.alert_email)
  dynamo.tf           # Tabla menuqr-events (PAY_PER_REQUEST, PK+SK)
  s3.tf               # Modulos s3-private (images, ml) y s3-public-website (admin, menu)
  ecr.tf              # Repositorio Docker del backend (scan_on_push, lifecycle 10 imgs)
  locals.tf           # name_prefix, CIDRs, bucket names, db_jdbc_url, cors_allowed_origins
  outputs.tf          # backend_api_url, frontend_*_website_url, backend_ml_s3_bucket, etc.
  variables.tf        # aws_region, project_name, vpc_cidr, db, backend, ml_training, waf, alert_email
  terraform.tfvars    # GITIGNORED: valores reales (project_name, etc.)
  backend.tf          # Config del backend S3 (se genera con init remote)

modules/
  python-lambda/      # Zipea source_dir + sube Lambda; opcional vpc_config; log_retention
  s3-private/         # Bucket privado, versionado, sin acceso publico
  s3-public-website/  # Bucket con website hosting habilitado

.github/workflows/
  aws-deploy.yml          # Deploy completo (Terraform + ECR + ECS + S3)
  terraform-init-remote.yml  # Bootstrap S3 backend para TF state
```

## Outputs Terraform utiles

```bash
terraform -chdir=terraform output backend_api_url
terraform -chdir=terraform output frontend_admin_website_url
terraform -chdir=terraform output frontend_menu_website_url
terraform -chdir=terraform output backend_ml_s3_bucket   # nombre del bucket ML (no ml_s3_bucket)
terraform -chdir=terraform output cognito_user_pool_id
terraform -chdir=terraform output cognito_user_pool_client_id
terraform -chdir=terraform output db_proxy_endpoint
```

## Estado del orden de flujo en OrdersPage

```
SUBMITTED -> CONFIRMED -> PREPARING -> READY -> DELIVERED -> BILL_REQUESTED -> PAID
```

- Vista activa excluye solo CANCELLED y PAID (DELIVERED se mantiene visible porque la mesa puede tener multiples ordenes en curso)
- Endpoint: `POST /orders/{id}/paid`

## Troubleshooting comun

**"The security token included in the request is invalid"**
-> Las credenciales AWS Academy expiraron. Renovar los 3 secrets `AWS_*` desde el Learner Lab.

**"Faltan secrets obligatorios: TF_STATE_BUCKET TF_STATE_DYNAMODB_TABLE"**
-> Correr "Terraform init remote" primero y agregar esos secrets con solo el valor (sin el nombre de la variable).

**"502 Bad Gateway" al descargar modulos Terraform**
-> Error transitorio del registry. Re-run el workflow.

**RDS Proxy target UNAVAILABLE reason=None**
-> Estado transitorio al levantar desde cero. El fix en `aws-deploy.yml` trata `reason=None` como PENDING y sigue esperando.

**Frontend admin muestra CONFIRM_SIGN_IN_WITH_NEW_PASSWORD_REQUIRED**
-> El usuario fue creado por admin y tiene FORCE_CHANGE_PASSWORD. Usar `admin-set-user-password --permanent` via CLI (ver seccion Cognito arriba).

**Lambda falla con "No module named psycopg2._psycopg"**
-> El build de las Lambdas se hizo en el host (no en Docker). Correr `build_lambda_dists.sh` con Docker y re-hacer terraform apply.

**ECS deployment queda stuck o hace rollback automatico**
-> El circuit breaker esta activo. Si el nuevo deploy no pasa el health check de ALB en `/q/health/ready`, ECS revierte a la task definition anterior. Revisar logs en CloudWatch `/ecs/menuqr-backend`.

**DLQ tiene mensajes**
-> El Worker ML fallo 3 veces para ese tenant. Ver el mensaje en SQS > ml-training-dlq > Poll, copiar el `tenant_id` e invocar el Worker manualmente. La alarma CloudWatch ya deberia haber notificado por email.

## Cuando llamar a otras skills de Terraform

| Skill | Cuando usarla en este proyecto |
|---|---|
| `terraform-style-guide` | Al escribir o revisar cualquier `.tf` nuevo: nombrado de recursos, estructura de variables, outputs, locals |
| `terraform-test` | Si hay que escribir pruebas `.tftest.hcl` para los modulos custom (`python-lambda`, `s3-private`, `s3-public-website`) |
| `terraform-search-import` | Si un recurso AWS ya existe fuera del state (ej: el profesor crea algo en consola y hay que importarlo con `terraform import`) o si el state se corrompe y hay que recuperar recursos |
| `refactor-module` | Si hay que extraer mas modulos del `terraform/` principal, o mejorar la interfaz de los modulos existentes (variables, outputs, README) |
| `azure-verified-modules` | No aplica para este proyecto (es AWS) |

## Orientacion inicial al invocar

Leer en paralelo:
1. `terraform/terraform.tfvars` (gitignored; pedir al usuario project_name si es necesario)
2. `terraform/rds.tf` si hay problemas con la DB o el proxy
3. `terraform/lambdas.tf` si hay problemas con el pipeline ML
4. `.github/workflows/aws-deploy.yml` si hay problemas con el CI/CD
