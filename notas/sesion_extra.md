# Terraform

Herramienta de automatización. Uso principal es para despliegues clouds (IaC).

Nos ofrece 2 cosas:
- HCL: DECLARATIVO
- Intérprete
 
## HCL Declarativo

Todas las herramienats que lo petan hoy en día lo hacen por usar un leng. declarativo.
TERRAFORM, ANSIBLE, KUBERNETES, DOCKER COMPOSE, SPRING, ANGULAR
Los lenguajes imperativos son una mierda.
Estamos muy acostumbrados a imperativo.

    Felipe, si hay algo que no sea una silla debajo de la ventana, lo quitas
    Felipe. SI (IF) no hay. una silla debajo de la ventana:
        Si no hay sillas, vete al IKEA y compra una 
    Felipe, pon una silla debajo de la ventana. > IMPERATIVO

    Felipe, debajo de la ventana ha de haber una silla > DECLARATIVO
    
El lenguaje declarativo implica que delego la responsbildiad de conseguir ese 
hecho que quiero conseguiir (estado final) al tercero.

El hecho de usar un lenguaje declarativo > IDEMPOTENCIA

## IDEMPOTENCIA

Da igual el estado del que parta (Estado inicial) siempre conseguimos el mismo estado final.

En HCL lo que hago es describir los recursos con los que voy a operar.
La operación no aparece por ahí.

Al intérprete es al que le damos una orden: APPLY , DESTROY 

# ESTADOS EN TERRAFORM

A la hora de operar con terraform, consideramos 3 estados

    estado deseado de la infra      estado que terraform cree que tengo en real        estado real de la infra
    SCRIPT      >>>> plan <<<<<    .tfstate.                      <<<  refresh  <<<    Lo que hay en el cloud
                                                                         import
                >>>>>>>>>>>>>>>>>>>>>>>>> apply >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                                        

## PROVEEDOR

Para terraform un proveedor es un programa que se integra con terraform... para proveer / gestionar recursos RESOURCES

    script >> interprete >> proveedor [    >> programa en local   ]
                                           >> awscli >>> aws.com
                                           >> az     >>> azure.com

## SCRIPT en terraform

Un script en terraform es una carpeta. LA CARPETA ES EL SCRIPT.
Dentro de esa carpeta encontramos:
- Archivos .tf, que se llaman COMO ME DE LA REAL GANA !
- Archivos .auto.tfvars , que se llaman COMO ME DE LA REAL GANA !
    Valores por defecto de las variables
- Módulos (carpetas mías, .terraform - descargados)
- Proveedores

### Dentro de los archivos .tf

- terraform     Versión de terraform y Declarar los providers que usamos en el script (con su versión)
- provider      Configuración de los providers
- resources     Recursos que gestionamos
- variables     Parametros/Argumentos del script
- locals        Variables al uso... o algo asi
                Expresion a la que pongo un alias. Cuando uso ese alias se evalua la expresion.   
                    Script de la bash
                        #!/bin/bash
                        forma_de_saludo = $1 <---   # PARAMETRO DEL SCRIPT ... Lo que en terraform llamamos variable
                        nombre = "ivan"             # VARIABLE... el equivalente más o menos de un local
                        echo "${forma_de_saludo} ${nombre}"
- output        Datos que queremos poder consultar posteriormente del script.
                Donde se guardan? .tfstate   
                Por defecto, los datos de los recursos se guardan en el tfstate dentro del bloque RESOURCES
                No tengo control de la estructura de ese bloque.
                Lo que quiero es guardarlos bajo el apartado OUTPUTS, donde si tengo control de la estructura
- data          Queries que hacemos al proveedor
- module        Lo que en cualquier lenguaje de programación llamamos una FUNCION, METODO, SUBRUTINA, PROCEDIMIENTO
                Para que creamos en un lenguaje de programación métodos o funciones?
                - Mejorar la estructura / Hacerlo más mantenible
                - Reutilizarlo
                En los script necesito dar la configuracion del proveedor.
                La idea de los módulos es que sean REUTILIZABLES... y si quiero reutilizarlo... 
                puedo atarlo a una configuración? NO ... no lo ato a una configuración concreta...
                    Si lo hago deja de ser reutilizable
                Las configuraciones de los proveedores las ofrecen los SCRIPTS

                Una función en cualquier lenguaje de programación tiene:
                    - Los argumentos que recibe:                 VARIABLES
                    - La salida que produce:                     OUTPUTS
                    - El código que ejecuta:                     RESOURCES + DATA
                        Puedo usar librerías externas:           PROVIDERS
                    - Variables internas que me hacen falta:     LOCALS
                Que es lo mismo que meto en un script... solo que en el script doy ya una CONFIGURACION CONCRETA 
                    de los proveedores.
                Un script bien montado NO DEBERIA NUNCA INVOCAR (usar la palabra) RESOURCE
                Los resources siemrpe deberían ir definidos en modulos.
                    Eso me permite crear script MANTENIBLES en el tiempo
                    
## DEVOPS 

Devops es una filosofía, un movimiento, una cultura en pro de la AUTOMATIZACION !!!!!

Terraform es solo un eslabón más en una cadena muy grande.

JENKINS -> CI -> terraform -> ansible -> ....


# Verbos típicos en terraform

init        Descarga los providers  > .terraform
            Descargar los módulos
validate    Valida la sintaxis del script
plan        Planifica las tareas que deben ejecutarse para alcanzar el estado deseado, 
            en base a lo que terraform conoce del entorno real (info entregada por el provider)
apply       Aplica un plan de ejecución:
            - Puede crear recursos en el proveedor
            - Puede modificar recursos
            - Puede destruir recursos
destroy     Desmantelar la infra... ESTO LO HAGO A LOS 2 años... cuando el proyecto muere
graph       Genera el grafo de dependencias


En el día a día, el flujo es:
 init + apply +apply + apply + apply ...... + destroy
        <----------------------------------->
        Los apply los hago sobre distintas VERSIONES DE LA INFRA. POR ESO HABLAMOS DE IaC
        
# VARIABLES en terraform

Al declarar una variable, al menos damos su descripcion y un tipo de datos.
Puedo adicionalmente definirla como nullable (o no). Qué significa esto?
    Y NO TIENE NADA que ver con dejarla vacia.
    Significa si la variable además de contener datos del tipo declarado, puede contener el dato NULL
    NULL es un dato que existe en terraform.
Adicionalmente validaciones (Siempre que pueda)
Puedo poner un default: NO SE USA NUNCA EN LA VIDA en scripts! FATAL PRACTICA HORRIBLE.
    Los defaults de los scripts de dan en archivs .auto.tfvars
    Los defaults de las variables son PARA LOS MODULOS...
    
    Orden de asignación de valores a las variables en terraform. Precedencia
    Si terraform arranca y tiene una variable eunn script declarada, qué valor le asigna?
    1 - Con el valor suministrado en la invocacion: --var VARIABLE=VALOR
    2 - Con el valor suministrado en un fichero y pasado en la invocación mediante: --var-file FICHERO
    3 - Si está definida en un fichero .auto.tvfars
    4 - Default de la variable
    5 - Lo pide por consola

    
Quiero crear una máquina virtual en azure:
    resource "az_virtual_machine" "mi-vm" {
        name = var.nombre_vm
    }
    variable "nombre_vm" {
        description = "Nombre...."
        type = string
    }
    cuando ejecuto terraform le paso 
        $ terraform apply --var nombre_vm='maquina_bbdd_sql_server-1"'
    
    Qué empiece la fiesta !!!!
    Qué va a pasar cuando pulse ENTER? 
        Voy a tener un error... que me va a dar quién? El proveedor
        Terraform a priori sabe que eso va a fallar? NO
        Y si antes de crear es vm... se han creado otras 17... y 2 redes.. y 20 volumenes... y muchas más mierdas?
            Alli se quedan.
            Me he quedado con una infra a medias... que no sea la de prod... y un upgrade de la infra
    
    ESTO HE DE EVITARLO A TODA COSTA.
        No voy a dejar que un script arranque y comience a crear mierdas SIN TENER "CERTEZA" de que la cosa va a ir bien.
        Al menos intentaré asegurarme de todas las cosas que sé a priori que van a provocar un fallo.
        
## Cuando miro la docu de un resource
Los datos que le puedo configurar son de tipo:
- simple: string, number, boolean, set[], list[], map[]
- block : list / set

cuando configuro el recurso:

resource "tipo" "id" {
    prop_simple = VALOR;
    env = [1,2,3]  # con env definida tipo set(number)
    otra = [1,2,3] # con otra definida como tipo list(number)
    prop_block {
        
    }
}

la diferencia está en que:
    Con un list puedo escribir luego: "for value in tipo.id.otra: "
    Con un set también:               "for value in tipo.id.env: "
    Con un list podría poner:         "tipo.id.otra[0]"
    Eso con un set no se puede hacer. 
        Los set son conjuntos DESORDENADOS DE DATOS... y por tanto no puedo usar las pocisiones para recuperar elemento
        Los list son conjunto ORDENADOS    DE DATOS... y por tanto SI puedo usar las pocisiones para recuperar elemento
        Ambos dos, como conbjuntos que son, son ITERABLES

# BUCLES EN TERRAFORM
    
    RESOURCES EN BUCLE
        for_each (mapa o lista string)  ---> MAPA de RESOURCES
            each.key        CADA CLAVE
            each.value      CADA VALOR
        count    (numero)               ---> LISTA de RESOURCES
            count.index     CADA VALOR
        TRUCO:
            count (expresión condicional) PARA CREAR RECURSOS O NO, CONDICIONALMENTE
    Valores:
        for valor in LISTA: 
        for clave,valor in MAPA:
        (condicion) ? (valor si true) : (valor si false)
        
    Blocks dentro de un Resource:
        dynamic "TIPO DE BLOCK"{
            for_each = LISTA
            iterator = NOMBRE DE CADA VALOR DE LA LISTA
            content {
                // Props que sean
            }
        }
    
# PROVISIONADORES EN TERRAFORM
NO CONFUNDIR CON LOS PROVIDERS ... estamos hablando de PROVISIONERS

Los provisioners se pueden definir dentro de un resource... todos los que quiera.
En terraform hay 3 tipos de provisiones. SOLO. no hay más.

- local-exec
    Sirve para ejecutar un comando en la máquina donde corre terraform cuando:
        - Se crea o modifica el recurso (comportamiento por defecto) NO PUEDO DISTINGUIR ENTRE ELLOS
        - Se elimina (no ocurre por defecto. hay que configurarlo: when: onDestroy)
- remote-exec
    Sirve para ejecutar comandos en un entorno remoto... bajo los mismos supuestos que arriba.
    Con una diferencia... si voy a conectar con un entorno remoto, para ejecutar el él comandos (winrm|ssh)
    Necesito el qué?
        - IP
        - Puerto
        - Usuario
        - Contraseña / clave ssh
        - Certificado (winrm/https)
        - porotocolo: winrm|ssh
    Todo eso se configura en un bloque especial llamado connection
    Todo remote-exec necesita que en el recursoexista un bloque connexion
- file
    Sirve para copiar archivos (o crearlos) en un remoto
    Necesita también de bloque conexión.

# Control de scripts en terraform

REPO DE GIT con el script
Y las personas podrán hacer commits en ese repo. Y merge (fusionar sus cambios)... pero claro, necesito que sepan de git
Básico, si están están escribiendo código.

Cada modulo debería ir a un repo
 ^
Cada script a su propio repo
    main
    variables
    outputs
 ^
Las variables para un entorno a otro repo
    .tfvars
    El que usa un script, no tiene porque tocarlo NI DE COÑA !
    
workspace
No quiero una carpeta con archivos de configuracion de 20 entornos.

# Terraform impotaciones

Antiguamente teníamos:
    terraform import 
    
    1º Defino un resource del tipo que voy a importar, con una configuración (los valroes de dentro) mínima
        Y la que sea... no se va a usar
    2º Se ejecutaba un terraform import tipo.id id(EN EL CLOUD)
            terraform import aws_instance.web 1912908731228970daduhgiasd98329823
            Y esto me rellenaba el fichero .tfstate
        Y después a manita me tocaba mirar ese fichero (los datos que se habia traido)
        Y meterlo ya en la conf del recurso (en el .tf)