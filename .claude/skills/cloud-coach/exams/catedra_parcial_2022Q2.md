CLOUDCOMPUTING-82.08
Alumno:
Legajo:
Carrera: Informática/GestióndeNegocios
Recuperatorio-Fecha:09/11/2022-Elexamentieneunaduraciónmáxima de120minutos.
Práctica
UstedharecientementeaceptadoelpuestodeArquitectodeSolucionesenlaempresaSinMiedoalParcialSRLy
se le ha encargado la tarea de producir un diagrama de arquitectura en AWS. Los requerimientos establecidos por el
Executive Board se encuentran identificados a continuación en varias categorías. Es indispensable que justifique la
eleccióndetodocomponente.Aquellasarquitecturasnojustificadasnoseránválidas.
Lasolucióndeberá:
● distribuireltráficoentrelasregionesdeus-east-1ysa-east-1
● focalizarel99.9%deltráficoenus-east-1yutilizarsa-east-1parael0.1%restante
● considerar a us-east-1 cómo una región crítica para la interoperabilidad de la aplicación mientras que
sa-east-1servirácomoplandedesastres
Laarquitecturadeberá:
● poseerunfront-endestáticoconunformulariodecontactoparaelusuario
● poseer una capa de aplicación que procese el contact form y guarde un txt plano con los datos
ingresados
● poseerunnivelparaunaDBOracle
● identificarlascargasdetrabajodelsistemayescalarencasodesernecesario
Elnetworkingylaseguridaddeberán:
● identificar los elementos necesarios para el correcto funcionamiento de una vpc (no es necesario
detallarelroutingparalasRT)
● identificarinterfacesoendpointsencasodequelaarquitecturaloprecise
● podermanejarpermisosparalosequiposdeDesarrollo,DevOps,InfoSecyPlataformas
● contemplarlaposibilidaddehardenizartodopuntovulnerableaXSSscripting
● contemplarlaposibilidaddeanalizarvulnerabilidadesentodoniveldelaarquitectura
● registrar todo tipo de cambios en la arquitectura, y en caso delevantarseunsgconCIDR0.0.0.0/0para
el puerto 22, se deberánotificarpormailinmediatamente,asícómotambiénremedirautomáticamente
cambiandoelsourcealdelavpn(seasumequelaipes10.0.0.0/32)
Lassiguientesrestriccionesaplicanparatodalaarquitectura:
● sólosepodráutilizarPythonconFlaskyDjangocomostackdediseñodetodalasolución
● lacapadeaplicacióndebeestarcompletamenteaisladadetodaconexiónsaliente
● aprovecharlomásposiblelassolucionesadministradasparaminimizarelgastooperativo
Lassiguientesconsideracionesdebentenerseencuentaensudiseño:
● optimizacióndecostosasumáximonivelparaaquelloscomponentesnocríticos
● buenasprácticasdearquitectura
Tenga en cuenta que para la resolución de este enunciado pueden existir múltiples y diversas arquitecturas. En
caso de considerar que falta información en el enunciado, realice un supuesto y ejecute una decisión técnica enbaseal
supuestoasumido.

| Otras opciones | válidas:        |                     |                     |       |             |
| -------------- | --------------- | ------------------- | ------------------- | ----- | ----------- |
| ● Usar         | ECS / En        | tal caso considerar | ECR +               | vpc-e |             |
| ● Usar         | ECS + ( Fargate | / EKS).             | Misma consideración |       | de arriba   |
| ● Asumir       | un modelo       | BYOL y              | en lugar de RDS     | usar  | Host propio |
| Opciones no    | válidas:        |                     |                     |       |             |
● Setear el front en S3 sin considerar la restricción de Python para la solución entera
● Usar CloudFront as-is sin tener en cuenta la restricción de las 2 regiones

Teoría
1. Una empresa está creando un sitio web que almacenará fotos estáticas en un S3 bucket. El objetivo de la
empresa es reducir tanto la latencia como el costo de todas las solicitudes futuras. Indique cuál es la mejor
opciónparalograrelobjetivo.
a. AlmacenarlasfotosenAmazonS3-Glacier.
b. DeployarAmazonCloudFrontenfrentedelS3bucket.
c. DeployarunNetworkLoadBalancerenfrentedelS3bucket.
d. ConfigurarunAutoScalingparaajustarlacapacidadautomáticamente.
2. En la nube de AWS, se implementa una aplicación web. Es un diseño de dos niveles compuesto por una capa
web y una base de datos. Los ataques de secuencias de comandos entre sitios (XSS)sonposiblesenelservidor
web. ¿Cuál es el mejor curso de acción que debe tomar un arquitecto de soluciones para abordar la
vulnerabilidad?
a. CrearunNetworkLoadBalancer.PonerlaweblayeratrásdelLByhabilitarAWSShield.
b. CrearunNetworkLoadBalancer.PonerlaweblayeratrásdelLByhabilitarAWSWAF.
c. CrearunApplicationLoadBalancer.PonerlaweblayeratrásdelLByhabilitarAWSShield.
d. CrearunApplicationLoadBalancer.PonerlaweblayeratrásdelLByhabilitarAWSWAF.
Enunciados para completar. Escriba la/s palabras que mejor se ajusten a la oración.
1. S3 permite habilitarlapolíticaObjectLock/WORMparalograrqueunavezelarchivoseescriba,yanosepueda
modificar.
2. Intelligent-TieringeseltierdestoragedeS3quepermiteevaluarlamejoropcióndetiersparacadaarchivoyasí
reducircostos.
3. Amazon Elastic Container Registry (ECR) es un servicioquepermitehostearydeployarimágenesdeaplicacióny
artifacts.
4. AWSCloudFormationeslaherramientanativadeAWSpararealizarIaC.
Los siguientes enunciados son a desarrollar.
1. Uno de los desarrolladores de LunaseencuentratrabajandoenlanuevaLuna2.0.Sinembargo,alcrearalgunos
recursos de networking se dacuentaquealgonoestáfuncionandoynolograresolverqué.Alhacerunaquerya
través de las API disponibles, obtienelasiguienteinformación.Expliquequéesloquenoestáfuncionando(máx
1respuestaválida).

ElCIDRdelasubnetnoescompatibleconelCIDRelegidoparalaVPC.LaIPelegidaesdistintaaladelaVPCyademásla
máscaraindicaríaquelasubredtieneunrangomásampliodedireccionesquelared.
2. Identifique y explique los tres tiposdellavesdeAWSKMSsegúnelmodeloderesponsabilidadcompartida.Sies
posible,déejemplos.
AWSKMSpermitecrear,administrarycontrolarclavescriptográficasdeaplicacionesydeotrosserviciosdeAWS.
Podemos encontrar 3 tipos de claves KMS. La clasificación es según el grado de responsabilidad que tiene el usuario o
AWS(modeloderesponsabilidadcompartida).
● Claves administradas por el cliente. En este tipo de claves el usuario tiene control completo sobre la misma,
incluyendo el establecimiento y el mantenimiento de sus políticas, la rotación, creación de alias y eliminación.
Podría quererse utilizar una clave administrada por el cliente para encriptar un bucket en S3. En general es
recomendable utilizar claves administradas por AWS pero puede ser necesario por cuestionesregulatoriasode
compliance.
● Claves administradas por AWS. Se crean, administran y usan en nombre del usuario poralgúnserviciodeAWS
(dentrodelosquetienenintegraciónconKMS).Elusuariopuedeverlaspolíticasdelasclavesyauditarelusode
las mismas pero no puede cambiar propiedades, rotarlas, cambiar sus políticas o programar la eliminación. De
estoseencargaAWS.PorejemploEBSpodríacrearunadeestasclavesparaencriptarunvolumen.
● Claves propiedad de AWS. Son clavesquesonadministradasyusadasporunservicioenvariascuentasdeAWS.
No es necesario crear ni mantener la clave ni su política, se encarga AWS. Las propiedades de estas claves no
puedenservistasporelusuario.
https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#kms_keys
Preguntas Verdadero / Falso. Las sentencias falsas deben ser justificadas.
Enunciado V/F
1. AmazonRedshiftesunserviciodeBDdeltipoOLTP
F
RedshiftesunserviciodeBDOLAP
2. EsposiblelevantarunaEC2sinasociarningúndisco
F
UnodelosrequisitosparalevantarunaEC2esasociarleundisco
3. LasVPCylassubnetessonrecursosgratuitoseilimitados
V

Tambiénsepuededecir:Falso:Nosonilimitadas.Hayunsoft-limitde5VPCs
porcuentaporregióny200subredesporVPC.Ypuedopedirunincreasedel
quota.
4. LasInstanciasReservadasofrecendescuentosacompromisosdeuno(1)ydos
(2)años F
Soncompromisosde1(uno)y3(tres)años.
5. Serecomiendasóloencriptarlonecesarioyaqueelcostodeencriptación
sueleseralto F
Encrypteverything.
6. EsposiblepasardeStandardaGlaciersinpasarporInfrequentAccess V
7. UnS3bucketnopuedeestarencriptadoconunallavedeKMSyserdeltipo
públicoalmismotiempo F
UnS3puedeestarencriptadoyserpúblicoalmismotiempo.
8. Existealmenoscuatro(4)tiposdediscosenAmazonEBS V
9. AmazonEFSesunserviciodealmacenamientofullymanaged V
10. Lamayoríadelosserviciostienenunfreetierdeun(1)año V
