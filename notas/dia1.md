
# Terraform

Herramienta de software (que hace Hashicorp) que nos ofrece:
- Un lenguaje DECLARATIVO (HCL: Hashicorp Configuration Language) donde definimos scripts.
- Un intérprete con el que realizar tareas sobre nuestro script.

## Para qué sirve?

Automatización de tareas -> Gestión de recursos.

Adquirir, liberar, actualizar recursos contra unos proveedores de recursos (clouds...)

| Recursos    | Proveedor   |
| ----------- | ----------- |
| VM          | AWS...      |
| VM          | VMWare      |
| BBDD        | MariaDB     |
| Entrada DNS | CloudFlare  |
| Clase ssh   | ...         |

El principal uso que hacemos de Terraform es para aprovisionar infra en la nube.

# Automatizar

Montar un programa que ejecuta unas tareas que antes hacíamos de forma manual los humanos.
Un tipo de programa muy especial: SCRIPT.

# DEVOPS

Un movimiento, una cultura, una filosofía en pro de la automatización.
Queremos automatizar todo lo que está entre el desarrollo y la operación de un sistema.
Y parte de ese trabajo es aprovisionar infraestructura.

## Ejemplo 1:

Estamos desarrollando un proyecto de software.
Y necesito una infra donde ejecutar pruebas.... en lugar de crearlo a mano... como hacíamos antes, automatizo su creación, evolución, y su desmantelamiento.

Ventajas: 
- Repetible
- Hoy en día la tendencia es que los entornos de pruebas sean de usar y tirar.

## Ejemplo 2:

Tengo un sistema (software) desarrollado y quiero ponerlo en producción.
Necesito una infraestructura donde ejecutarlo.

- El entorno de producción evolucionará con el tiempo: Nuevas versiones del sistema que quiero montar requerirán nuevos recursos: V1 -> V2 ... y resulta que ahora necesito un cluster de Kafka.
- El entorno de producción irá escalando recursos: Más usuarios, más carga, más recursos. O Menos usuarios, menos carga, menos recursos a lo largo del tiempo... Hoy en día esto cambia incluso por horas... o minutos.

Ventajas: Web telepi: 21:00 (Madrid/Barça) 
                      00:00 Cerrado

En este mundo DEVOPS, la infraestructura / y su gestión es solo un eslabón más de la cadena de automatización.

## Ejemplo1: Desarrollo y pruebas de un sistema: CI

Commit en git -> Jenkins (Azure devops, travis...)
Jenkins -> 
    Crear un contenedor: Donde ejecutar unas pruebas unitarias del código escrito.
    Terraform -> Crear una infraestructura donde ejecutar las pruebas integración/sistema.
    Ansible -> Configurar la infraestructura para que se pueda ejecutar el sistema.
    Instalación de mi software ... Como sea.
    Pruebas:
        - Selenium  \
        - SoapUI     > INFORME DE PRUEBAS
        - JMeter    /
    Al acabar, desmantelo infraestructura -> CLOUD

## Ejemplo2: Poner en producción un sistema: CD

Nueva versión de un producto (artefacto) en un repositorio de artefactos (nexus, artifactory, dockerhub...)
Jenkins -> 
    Terraform -> Crear una infraestructura/ o modificarla, para que se ajuste a la nueva versión/requisitos del software 
    Ansible -> Configurar la infraestructura para que se pueda ejecutar el sistema.
    Instalación de mi software ... Como sea.
    Pruebas de humo

## Ejemplo 3: Operación de un sistema en producción

Escalar la infra para adecuarla a las necesidades del sistema en cada momento.

Monitorización ---> eventos ---> 
Jenkins -> 
    Terraform -> Ajuste de la infra, para adecuar los recursos a las necesidades del sistema.
    Ansible -> Configurar la infraestructura para que se pueda ejecutar el sistema.
    Instalación de mi software ... Como sea.
    Pruebas de humo

---

# Alternativas para trabajar en Clouds a terraform... las hay?

Quiero crear una infra en azure automáticamente... puedo usar terraform...
pero de hecho, azure me ofrece una alternativa: az cli.

Todos los proveedores de cloud tienen algo parecido:
- AWS: aws cli
- GCP: gcloud

Por qué usaría yo una herramienta de un proveedor externo... antes que la propia herramienta que me ofrece un cloud para trabajar con él? Por qué Terraform en lugar de esas herramientas?

    Si monto un script con terraform para generar una infra en AWS...
    Si mañana quiero hacer lo mismo en Azure... puedo reutilizar ese script? puedo reutilizarlo para generar una infra equivalente en IBM Cloud? NI DE COÑA!
    Para IBM Cloud necesitaré montar un SCRIPT totalmente nuevo.... no voy a reaprovechar ni el nombre!

    El script que monte para un despliegue en AWS, será totalmente diferente al que monte para Azure... y al de IBM Cloud... y al de GCP... y al de Digital Ocean... y al de OVH... y al de...

Entonces, dónde está la gracia de Terraform?
- Terraform ofrece un lenguaje DECLARATIVO
- Mientras que esas herramientas hablan un lenguaje IMPERATIVO

Todas las herramientas que triunfan a dia de hoy lo hacen por el uso de lenguajes DECLARATIVOS:
- Ansible, Terraform, Kubernetes, Openshift, docker-compose... LENGUAJE DECLARATIVO
- Spring, Angular... LENGUAJE DECLARATIVO

El lenguaje imperativo es extraordinariamente incómodo para trabajar, ya que me obliga a perder el enfoque.
Cuando hablo lenguaje imperativo dejo de centrarme en lo que quiero conseguir para centrarme en las tareas que otro debe hacer para que yo consiga lo que quiero conseguir.

Ejemplo: 
    Felipe, SI hay algo debajo de la ventana que no sea una silla, lo quitas. LENGUAJE IMPERATIVO (CONDICIONALES: IF)
    EN ESTE CASO: 
    Si no hay sillas, te vas al IKEA a por una silla : LENGUAJE IMPERATIVO
    Felipe, pon un silla debajo de la ventana : LENGUAJE IMPERATIVO

Objetivo: Es que haya una silla debajo de la ventana.

Felipe: Debajo de la ventana ha de haber una silla. LENGUAJE DECLARATIVO
Me centro en mi objetivo... y delego en Felipe el conseguirlo

El problema es que puede haber una cantidad enorme de estados actuales en los que se encuentre mi sistema... y debo tenerlos en la cabeza a la hora de usar un lenguaje imperativo.
Por contra, al usar un lenguaje declarativo, lo que le digo a Felipe es el ESTADO FINAL en el que quiero el sistema.
Felipe debe encargarse de llevar el sistema al estado final que le he dicho... con independencia del estado actual en el que se encuentre mi sistema. Este marrón me lo quito de encima yo... se lo delego a Felipe... y es un huevo de curro.

En nuestros scripts de terraform, lo que haremos será declarar los recursos que quiero manejar/gestionar.
Ese script se lo paso al intérprete de terraform, junto con un verbo: CREA, MODIFICA, ELIMINA... ahí es donde entra en juego el lenguaje imperativo... será el intérprete de terraform el que se encargue de llevar el sistema al estado final que le he dicho... con independencia del estado actual en el que se encuentre mi sistema. Y para ello lo primero que necesitará hacer es planificar todas esas tareas que son necesarias realizar debido al estado actual del sistema.

---

# Scripts de terraform:

En terraform un script es una CARPETA ! No es un archivo.
En esa carpeta tendré 1 o más ficheros .tf... y opcionalmente otro tipo de archivos... que veremos más adelante.

Esos archivos puedo llamarlos como me de la real gana... aunque hay cierto consenso (buenas prácticas) en su nomenclatura:
- main.tf:      Contiene la definición de los recursos que quiero gestionar.
- variables.tf: Contiene la definición de las variables que quiero usar en mi script.
- outputs.tf:   Contiene la definición de las variables que quiero que me devuelva el script al acabar su ejecución.
- versions.tf:  Contiene la definición de las versiones de los proveedores de recursos que quiero usar en mi script.

Cuando le pida a terraform que ejecute alguna operación usando mi script, terraform juntará esos archivos en uno solo. 
De hecho yo podría haber escrito un único archivo con todo el contenido de los 4 archivos anteriores... y terraform lo habría ejecutado igualmente.

El hecho de tener varios archivos es sólo para simplificar la lectura y mantenimiento de los scripts.... LO CUAL NO ES POCO IMPORTANTE.

En esos archivos vamos a encontrar distintos tipos de elementos configurados:
- terraform: Indicar los proveedores de recursos que vamos a usar en nuestro script.                LUNES
- provider: Dar la configuración de esos proveedores de recursos.                                   LUNES
- resource: Definir los recursos que queremos gestionar.                                            LUNES
  
- output:   Permiten extraer información de los recursos para pasarla a otros programas                                                                                       MARTES
- variable... no son variables al uso... como las que definimos cuando                              MARTES / MIÉRCOLES
              trabajos con la bash, py... java...
                Parámetros / Argumentos de entrada al script
              Es lo más complejo de manejar en terraform... por su sintaxis... CON MUCHA DIFERENCIA

- locals: Proporcionar variables del script...aunque tampoco se parecen tanto a las variables 
que usamos en otros lenguajes de programación.                                                      JUEVES
- resources > provisioners                                                                          JUEVES
- data                                                                                              VIERNES (cloud)
- modules                                                                                           JUEVES

La sintaxis de estos archivos HCL es extraña... una mezcla entre JSON y YAML... pero no es ni JSON ni YAML.... con toques del lenguaje de programación GO.

# Intérprete de terraform

Es un programa que se encarga de ejecutar comandos sobre los scripts de terraform (carpetas).

Qué tipo de comandos:
- init          Descargar los proveedores que necesita mi script.
                Otra cosita... que veremos más adelante.
- validate      Validar que mi script está bien escrito.
- refresh
- plan          Planificar las tareas que hay que realizar para llevar el sistema al estado final que le he dicho...
                Eso si... partiendo del estado actual en el que se encuentra el sistema.
- apply         Aplicar ese plan... ejecutar esas tareas:
                - Creación de recursos
                - Modificación de recursos
                - Eliminación de recursos (Quiero pasar de una infra con 2 servidores... a 1 servidor)
                    -> Destruir 1 servidor.
- destroy       Desmantelar la infraestructura que he creado con mi script.... para no usarla más. SE ACABO EL PROYECTO

                Y OJO CON ESTO... ya que:
                En el curso vamos a usar mucho el comando destroy... y eso no es habitual en entornos productivos.

                El flujo de trabajo habitual con terraform es:

                    Monto un script:
                        - init, validate, plan, apply
                    Cambio el script -> v1 
                        - (init), validate, plan, apply
                    Cambio el script -> v2
                        - (init), validate, plan, apply
                    Hasta el infinito y más allá
                    El día en que el proyecto acabe o cierre la empresa...
                        - destroy

                En el curso, vamos a ir eliminando la infraestructura que vamos creando en los distintos ejercicios... para no ir dejando mierda que nos despiste.

- ... output, show, graph,...

# Proveedores en Terraform

Desde el punto de vista de TERRAFORM un proveedor es un programa que se encarga de gestionar recursos de un tipo concreto.
Es decir, alguien al que terraform le puede pedir que cree, modifique o elimine recursos de un tipo concreto.
Ese alguien debe ser un programa, que tendré descargado en mi máquina... y con el que terraform sepa comunicarse.

## Ejemplo 1 de proveedor: AWS
                            comando(binario) terraform
                                v
    Script de terraform -> Intérprete de terraform -> Proveedor de recursos -> aws cli -> Cloud de Amazon
        carpeta(.tf)          apply                         ^
                                                        comando/programa aws
                                                        ^^^
                                                        ESTO DE AQUI ES EL PROVEEDOR DESDE EL PUNTO DE VISTA DE TERRAFORM

## Ejemplo 2 de proveedor: tls
                            comando(binario) terraform
                                v
    Script de terraform -> Intérprete de terraform -> Proveedor de recursos  (par de claves ssh)
        carpeta(.tf)          apply                         ^
                                                        comando/programa
                                                        ^^^
                                                        ESTO DE AQUI ES EL PROVEEDOR DESDE EL PUNTO DE VISTA DE TERRAFORM

Esos programas, los descargamos habitualmente del Terraform Registry: https://registry.terraform.io/

Y ahí encontramos programas creados por:
- Hashicorp: aws, azure, gcp, digitalocean, 
- Proveedores de cloud: aws, azure, gcp, digitalocean, ovh, ... / Empresas externas 
- Particulares... que suben sus programas para tareas concretas

---

# Estados en Terraform

Y es que al trabajar con terraform tenemos que tener en cuenta 3 estados:

     Estado que quiero conseguir: Mi script de terraform
     El estado en el que terraform cree que se encuentra el sistema <- ESTE ES EL QUE NOS LIA!
     Estado real en el que se encuentra el sistema: (habitualmente: Cloud)


     Estados:
                         ---------------------- apply --------------------------->
                         <- plan ->                                  <- refresh
     El que quiero conseguir =~= Lo que terraform conoce de la realidad =~= Realidad
        ^^^                                 ^^^                               ^^^
      MI SCRIPT                         Terraform (.tfstate)                 Cloud

      Muchos de los comandos de terraform, simplemente intentan igualar esos estados...
      Mi objetivo es que sean iguales:
        Que lo que tengo, terraform lo conozca y sea igual a lo que quiero tener.

    Comandos de terraform que interactúan con los estados:
        - plan: Comparar el estado que quiero conseguir con el que terraform conoce de la realidad.
                Comparar el script con el fichero .tfstate 
        - refresh: Actualiza el fichero .tfstate con el estado real del sistema.
          - Habitualmente al solicitarse un plan, terraform ejecuta automáticamente un refresh.
        - apply
Tendré en general pocos problemas, si toda la interacción con el cloud la hago desde terraform... 
Si yo hago cosas en el cloud... sin pasar por terraform... entonces puedo tener problemas. NO ES UNA BUENA POLITICA AL TRABAJAR CON TERRAFORM.

Si decido trabajar con Terraform, lo mejor es que todo lo gestione desde ese momento con Terraform... y me olvide de otras herramientas que me de el cloud.

El fichero .tfstate es CRITICO a la hora de trabajar con terraform. Más me vale tenerlo a buen recaudo.
De hecho el propio terraform irá haciendo automáticamente copias de seguridad de ese fichero... por si acaso.
Que más me vale a mi ir teniendo guardadas...

## Cuántas infras distintas voy a desplegar con un script de terraform? 1?

Una infra es mi entorno de producción: servidores, redes, volumenes... para una app.

Quiero montar un wordpress... y tengo un script de terraform que me ayuda a gestionar la infra que necesito para el despliegue del wordpress:
    - Máquina BBDD x2 (replicación)
    - Máquina Apache x3
    - Balanceador de carga
    - Red... Subnet...
    - Reglas de firewall
      - Egress
      - Ingress

Desde un script que tenga en terraform... cuántas cosas como ésta voy a gestionar... 1?
Y entonces, para el entorno de pruebas de este mismo sistema, tengo otro script?
Y si quiero desplegar esta misma infra, ya que soy un tio que monta webs con wordpress a mis clientes...
    para el cliente 2, tengo otro script?
    y para el cliente 200, otro?

Tener esto así, me va a ocasionar unos problemas de mantenimiento de scripts enormes !!!!

Tendré un UNICO script de infra.
Otra cosa es que lo tenga parametrizado... y en función de la parametrización que le pase, me despliegue una infra u otra.... y gestiones muchas infras desde un único script. ESTO SI !!!!!

Y ahí entra en terraform el concepto de WORKSPACE!

Los workspaces de terraform me permiten usar un UNICO script de terraform para gestionar distintas infras.... cada una con su propia parametrización... y su propio fichero .tfstate

Si yo no defino en que WORKSPACE estoy trabajando, se trabaja en el workspace por defecto asociado al script.
LO CUAL DEBERIA ESTAR PROHIBIDO ... (y restaurar la hoguera para los que lo hagan)
Usar el workspace por defecto = SINONIMO = problemón a la mínima... en cuanto se le vaya a alguien un dedito.

---

# Dónde voy a guardar mi script? En mi disco duro?

En un sistema de control de código fuente: SCM: Git
Estamos creando un script... y como programa que es, lo vamos a guardar en un SCM.

---

Con terraform vamos a gestionar recursos de un proveedor de recursos.
De aquí al jueves a última hora, vamos a hacer uso SOLO de 2 tipos de recursos:
- Ni servidores, ni redes, ni volúmenes.... ni nada de nada.
- Lo que vamos a gestionar con terraform van a ser: Imágenes de contenedores y contenedores.
- Pediremos a Docker (nuestro proveedor externo) esos recursos.

Por qué vamos a usar contenedores en local en lugar de servidores en clouds?
- Porque Terraform tarda en crear un servidor... mientras que un contenedor es instantáneo.
- Los servidores tienen un huevo de opciones de configuración... mientras que los contenedores son más mucho sencillos.
  - Esto nos va a ayudar a centrarnos en aprender terraform... y olvidarnos de las particularidades de los servidores.
- Los servidores en AWS, no tienen nada que ver con los de IBM, ni con los de Azure... cada proveedor tiene unas opciones diferentes de configuración
- Los proveedores de cloud son EXTRAORDINARIAMENTE COMPLEJOS, mientras que Docker es muy sencillo.
- Y al fin y al cabo, los conceptos serán similares entre una VM y un contenedor:
  - Recursos de HW: CPus, Memoria
  - Volúmenes de almacenamiento
  - Redes
  - Imágenes desde las que se crean

---

# Contenedor?

Entorno aislado (en un SO con kernel Linux) donde ejecutar procesos.

VM: Entorno aislado donde ejecutar procesos, con su propio SO <> con los contenedores, en los que no puedo tener un SO (se usa el del host).

---

# Tipos de datos en terraform:

- String: Los ponemos entre comillas: "hola"
- Number: Los escribo tal cual: 17
- Boolean: Escribo true o false, sin comillas ni nada
- Set(???): Colección secuencial de objetos/datos.
            Puedo acceder a los datos de un set iterando sobre ellos (FOR-EACH)       
    Set(String): ["texto","texto2"]
    Set(Boolean): [true, true, false]
- List(???): Colección secuencial de objetos/datos.
            Puedo acceder a los datos de un lista iterando sobre ellos (FOR-EACH)
            pero además, en base a su posición en la lista: milista[3]
    List(String): ["texto","texto2"]
    List(Boolean): [true, true, false]
- Map(???): colección secuencial de objetos/datos.
            Puedo acceder a los datos de un mapa iterando sobre ellos (FOR-EACH)
            pero además, a traves de una clave que he de asociar a cada valor
                mi_mapa["clave1"]
    Map(String): {
                    "clave1" = "texto"
                    "clave2" = "texto2"
                 }    
    Map(Boolean): {
                    "clave1" = true
                    "clave2" = false
                 }
    Las claves en los mapas siempre son textos.
---
Y además están los blocks... que van por otro lao!
Loa blocks los vamos a encontrar como Block List o Block Set
Un block es similar a un map.... pero:
- Tienen un esquema asociado... es decir, las claves que pongo dentro del block vienen prefijadas... 
- No se usa el igual a la hora de separar la propiedad del valor
---

NOTA: NUNCA JAMAS EN LA VIDA hay que leer "los datos del bloque resources" del fichero terraform.tfstate... 
ni usar los datos de salida del terraform show o terraform state show para nada... 
Ni para extraer datos de monitorización ni ostias parecidas.

Esto es una muy mala práctica. Por qué?
NO TENEMOS CONTROL de la estructura de representación de esos datos.
Es el proveedor el que genera esa estructura... y es libre de cambiarla en cualquier momento.

    Jenkinis -> terraform <- Jenkins extraiga la IP -> Ansible

    Script -> terraform -> provider 
                            v1
                            
    terraform -> .tfstate {
                                resources <- Lo rellena el provider
                          }

SOLUCION !
Los outputs de terraform <<<<<

Con los outputs tan solo añadimos dentro también del fichero .tfstate datos, que consultar posteriormente 
o a pelo contra el fichero o con la gracia del comando terraform output.
Pero el tema es que esos datos NO SE AÑADEN en el bbloque JSON "resources",
sino en el bloque "outputs", cuya estructura la gestiono YO !!!
Los outputs me ayudan a definir el API de mi programa (la forma en la que comunicarse con él) con
en concreto la SALIDA de mi programa
Y aunque haya un cambio en el proveedor, y ahora genere los datos de una forma distinta, 
puedo reajustar dentro del script los outputs para que programas externos puedan
seguir comunicandose conmigo de la misma forma. 
LO CUAL FACILITA ENORMEMENTE EL MNTO DE MIS SCRIPTS!

El día 1... quizás tengo un poquito más de trabajo.... NI AUN ASI
Pero el día n, me ahorra un huevo inimaginable de trabajo y problemas!