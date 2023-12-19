# API de un script

Cuando montamos un script de terraform, hemos de tener en cuenta que se va a integrar dentro de un flujo mayor de trabajo:
- Pipeline de CI
- Pipeline de CD

Tendremos una herramienta tipo Jenkins encargada de orquestar todo el flujo de trabajo/información en esos pipelines.

    Jenkins (Pipeline de CI)        ---> 3, 4, 5
        v^                  v^
        IP                  IP
        v^                  v^
    Terraform                  Ansible ....
    (1) crear infra            (2) configurar la infra

Cuaquier programa tiene sus entradas y sus salidas... eso es lo confirma su API: LA FORMA EN LA QUE ME COMUNICO CON EL PROGRAMA!

Los outputs nos ayudan a estabilizar el API de salida de un programa terraform.
Las variables de terraform, MUY MAL LLAMADAS VARIABLES, nos ofrecen la forma de definir el API de entrada de mi script terraform.
Un nombre mucho más adecuado sería: ARGUMENTOS o PARAMETROS

        $ cp RUTA_ORIGEN RUTA_DESTINO
                arg1        arg2

Lo que queremos montar es un UNICO script reutilizable para gestionar multiples escenarios (entornos):
- Desarrollo, pruebas, producción
- Cliente1, cliente2, cliente3
- App1, app2, app3

Y para ello, vamos a PARAMETRIZAR esos scripts

# Forma de dar valor a una variable en terraform 

Lo primero, decir que si terraform no consigue valor para una variable NO ARRANCA.
En terraform no existe el concepto de variable opcional!

Obtener el valor de una variable:
- Por linea de comandos... de la forma: --var NOMBRE_VARIABLE=VALOR
    OS GUSTA ESTO? NO
    Donde queda registrado el valor que hemos usado para llamar al script?
        NO HAY REGISTRO... jodido voy
        No tengo forma de saber con que valor he llamado al script ayer... antes de ayer....
    Y a éste, le doy algún uso?
        - Pruebas rápidas
        - Cuando no quiera dejar registro: credenciales
- Mediante un fichero de variables, que suministro mediante el parametro --var-file FICHERO
    Este que tal? GUAY
    El ficherito irá a un SCM... que irá registrando los cambios que haga sobre el mismo
    Puedo tener 10 ficheros (entorno1, entorno2, cliente17, app14)
- Si hay un fichero .auto.tfvars, se carga en automático.
    ESTA ES LA FORMA DE DAR VALORES POR DEFECTO A LOS ARGS DE UN SCRIPT, y no el default  
- Si a la variable se le ha definido un valor por defecto ("default"), se toma ese.
    NO SE USA NUNCA.
- Si terraform no encuentra valor para una variable, lo pide por consola
    Como os podeis imaginar esto rompe totalmente el concepto de AUTOMATIZACION 
- Aun así, si no paso valor, se corta la moto....

# Tipos de datos para variables:

- string
- number
- bool
- set(???)
- list(???)
- map(???)
- object        Es como un map, en cuanto a sintaxis, pero:
                    - Las claves vienen prefijadas
                    - Asociado a cada clave, puedo poner mi tipo de datos
                    - Hay claves que podemos definir como opcionales

# Idempotencia!

Independientemente del estado inicial, siempre llegue al mismo estado final.
Y esto guarda una relación enroem con el hecho de usar un lenguaje DECLARATIVO !

# Si tengo un script que ofrece idempotencia (y desde luego lo quiero así, ésto me lo regala terraform por el hecho de usar un lenguaje declarativo)

Nada quita que no está lanzando este proceso todas las noches... o en respuesta a un evento de monitorización.

NO TENGO NPI del uso que se dará a mi script.

Tampoco controlo que alguien no haya metido la pata al rellenar un ficherito de variables.

**CRITICO**: Ni de coña voy a montar un script de terraform que no haga un control lo más exhaustivo posible sobre los datos de partida!