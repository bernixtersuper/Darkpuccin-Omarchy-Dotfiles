CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 11/12/2024 - El examen tiene una duración máxima  de 150 minutos.

 Práctica

Usted  ha  sido  recientemente  contratado  como  Arquitecto  de  Soluciones  en  www.cursito.com, una startup en
rápido crecimiento cuyo producto principal es una plataforma web que ofrece cursos online y certificaciones en diversas
temáticas.  El  CEO  recientemente  ha  firmado  un  acuerdo  con  un  proveedor  de nube pública (AWS) para abordar los
problemas  y  preparar  a  la  empresa  para  su  siguiente  fase  de  crecimiento.  El  CTO  ha  definido  requerimientos  de
arquitectura que la solución debe complir.

Es  indispensable  que  justifique  la  elección  de  todo  componente.  Aquellas  arquitecturas  no  justificadas  no  serán
válidas.
Sobre la arquitectura y el networking:

●  Debe ser una plataforma global, permitiendo su acceso rápido desde cualquier parte del mundo.
●  Debe ser altamente escalable y capaz de manejar miles de usuarios concurrentes
●  La mayoría de los usuarios de la plataforma se encuentran localizados en Estados Unidos y China. Ofrecer baja

latencia a usuarios globales.

●  Debe garantizar que las conexiones sean seguras.
●  Debe garantizar alta disponibilidad (99,99% de tiempo de actividad)

La plataforma deberá:

●  Poseer  un  front-end  estático  responsivo  al  que  acceden  los  usuarios  puedan  acceder  a  los  cursos  que  ha

comprado y realizar autoevaluaciones.

●  Contar con dos tipos de usuario, administradores de cursos y consumidores de los mismos.
●  Permitir a los usuarios autenticarse con su cuenta de Google.
●  Poseer  una  capa  de  datos  en  la  cual  se  almacenen  los  datos del usuario, sus cursos actuales y evaluaciones

realizadas.

●  Poseer otra capa de datos para almacenar el contenido audiovisual, el cual consta de diapositivas, videos, etc.
●  El  gerente  general  de  la  empresa  ha  solicitado  un  panel  para  monitorear  el  progreso de los alumnos en los

cursos y de las ventas de cursos por administrador.

●  Cada  dos  años  los  profesores  de  los  cursos  deben  actualizar  el  contenido. En caso de no hacerlo, los cursos

pierden vigencia

●  Poder procesar los pagos de los cursos.
●  Mostrar al usuario el contenido de los cursos progresivamente según su avance en el mismo.
●  Al finalizar cada sección del curso los usuarios deben completar una evaluación online con preguntas multiple

choice y obtener los resultados en el momento.

●  Enviar notificaciones a los usuarios para recordarles de realizar las evaluaciones de cada módulo.

Sobre seguridad:

●  Debe contar con monitoreo de seguridad automático y contínuo de los datos almacenados.
●  Debe protegerse de amenazas comunes como SQL injection o XSS.
●  El equipo de seguridad debe poder detectar amenazas en tiempo real.

Es  importante  priorizar  buenas  prácticas  de  arquitectura  y  utilizar  servicios  100%  administrados  por  AWS.

Optimizar costos y utilizar recursos de manera eficiente es relevante.

Tenga en cuenta que para la resolución de este enunciado pueden existir múltiples y diversas arquitecturas. En caso de
considerar que falta información en el enunciado, realice un supuesto y ejecute una decisión técnica en base al supuesto
asumido.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 11/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Teoría
Preguntas Múltiple Choice. Sólo una respuesta es válida.

1.  Una  empresa  necesita  proveer  credenciales  temporales  de  AWS a usuarios de una app mobile para acceder a

servicios directamente. ¿Qué pueden utilizar?

a.  AWS IAM users
b.  Amazon Cognito Identity Pools
c.  Amazon Cognito User Pools
d.  AWS Security Token Service

2.  ¿Qué  servicio  o  característica  de  AWS  permite  a un usuario establecer una conexión de red dedicada entre el

centro de datos local de una empresa y la nube de AWS?

a.  AWS Direct Connect
b.  VPC peering
c.  AWS Direct VPN
d.  Amazon Route 53

3.  Una  empresa  tiene  5  TB  de  datos  almacenados  en  Amazon  S3.  La  empresa  planea  ejecutar  ocasionalmente
consultas sobre estos datos para su análisis. ¿Qué servicio de AWS debería utilizar la empresa para ejecutar estas
consultas de la manera MÁS rentable?

a.  Amazon Redshift
b.  Amazon Athena
c.  Amazon Kinesis
d.  Amazon RDS

Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.

1.  Para agregar almacenamiento durable a una instancia EC2 se adjunta un ___________________.

2.

  ____________________  permite  orquestar  el  llamado  de  múltiples  ________________  usando  workflows

visuales.

3.  Una ____________________________ es una sección lógicamente aislada dentro de la nube.

4.  ________________________ es un message broker ideal para migración de aplicaciones a la nube.

Los siguientes enunciados son a desarrollar.

1.  Explique las principales diferencias entre API Gateway y Application Load Balancer (ALB) en términos de:

a.  Casos de uso principales.

b.  Funcionalidades disponibles

c.  Modelos de costo y escalabilidad.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 11/12/2024 - El examen tiene una duración máxima  de 150 minutos.

2.  Describir  lo  que  está  permitiendo  o denegando la IAM policy a continuación. Proponga una modificación para

que solo se puedan acceder a los archivos del bucket de ejemplo hasta el 1 de julio del 2025.
{ "Version": "2012-10-17",
    "Statement": [ {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::example-bucket",
                "arn:aws:s3:::example-bucket/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:prefix": [
                        "documents/",
                        "images/"
                    ]
                }
            }
        }, {
            "Effect": "Allow",
            "Action": "ec2:StartInstances",
            "Resource": "arn:aws:ec2:us-west-2:123456789012:instance/*",
            "Condition": {
                "StringEqualsIfExists": {
                   "ec2:ResourceTag/Owner": "${aws:username}"
                }
            }
        },{
            "Effect": "Deny",
            "Action": "ec2:TerminateInstances",
            "Resource": "*",
            "Condition": {

        "StringEquals": {
                    "ec2:ResourceTag/Environment": "production"
                }
}

            }
        }]
}

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 11/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.

Enunciado

V / F

1.  Terraform permite levantar un recurso como una instancia para GCP y AWS usando la misma

sentencia.

2.  El CIDR de una VPC puede estar entre /16 y /32

3.  Redshift es una base de datos de grafos que permite hacer queries de agrupación.

4.  No se pueden crear GSIs en DynamoDB luego de la creación de la tabla.

5.  Fargate se encarga de aprovisionar, manejar y escalar tus clusters de contenedores o

Kubernetes

6.  AWS CloudTrail registra todas las actividades de los usuarios y servicios en la cuenta AWS de

manera predeterminada

7.  En Amazon SNS los mensajes se transmiten haciendo push.

8.  La mejor forma de ahorrar costos a largo plazo usando instancias EC2 es usar una combinación

entre On demand, Infrequent Access y Spot Instances.

9.  AWS Site-to-Site VPN permite conectar nuestra red on-premise a nuestra VPC

10. Una AMI proporciona la información necesaria para lanzar una instancia


