CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 18/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Práctica

TechnoFarm  es  una  empresa  emergente  de  agricultura  de  precisión  que  está  desarrollando  una
plataforma  innovadora  para  ayudar  a  los  agricultores  a  optimizar  sus  cultivos.  La  empresa  ha
experimentado  un  rápido  crecimiento  y necesita migrar su infraestructura a la nube para mejorar la
escalabilidad,  rendimiento  y  seguridad  de  su  plataforma.  Como  arquitecto  de  soluciones  recién
contratado, se te asigna la tarea de diseñar una arquitectura en AWS que cumpla con los siguientes
requerimientos:

Requerimientos del CEO:

●  La plataforma debe ser accesible globalmente, con énfasis en América del Norte y Europa.
●  Se requiere una disponibilidad del 99.99% para mantener la confianza de los clientes.
●  La solución debe ser rentable y escalable para acomodar el crecimiento futuro.

Requerimientos del CTO:

●

Implementar una arquitectura de microservicios para mejorar la flexibilidad y el mantenimiento
del sistema.

●  Asegurar  que  la  plataforma  pueda  manejar  picos  de  tráfico  durante  las  temporadas  de

siembra y cosecha.

●  Utilizar servicios gestionados siempre que sea posible para reducir la carga operativa.

Requerimientos del CFO:

●  Optimizar  los  costos  de  almacenamiento  a  largo  plazo  para  los  datos  históricos  de  los

cultivos.

Requerimientos del Jefe de Producto:

●  La interfaz de usuario debe cargarse rápidamente en cualquier parte del mundo.
●  Los agricultores deben poder cargar imágenes de sus cultivos para análisis en tiempo real.
●

Implementar  un  sistema  de  notificaciones  para  alertar  a  los  agricultores  sobre  condiciones
climáticas adversas o problemas en los cultivos.

●  Permitir  a  los  agricultores  acceder  a  informes  históricos  de  sus  cultivos  de  forma  rápida  y

eficiente.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 18/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Requerimientos del CISO:

Implementar autenticación multifactor para todos los usuarios.

●
●  Asegurar que todos los datos en tránsito y en reposo estén encriptados.
●
Implementar un sistema de monitoreo de seguridad en tiempo real.
●  Garantizar el cumplimiento de las regulaciones de protección de datos en diferentes regiones.

Requerimientos del Arquitecto de Datos:

Implementar un almacén de datos para análisis a largo plazo

●
●  Asegurar que los datos de diferentes regiones se repliquen para cumplir con las regulaciones

locales.

Requerimientos adicionales:

●  La  plataforma  debe  poder  manejar  diferentes  cargas  de  trabajo: 60% en América del Norte,

30% en Europa y 10% en el resto del mundo.

●  Se  requiere  un  tiempo  de  retención  de  datos  de  7  años  para  cumplir  con  regulaciones

agrícolas.

●  La latencia para las consultas de datos en tiempo real debe ser inferior a 100 ms.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 18/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Teoría
Preguntas Múltiple Choice. Sólo una respuesta es válida.

1.  ¿Cuál es el propósito de tener un gateway de internet dentro de una VPC?

a.  Crear una conexión VPN hacia la VPC
b.  Permitir la comunicación entre la VPC e internet
c.
d.  Equilibrar la carga del tráfico de internet entre las instancias de Amazon EC2

Imponer restricciones de ancho de banda al tráfico de internet

2.  Una empresa ejecuta miles de simulaciones simultáneas utilizando AWS Batch. Cada simulación es stateless, es

tolerante a fallos y se ejecuta durante un máximo de 3 horas.
¿Qué modelo de precios permite a la empresa optimizar los costos y cumplir con estos requisitos?

a.
b.
c.
d.

Instancias Reservadas
Instancias Spot
Instancias Bajo Demanda
Instancias Dedicadas

3.  ¿Qué servicio de AWS puede identificar cuándo se terminó una instancia de Amazon EC2?

a.  AWS Identity and Access Management (IAM)
b.  AWS CloudTrail
c.  AWS Compute Optimizer
d.  Amazon EventBridge

Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.

1.  Con reserved instances tengo un compromiso de ________ o ________ años.
2.  ________ es un servicio gratuito provisto por AWS para desplegar fácilmente aplicaciones web.
3.  Un peering permite enrutar tráfico entre las VPCs de forma _________
4.  ____________________ es un servicio que analiza configuraciones y vulnerabilidades de seguridad en EC2.

Los siguientes enunciados son a desarrollar.

1.  Enumere  las  3  diferentes formas de invalidar caché en CloudFront. Describir cómo funciona cada una de ellas,

sus ventajas y desventajas.

2.  Explique brevemente en qué consisten los patrones Role Based Access Control (RBAC) y Attribute Based Access

Control (ABAC). Brindar un ejemplo de una IAM policy que podría usarse si se optara por implementar ABAC.

CLOUD COMPUTING - 82.08

Alumno:

Legajo:

Final - Fecha: 18/12/2024 - El examen tiene una duración máxima  de 150 minutos.

Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.

Enunciado

V / F

1.  Cloudformation permite, usando el mismo código, levantar una instancia tanto para GCP como

para AWS.

2.  Puedo usar cross-region replication exclusivamente en buckets que tengan el versionado

activado

3.  Redshift es una base de datos columnar que permite hacer queries de agrupación.

4.  No se pueden crear LSIs en DynamoDB luego de la creación de la tabla.

5.  ECS permite aprovisionar, manejar y escalar tus clusters de contenedores o Kubernetes

6.  AWS CloudWatch registra todas las actividades de los usuarios y servicios en la cuenta AWS de

manera predeterminada

7.  En Amazon SQS los mensajes se consumen haciendo push.

8.  La mejor forma de ahorrar costos a largo plazo usando instancias EC2 es usar una combinación

entre On demand,Reserved Instances  y Spot Instances.

9.  Usando IAM groups puedo definir Service Control Policies para todos los miembros de un

grupo, favoreciendo la reutilización de lógica.

10. Una Local Zone cuenta con una región padre dado que no posee su propia conectividad con la

red de AWS.

F

V

V

V

F

F

F

V

F

F


