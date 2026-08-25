CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica / Industrial

Parcial - Fecha: 12/06/2024 - El examen tiene una duración máxima de 150 minutos.

Práctica

Usted ha recientemente aceptado el puesto de Arquitecto de Soluciones en www.comelibros.ai, startup cuyo
producto consiste en una página web que permite a los usuarios cargar PDFs de libros y obtener un resumen del mismo
generado con AI. Es indispensable que justifique la elección de todo componente. Aquellas arquitecturas no
justificadas no serán válidas.

La solución deberá:

● Excluir el tráfico proveniente de Rusia y Australia.
● Soportar únicamente conexiones HTTPS.
● Permitir el registro de usuarios autenticándose con su usuario de Amazon o X (Twitter).

La arquitectura deberá:

● Poseer un front-end estático al que acceden los usuarios para cargar sus documentos y leer sus

resúmenes.

● Poseer una capa de datos en la cual se almacenen los datos del usuario y un registro de los resúmenes

solicitados.

● Poseer lo necesario para que a partir de que un usuario sube un documento:

○ Se genera el resumen con AI
○ Se notifica al usuario de que su resumen está listo
○ Se cataloga la metadata del resumen y libro
○ Se almacena esta información en un archivo de texto para luego usar en analytics

La capa de aplicación deberá:

● Poder leer los archivos pdf, procesarlos y generar un resumen en otro archivo de texto utilizando

algoritmos de AI.

● Notificar por email al usuario una vez que el resumen esté listo.
● Contar con un sistema adicional de analytics que ante un nuevo resumen, analice el título, género, autor,

etc. genere un archivo de texto y lo almacene.

● El equipo de analytics deberá poder realizar consultas sobre dichos archivos de texto.

El networking y la seguridad deberán:

● Poder contar con permisos de usuarios desarrolladores de software, devops y analistas de datos.
● Prevenir ataques del tipo DDoS.
● Contar con baja latencia a nivel mundial.
● Contar con monitoreo de seguridad automático y contínuo de los datos almacenados.
● Desacoplar el procesamiento de los documentos de la subida de archivos priorizando la elasticidad .

Las siguientes restricciones y consideraciones aplican para toda la arquitectura:

● Buenas prácticas de arquitectura.
● Los algoritmos de AI utilizados en el procesamiento son desarrollados in-house.
● Se debe priorizar utilizar servicios 100% administrados por AWS.

Tenga en cuenta que para la resolución de este enunciado pueden existir múltiples y diversas arquitecturas. En
caso de considerar que falta información en el enunciado, realice un supuesto y ejecute una decisión técnica en base al
supuesto asumido.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica / Industrial

Parcial - Fecha: 12/06/2024 - El examen tiene una duración máxima de 150 minutos.

Teoría
Preguntas Múltiple Choice. Sólo una respuesta es válida.

1. Para conectar múltiples VPCs entre sí de manera escalable la mejor alternativa es utilizar.

a. VPC Connect
b. VPC Peering.
c. Transit Gateway.
d. NAT Gateway.

2. Para que una función Lambda pueda acceder a un secreto del Secrets Manager deberá contar con un

a.
b.
c.
d.

IAM group.
IAM role.
IAM user.
IAM permission.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica / Industrial

Parcial - Fecha: 12/06/2024 - El examen tiene una duración máxima de 150 minutos.

3. Se cuenta con una aplicación corriendo en una instancia de EC2 que corre una tarea periódica simple cuya
máxima duración es de 5 minutos y se conecta con una base de datos que actualmente corre en otra instancia
EC2. Los datos almacenados actualmente son archivos JSON. Su objetivo es migrar esta arquitectura a una
solución de menores costos operativos.

a. Usar AWS Lambda, Step Functions y Dynamo DB.
b. Usar ECS en modo Fargate y una base de datos Aurora.
c. Usar AWS Lambda, Event Bridge y Document DB.
d. Usar ECS en modo Fargate y una base de datos Json DB.

Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.

1. El SLA de S3 garantiza una durabilidad del 99.999999999%.

2. Un Network Load Balancer (NLB) puede tener reglas a nivel capa 3 (transporte) para distribuir pedidos.

3. Usando RDS, un Multi AZ deployment me permite contar con un failover automático y high availability.

4. EFs es adecuado para compartir archivos y colaborar en red, ya que permite el acceso simultáneo a los mismos

archivos.

Los siguientes enunciados son a desarrollar.

1.

Indique la composición típica, ventajas y desventajas de un módulo de Terraform. Proponga dos casos de uso.

Los componentes de un módulo de Terraform además del main son “variables.tf” y “output.tf”.

La mayor ventaja de un módulo de Terraform es la reusabilidad (permiten reutilizar el código para implementar recursos
similares en otros proyectos o ambientes). A su vez, los módulos permiten también, organizar el código de manera
lógica, lo que es una ventaja cuando se trabaja con diferentes equipos en diferentes proyectos, asi como también
facilitan la realización de cambios en la arquitectura, modificando variables en los módulos.

Las desventajas están asociadas al esfuerzo que implica hacer el código modularizable.

Dos casos de uso pueden ser:

● Módulo que encapsule la configuración del networking, es decir, un módulo que incluya la creación de una VPC,

subnets públicas y privadas y security groups por ejemplo.

● Módulo que encapsule la configuración necesaria para levantar containers usando servicios como ECS.

2. Describir lo que está permitiendo o denegando la IAM policy a continuación. Proponga una modificación para

que solo se puedan crear buckets hasta el 31 de diciembre del 2024 .

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica / Industrial

Parcial - Fecha: 12/06/2024 - El examen tiene una duración máxima de 150 minutos.

{

"Version": "2012-10-17",
"Statement": [

{

},
{

}

"Effect": "Deny",
"Action": "s3:DeleteObject",
"Resource": "arn:aws:s3:::la-scaloneta/private/*",
"Condition": {

"StringNotEquals": {

"aws:username": "admin"

}

}

"Effect": "Deny",
"Action": [

"ec2:StartInstances",
"ec2:StopInstances”

],
"Resource": "*",
"Condition": {

"DateGreaterThan": {

"aws:CurrentTime": "2024-12-31T23:59:59Z"

}

}

]

}

La policy tiene dos statements dentro. El primero, deniega la eliminación de objetos en la carpeta “private” del
bucket “la-scaloneta” a todos los usuarios, excepto al usuario “admin”. El segundo, deniega la capacidad de
iniciar o detener instancias de EC2 para todos los recursos después del 31-12-2024.

Le agrego a la policy en el segundo statement en actions, una acción que sea “s3:CreateBucket”. De ese modo,
modifico la policy para que se puedan crear buckets hasta el 31 de diciembre del 2024 .

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios / Analítica / Industrial

Parcial - Fecha: 12/06/2024 - El examen tiene una duración máxima de 150 minutos.

Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.

Enunciado

V / F

1. AWS Glue es un servicio de AWS fully managed que permite implementar un data warehouse.

Redshift es un servicio de AWS fully managed que permite implementar un data warehouse

2. AWS Elastic Beanstalk es una plataforma completamente administrada para desplegar

aplicaciones móviles en la nube

AWS Elastic Beanstalk es una plataforma completamente administrada para desplegar aplicaciones
en la nube

3. AWS Quick Sight es un servicio que permite controlar el estado de mis recursos de manera

rápida y sencilla.

Amazon QuickSight es un servicio de BI unificado que facilita la compilación de visualizaciones, la
realización de análisis ad hoc y la obtención rápida de información empresarial a partir de los datos.

4. ECR es un proxy que permite reutilizar una pool de puertos para conectarse con ECS en modo

Fargate, dado que este último es serverless.

ECR (Elastic Container Registry) es un servicio de AWS que permite almacenar, administrar y
desplegar imágenes de contenedores.

5. AWS Cloudfront es un servicio que permite definir la infraestructura como código y automatizar

su implementación y gestión

Cloudformation es un servicio que permite definir la infraestructura como código y automatizar su
implementación y gestión

6. AWS Site to Site VPN cuenta con dos tipos de configuraciones de ruteo.

7. Puedo correr una imagen de Docker en una función Lambda

8. Al subir una nueva versión de un archivo a un bucket S3 con versioning activado tengo

consistencia eventual.

9. AWS Direct Connect proporciona una conexión de red dedicada entre su centro de datos local y

AWS, lo que garantiza una latencia extremadamente baja y alta disponibilidad

10. Es posible pasar de Glacier a Standard sin pasar por Infrequent Access

No se puede pasar ni siquiera pasando por Infrequent Access

F

F

F

F

F

V

V

V

V

F


