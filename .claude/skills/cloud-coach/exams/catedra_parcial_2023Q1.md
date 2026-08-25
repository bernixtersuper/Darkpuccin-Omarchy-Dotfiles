CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Carrera:

Informática / Gestión de Negocios

Examen Parcial - Fecha: 24/05/2023 - El examen tiene una duración máxima de 150 minutos.

Práctica

Usted ha recientemente aceptado el puesto de Campeón del Mundo de Soluciones en la empresa Scloudoneta, y
se le ha encargado la tarea de producir un diagrama de arquitectura en AWS. Los requerimientos establecidos por el
Executive Board se encuentran identificados a continuación en varias categorías. Es indispensable que justifique la
elección de todo componente. Aquellas arquitecturas no justificadas no serán válidas.

La solución deberá:

● contemplar el uso de un ciclo de vida de desarrollo, para al menos tres instancias
● prohibir levantar cualquier tipo de recursos sobre la región us-west-2
● gestionar más de 50 usuarios internos de la organización, divididos principalmente en las tres siguientes

categorías: jugadores, cuerpo técnico y directivos.

La arquitectura deberá:

● poseer un front-end estático con un formulario de registro para el usuario
● almacenar de forma encriptada los logs de los usuarios que ingresan al sitio
● generar un uuid para cada usuario registrado
● enviar un mail (luego del registro) a los usuarios registrados con la información de los últimos 3 partidos

jugados de la Selección

● enviar un mail semanal a todos los usuarios con información de las próximas Chiqui Tapia MasterClass,

capturando información de los interesados en este tipo de eventos

● identificar interfaces o endpoints y todo tipo de recursos no mencionados explícitamente en caso de que

la arquitectura lo precise

● tener una capa de protección contra bot control

Las siguientes restricciones aplican para toda la arquitectura:

● se debe priorizar utilizar servicios 100% administrados por AWS
● no se permite la utilización de Amazon Cognito

Las siguientes consideraciones deben tenerse en cuenta en su diseño:

● optimización de costos a su máximo nivel para aquellos componentes críticos
● buenas prácticas de arquitectura
● no deberán agregarse componentes extra que generen costo o complejidad a la arquitectura, a menos

que éstas generen valor a la arquitectura

Tenga en cuenta que para la resolución de este enunciado pueden existir múltiples y diversas arquitecturas. En
caso de considerar que falta información en el enunciado, realice un supuesto y ejecute una decisión técnica en base al
supuesto asumido.

Teoría

Preguntas Múltiple Choice. Sólo una respuesta es válida.

1. Una empresa tiene una aplicación que se ejecuta en instancias de Amazon EC2 y utiliza una base de datos de
RDS Aurora. Las instancias EC2 se conectan a la base de datos mediante credenciales de usuario y contraseña
que se almacenan localmente en un archivo. La empresa quiere minimizar los gastos operativos de la gestión de
credenciales. ¿Qué haría usted como arquitecto de soluciones para lograr este objetivo?

a. Utilizar AWS Secrets Manager y activar la rotación automática.
b. Utilizar System Parameter Store de AWS Systems Manager y activar la rotación automática.
c. Crear un bucket en S3 para almacenar objetos cifrados con una clave de cifrado de AWS Key
Management Service (AWS KMS). Migrar el archivo de credenciales al bucket de S3. Apuntar la
aplicación al bucket de S3.

d. Crear un volumen cifrado de Amazon Elastic Block Store (EBS) para cada instancia de EC2. Adjuntar el
nuevo volumen de EBS a cada instancia de EC2. Migrar el archivo de credenciales al nuevo volumen de
EBS. Apuntar la aplicación al nuevo volumen de EBS.

2.

La misma empresa de e-commerce quiere lanzar un sitio web de una oferta del día en AWS. Cada día contará
con exactamente un producto a la venta durante un período de 24 horas. La empresa quiere poder manejar
millones de solicitudes cada hora con una latencia de milisegundos durante las horas pico. ¿Qué solución
cumplirá con estos requisitos con la menor sobrecarga operativa?

a. Alojar el sitio web en S3 en diferentes buckets de S3. Agregar CloudFront Distributions. Establecer los
buckets S3 como orígenes para las distribuciones. Almacenar los datos del pedido en Amazon S3. Utilizar
EC2 para procesar la infromación y RDS Aurora Serverless para la capa de datos.
Implementar el sitio web en instancias de Amazon EC2 y ejecutar Auto Scaling Groups en varias zonas de
disponibilidad. Agregar un balanceador de carga de aplicaciones (ALB) para distribuir el tráfico del sitio
web. Agregar otro ALB para las API de back-end. Almacene los datos en Amazon RDS para MySQL.

b.

c. Migrar la aplicación completa hacia contenedores. Alojar los contenedores en ECS. Usar el escalador
automático de clústeres de ECS Fargate para aumentar y disminuir la cantidad de pods para procesar
picos en el tráfico. Almacenar los datos en Amazon RDS MySQL.

d. Alojar el sitio web en S3 en diferentes buckets de S3. Agregar CloudFront Distributions. Establecer los
buckets S3 como orígenes para las distribuciones. Utilizar las funciones de Amazon API Gateway y AWS
Lambda para las API de backend. Almacenar los datos en Amazon DynamoDB. Activar DynamoDB
Accelerator.

Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.

1. AWS Lambda escala automagicamente, por lo que no me tengo que preocupar por el aprovisionamiento.

2.

S3 versioning permite mantener múltiples variantes de un objeto en el mismo bucket.

3. Se necesita un/a/s vpc endpoint para conectar servicios fuera y dentro de una VPC.

4. En Terraform, el archivo terraform.tfstate se utiliza para realizar seguimiento del estado actual de la

infraestructura.

Los siguientes enunciados son a desarrollar.

1.

La siguiente imagen muestra una base de datos DynamoDB (modo aprovisionada), con un error de performance.

Se puede apreciar que luego de un pico de escritura (línea recta), la base se cae y deja de funcionar (línea

fluctuante). Explique al menos dos posibles soluciones para que este error no vuelva a ocurrir.

● Cambiar el modo de aprovisionamiento a on-demand, así los WCU y RCU escalan con los picos.

● Aumentar la cantidad de W/RUC acorde a las métricas que me muestra cloudwatch.

● Revisar todas las Keys de la tabla para ver que estén bien parametrizadas.

● [Algunas otras respuestas también fueron aceptadas]

2.

Identifique, para la siguiente arquitectura, al menos 3 riesgos y proponga una solución para cada riesgo descrito.

● Replicar infra en otra AZ para tener redundancia y HA.

● Aislar tiers en subnets separadas y privadas para reducir riesgos de seguridad.

● Agregar Load Balancer y/o Auto-Scaling group para soportar picos en el uso.

● Utilizar WAF para mitigar riesgo de XSS, SQL injection, etc.

● Utilizar Shield para mitigar riesgo de DDoS.

● [Algunas otras respuestas también fueron aceptadas]

3. Un ingeniero está intentando deployar un s3 bucket para almacenar logs, pero dado los requisitos establecidos
por el equipo de seguridad, está encontrando varios problemas a lo largo del camino. Por favor, revise el
siguiente código junto al mensaje de error para asistir en la solución.

El alias no es una forma válida para referenciar una llave de KMS. Cómo para casi todos los recursos, se debería
usar el arn o el id.

Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.

Enunciado

V / F

1. Puedo attachear un rol a una instancia de EC2

2. Amazon SQS permite enviar notificaciones basadas en colas FIFO o Standard

SQS no permite enviar notificaciones.

3. Terraform utiliza un lenguaje de configuración basado en JSON

El lenguaje de terraform para definir configuraciones es HCL (HashiCorp
Configuration Language)

4. Activar el MFA es un requisito obligatorio cuando asigno una policy a un

usuario
Las policies definen permisos / actions. El MFA es un layer adicional de
seguridad sobre, en este caso, el login de los usuarios.

5. Por default, Amazon S3 Intelligent tier mueve los objetos a un tier más frío

luego de 30 días

6. Amazon Aurora Serverless permite escalar automáticamente

7. AWS Forecast permite anticipar el consumo a fin de mes

8. AWS Route53 permite enrutar el tráfico a través de IPs

9. AWS Lambda es siempre una mejor opción por sobre Amazon EC2

No, “depende”. Puedo tener limitaciones en AWS Lambda o puedo tener un
requisito de necesitar acceder a la capa de OS. Cada caso de uso debe ser
evaluado en su particularidad.

10. Existen sólo 2 tipos de Firewalls en AWS, a nivel de red y de aplicación

V

F

F

F

V

V

V

V

F

V


