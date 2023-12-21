# Workspaces de terraform

Básicamente lo que man los workspaces es la capacidad de ejecutar un script asociado a distintos entornos (un despliegue de infra).

Dentro de cada workspace vamos a tener nuestro propio fichero .tfstate asociado a ese entorno.

    $ terraform workspace list          > Veo todos los entornos
    $ terraform workspace select XXX    > Me coloco en un entorno
    $ terraform workspace new XXX       > Creo un nuevo entorno
    $ terraform workspace delete XXX    > Me crujo un entorno

Por de facto, al inicializar (init) un script se me genera un workspace, llamado "default".
Y si no digo nada, todo se hace en ese workspace.

DEBERIAMOS EVITAR A TODA COSTA, incluso en escenarios sencillos, trabajar en el workspace DEFAULT.
Siempre quiero tener consciencia del workspace en el ue trabajo... sino, a la mínima puedo liardla muy parda.

In particular, organizations commonly want to create a strong separation between multiple deployments 
of the same infrastructure serving different development stages or different internal teams. 

In this case, the backend for each deployment often has different credentials and access controls.

CLI workspaces within a working directory use the same backend, so they are not a suitable isolation mechanism 
for this scenario.

TODO ESTO ES CIERTO! ESTA GUAY!

Lo que está mal es la conclusión! 

Por tanto, Not to Use Multiple Workspaces = MIERDA !

Por qué? Porque se está olvidando de una cosita... chiquita! Y es que no somos gilipollas.

Y el directorio este de los puñeros script va a ir guardadito en un repo de GIT.

Y Resulta, mira tu por donde, que en git existe un extaordinario concepto llamado SUBMODULOS !

Que me permite tener un repo, que tenga asociado subrepos.
Donde cada subrepo puede tener sus propios provilegios de acceso.
Y cuando me descargo un gran repo, que tiene dentro minirepos (submodulos),
solo podré descargar aquellos qpara los que tenga permiso.

La conclusión debería ser algo así como: 
Por tanto, Si no tienes ni puta ide de como git y no sabes usar submodulos, 
Not to Use Multiple Workspaces en este escenario. OK!

---

El objetivo no es estar tirando comanditos en una terminal! Estamos en los 90?

El objetivo es tener un JENKINS (O similar)
Y el Jenkins ejecutará un pipeline de CI/CD...
En un momento necesitara crear una infra con terraform.
Y:

PASO1: Abrirá un contendor con terraform preinstalado
PASO2: Le hará llegar el código de mi script, que lo estará gestionando un equipo (mal llamado DEVOPS normalmente)
            Este script, que tendrá su repo, lo gestiona un equipo
PASO3: Le haré llegar unos ficheros de configuración
            Estos ficheros, que tendrán su repo, los gestiona otro equipo (EQUIPO 2)
PASO4: Le haré llegar el fichero tfstate
            QUE NO LO GESTIONA NADIE SALVO EL JENKINS AUTOMATICAMENTE... y se guardará donde sea.
PASO5: Ejecuto
PASO6: El jenkins guarda la nueva versión del .tfstate donde le toque guardarla.. a mi me la pela!
PASO7: En mi carpeta (EQUIPO 2) se creará lo que se tenga que crear... y me lo harán llegar... como sea
        O no se crea nada en mi carpeta, más allá de una infra en un cloud.
        
---

De alguna forma, lo que estamos escribirndo es un script!
Ese script tiene una parte grande de lenguaje declarativo... 
pero incluso seugimos teniendo algo de lenguaje imperativo:
BUCLES, CONDICIONALES...

Si echamos la vista atrás... al mundo del desarrollo de software... 
algo habremos aprendido en 60-70 años que llevamos produciendo software.

Y entre las principales cosas que hemos aprendido ha sido a crear programas:
- Que cada vez sean más fácilmente mantenibles
- Y reutilizables

Desde hace ya más años que matusalen, cuando escribimos código, no usamos solo lenguaje imperativo ni declarativo.
Hay otros paradigmas de programación:
- Funcional
- Orientado a Objetos
- Procedural            Cuando un lenguaje me permite crear procedimientos (funciones, subrutinas, módulos, métodos)
                        Y llamarlos posteriormente

Para qué queremos crear funciones? o métodos en el código? 
1 - Para reutilizarlo
2 - Generar un código más fácilmente mantenible, con distintas partes que se encargan de distintas responsabilidades

Este concepto LO HE DE TRAER A TERRAFORM, ya que terraform soporta un paradigma procedural... Y DARLE MUCHA IMPORTANCIA A ESTO!
Y no se la damos!

Un script no puede estar creando 20, 30 recursos.
Es más... un script BIEN ORGANIZADO no debería crear ni UN SOLO recurso.
Tampoco me obsesiono.

Muchos venís con conocimientos de Ansible... y en Ansible tenemos la misma mierda!
En ansible también montamos scripts: PLAYs... que agrupamos en PLAYBOOKs
Y en un play puedo meter 800 tareas = RUINA GIGANTE !!!!
El código empiezo a agruparlo, y a asignar responsabilidades: ROLES de Ansible

Éste mismo concepto existe en Terraform: MODULES de terraform.

Los scripts tenían:
- Providers que necesitamos
- Configuración de los providers
- Variables (Argumentos de entrada al script)
- Variables internas (expresiones reutilizables): LOCALS
- Outputs: Salidas de nuestro programa (Script)
- Recursos que creamos 
- Ficheros de variables, con valores concretos

Si quiero montar un módulo, es decir un conjunto de recursos reutilizable en distintos proyectos:
- Recursos que creamos 
- Providers que necesitamos
- Variables (Argumentos de entrada al script)
- Variables internas (expresiones reutilizables): LOCALS
- Outputs: Salidas de nuestro programa (Script)

---

Soy una empresa, llamemosla X(ITNOW)

Y quiero montar unos servidores en un cloud (IBM)

OPCION 1: 

Y monto scripts llenos de recursos de ese cloud (usando el proveedor del cloud)

Y ahora decido que quiero ir a otro cloud (AZURE)

Que necesitaría hacer? REESCRIBIR TODOS MIS PUÑETEROS SCRIPTS ! Prepara tiempo y pasta !

Oye AZURE es más BARATO ... vámonos! Y el de abajo dice... espera tu... que AZURE es más barato, pero 750 horas de tios que sepa un huevo de terraform 
son a tanto la hora... porrón de pasta. Me quedo donde estoy! Si acaso lo nuevo ya lo voy montando en otro sitio... o paso cosas de a poco.

OPCION 2:

Y monto scripts llenos de llamadas a un modulo creado inhouse para definir máquinas:

Y todos los scripts que se hubiesen creado huibieran usado el módulo

Y el módulo lo lleno de recursos de ese cloud (usando el proveedor del cloud)

Y ahora decido que quiero ir a otro cloud (AZURE)

Que necesitaría hacer? REESCRIBIR MI MODULO ! Prepara un poquito tiempo y pasta !
Y en lugar de 750 horas de devops apretao... me valen con 35!

Y paso toda mi infra del tirón.

DECISIONES !

---

El módulo es un MODULO GENERICO para crear contenedores que hemos montado.
El script es un script más concreto para un tipo de despliegue que vamos a hacer.

Quiero montar un wordpress
Y monto mi script de despliegue de wordpress con contenedores... que desplegaré en distintos entornos.
Wordpress PRODUCCION - Mi blog
Wordpress DESARROLLO - Mi blog
Wordpress PRODUCCION - Mi Primo's blog
Wordpress DESARROLLO - Mi Primo's blog

Igual que el script tendrá sus propias variables, independientes de las de los módulos que use
El script también tendra sus propios outputs independientes de los del modulo

----

# DATA

El elemento data, dentro de los ficheros (scripts) de terraform nos permite hacer una búsqueda automatizada
en el proveedor (query)
