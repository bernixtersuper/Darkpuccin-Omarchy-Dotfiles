CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

Práctica

Usted ha recientemente aceptado el puesto de Arquitecto de Soluciones en Seven Sports S.A., empresa
encargada de vender, generar y proveer juegos en forma de game-keys. Se le ha encargado la tarea de producir un
diagrama de arquitectura en AWS según los siguientes requerimientos. Es indispensable que justifique la elección de
todo componente. Aquellas arquitecturas no justificadas no serán válidas.

La solución deberá:
● contemplar

la posibilidad de tener una región secundaria, del estilo activo-pasivo y detectar

automáticamente cuando se necesita redirigir el tráfico a la disaster recovery region.

● soportar únicamente conexiones HTTPs.
● permitir el registro de clientes autenticando con Apple o Google.

La arquitectura deberá:

● poseer un front-end estático al que acceden los usuarios.
● procesar los pagos en crypto usando la API de Talo Payments.
● poseer una capa de datos en la cual se almacenan la cantidad de descargas por juego comprado.
● contemplar que se puedan descargar diferentes versiones del juego que hayan salido dentro de los

últimos 3 años.

● enviar promociones mensuales con descuentos para los usuarios suscritos al Seven Pass.

La capa de aplicación (compras de los juegos) deberá:

● registrar las compras realizadas y procesar los pagos.
● permitir la descarga de los juegos que los usuarios hayan comprado.
● notificar por email al usuario una vez se haya procesado el pago.
● notificar por email al usuario apenas esté listo el juego para ser descargado.
● hacer rollback del proceso de compra del juego si algún punto del procesamiento falla.

El networking y la seguridad deberán:

● contemplar una capa de seguridad que evalúe constantemente las vulnerabilidades en la capa de

aplicación.

● contemplar un emparejamiento con una red on-premise donde se encuentra almacenada una copia extra
de seguridad de los juegos (tener en cuenta que la red on premise tiene el CIDR 10.0.0.0/16 a la hora de
pensar en el esquema de direcciones para la nube).

Las siguientes restricciones y consideraciones aplican para toda la arquitectura:

● agregar dos componentes que generen valor a la arquitectura, en cualquier categoría, y especificar
cuáles son y qué función cumplen (agregar más de dos componentes no relacionados o que no generen
valor restará puntos).

● buenas prácticas de arquitectura.
● python3.10 es el único lenguaje habilitado para todo tipo de procesamiento.
● se debe priorizar utilizar servicios 100% administrados por AWS.

Tenga en cuenta que para la resolución de este enunciado pueden existir múltiples y diversas arquitecturas. En
caso de considerar que falta información en el enunciado, realice un supuesto y ejecute una decisión técnica en base al
supuesto asumido.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

Teoría
Preguntas Múltiple Choice. Sólo una respuesta es válida.

1. ¿Cuál de las siguientes opciones describe mejor la capacidad de una arquitectura en la nube para crecer o

reducir recursos automáticamente según la demanda?

a. Alta disponibilidad.
b. Elasticidad.
c. Escalabilidad.
d. Redundancia.

2. En la nube de AWS, se implementa una aplicación web. Es un diseño de dos niveles compuesto por una capa
web y una base de datos. Los ataques de secuencias de comandos entre sitios (XSS) son posibles en el servidor
web. ¿Cuál es el mejor curso de acción que debe tomar un arquitecto de soluciones para abordar la
vulnerabilidad?

a. Crear un Classic Load Balancer. Poner la web layer atrás del LB y habilitar AWS Shield.
b. Crear un Network Load Balancer. Poner la web layer atrás del LB y habilitar AWS WAF.
c. Crear un Application Load Balancer. Poner la web layer atrás del LB y habilitar AWS Shield.
d. Crear un Application Load Balancer. Poner la web layer atrás del LB y habilitar AWS WAF.

3. Por motivos de seguridad, una empresa exige un entorno aislado dentro de AWS. ¿Qué curso de acción es

necesario para lograr esto?

a.
b.
c.
d.

Crear una Availability Zone independiente para alojar los recursos.
Crear una VPC independiente para alojar los recursos.
Crear un Placement Group para alojar los recursos.
Crear una conexión de AWS Direct Connect entre la empresa y AWS.

4. En Amazon Route 53, ¿cuál de los siguientes es un tipo de política de enrutamiento que se basa en la ubicación

geográfica de los usuarios finales para poder direccionar el tráfico a servidores en regiones específicas?

a. Geoproximity based.
b.
Latency based.
c. Geolocation based.
d. Multivalue.

Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.

1. El SLA de S3 garantiza una disponibilidad del 99.99%.

2. AWS Lambda permite la ejecución de código en respuesta a eventos sin necesidad de aprovisionar servidores.

3. Terraform admite múltiples providers, incluyendo AWS, Azure y Google Cloud Platform.

4. Amazon CloudTrail es un servicio que se utiliza para el monitoreo y administración de registros de internal api

calls.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

Los siguientes enunciados son a desarrollar.

1.

La empresa Queues Encoladas S.A. cuenta con su sistema de búsqueda de empleos con su capa de datos en RDS.

La empresa descubrió que el 90% de las búsquedas suelen realizarse por área, profesión y tipo de contrato. La

empresa no está conforme con el rendimiento actual de su capa de datos, por lo que está considerando migrar a

DynamoDB. Indique cómo plantearía el modelo de datos en esta base y de qué manera esto presentaría un

beneficio.

Opción 1: 3 items por cada empleo o con GSI
PK: #empleos:id
SK: #area:area-id
SK: #profesion:profesion-id
SK: #contrato:contrato-id

Opción 2:
PK: #empleos#id
SK: #area:area-id#profesion:profesion-id#contrato:contrato-id

Conocer los patrones de acceso y diseñar las pk y sk con esta información, optimiza las consultas resultando en
mejor performance.

2. A continuación se visualiza una aplicación de visualización de métricas para el CEO de Uni 4.0, empresa
procesadora de pagos. Asumiendo que la raw data existe previamente en el primer bucket, responda lo
siguiente:

a. Defina una única alternativa a utilizar Glue con Athena y brinde dos limitaciones de la misma.

Opción 1: Podría utilizar una AWS Lambda para procesar los datos. Limitaciones: escalabilidad y tiempo
de procesamiento. Además, al usar Lambda solo puedo usar hasta 10 GB de memoria.

Opción 2: Podría utilizar AWS Batch. Limitaciones: escalabilidad y over engineering.

b. Explique al menos dos ventajas de utilizar RedShift por sobre otras bases de datos, cómo DynamoDB o

RDS/Aurora.

● RedShift es un servicio de data warehousing, especializado en OLAP y no OLTP. Esto es deseable para
análisis de grandes volúmenes de datos, que son los que suelen mostrarse en dashboards de análisis.
● RedShift permite la carga y luego transformación de datos. Así permite ingerir grandes cantidades de

información y consultarla de manera óptima para el dashboard.

● RedShift es read-friendly, en lugar de write-friendly cómo lo serían otras bases de datos.

c.

Identifique al menos tres (3) recomendaciones o riesgos para esta arquitectura.

● Usar lifecycle policies para la información en los buckets s3 o en su defecto borrarla.
● Asegurar que el acceso al dashboard de Quick Sight está solo permitido en un usuario específico para el

CEO de la empresa dado que se estará presentando información sensible.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

● Garantizar que no se filtre información en el bucket con la información procesada.
● Aplicar Macie también al bucket de procesamiento.
● Asegurar que el acceso a RedShift solo esté permitido para los desarrolladores, evitando filtrar

información sensible.

● Monitorear los costos incurridos al usar Glue dado que puede ser un servicio caro.
● Guardar la información de la data curada en un formato eficiente como Parquet para mejorar la

performance de Athena.

Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.

Enunciado

V / F

1. AWS Fargate es el launch type que me permite mayor control sobre la infraestructura a que se

va a desplegar
Fargate, al ser serverless, es quien permite menor control sobre la infraestructura

2. AWS Elastic Beanstalk es una plataforma completamente administrada para desplegar

aplicaciones en la nube

3. El versions.tf es el file que almacena los parámetros necesarios para una ejecución de terraform
Los parámetros suelen almacenarse en los variables.tf y terraform.tfvars files (y los locals.tf en
algunas ocasiones). El versions.tf file indica las versiones de los providers a utilizar

4. AWS IAM (Identity and Access Management) se utiliza para gestionar el acceso a los recursos de

AWS y solo es adecuado para usuarios nominales (humanos)
IAM también permite el manejo de roles y API keys para usuarios de servicio (no humanos),

F

V

F

F

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica

Parcial - Fecha: 01/11/2023 - El examen tiene una duración máxima de 150 minutos.

entre otras cosas

5. AWS CloudFormation es un servicio que permite definir la infraestructura como código y

automatizar su implementación y gestión

6. AWS Direct Connect proporciona una conexión de red dedicada entre su centro de datos local y

AWS, lo que garantiza una latencia extremadamente baja y alta disponibilidad

7. SES es ampliamente utilizado para enviar notificaciones por correo electrónico desde

aplicaciones, mientras que SNS se utiliza para enviar mensajes de texto SMS
SES es utilizado para enviar correos, no tanto notificaciones. SNS permite el envió de SMS pero
también notificaciones por correo

8. Amazon EFS (Elastic File System) es un sistema de archivos que se monta sobre una única

instancia EC2
EFS permite montar un file system que sea cross AZs, por lo general, contemplando varias
instancias

9. Amazon Route53 es un servicio DNS que envía el tráfico a los servidores de menor latencia

Route53 posee una política que permite enviar el tráfico a los de menor latencia, aunque otras
políticas son válidas también

10. AWS Backup es un servicio gratuito que no implica ningún costo adicional en su uso

AWS Backup es gratuito pero, pago por el uso del almacenamiento, cómo por ejemplo, cantidad
de snapshots

V

V

F

F

F

F


