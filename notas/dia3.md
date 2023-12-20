# Provisionadores

Un provisionador es una forma de ejecutar código / acciones adicionales
cuando un recurso es:
- Creado* o modificado
- O borrado

# Qué tipo de acciones?

3 tipos de acciones... y solo 3 tipos de acciones, que dan lugar a 3 tipos de provisionadores:
- local-exec    Ejecutar comandos / scripts en la misma máquina donde estamos ejecutando nuestro script de terraform (local)
- remote-exec   Ejecutar comandos / scripts en un entorno remoto
                ^
            Conectarme con el entorno remoto: ssh, winrm, ...
                v
- file          Copiar ficheros a un entorno remoto

Antiguamente existían provisionadores para: Chef, Habitat, Puppet, and Salt Masterless, pero se quitaron, ya que no se considera
una buena práctica llamar a esas otros herramientas desde Terraform (quiero componentes desacoplados).

# Uso de los provisionadores

NO HAY QUE ABUSAR DE LOS PROVISIONADORES. No están ahí para ejecutar un montón de código en un remoto.

    Creando un servidor Linux remoto en un cloud (y lo creo con terraform)
    
    Una vez creado* quiero montarle una paquetería, crar unos usuarios, carpetas, abrirle puertos del firewall.
    Puedo hacer eso con un script de la bash? SI. Lo haré? NI DE COÑA.
        Eso lo haré con Ansible, por qué? y no con la bash? Porque ansible me da un lenguaje DECLARATIVO... y por ende es:
            - Más cómodo
            - Menos propenso a errores
            - Además de ganar idempotencia
    Entones eso significa que no usaría un remote-exec para ello? TOTALMENTE !!! NI DE COÑA LO USO... aunque podría:
        - SEPARACION DE RESPONSABILIDADES:
            - Script de creación de máquinas                TERRAFORM
            - Sprint de aprovisionamiento de las máquinas   ANSIBLE o equivalente... (o la bash incluso)
        - PERO querré tener luego alguien que orqueste esos trabajo (Y será su RESPONSABILIDAD el hacerlo)
    Todo esto va en aras de generar una arquitectura más facilemente mantenible en el futuro.

Entonces... vamos a usar los provisionadores? En algunos casos:

    remote-exec. CASOS DE USO?
        - Pruebas: Prueba de conexión
        - Preparar el entorno para el siguiente.
            - Puppet requiere de un agente instalado en los entornos remotos... tendré que ponerlo ahí... sino puppet no se podrá conectar
            - Ansible también tiene sus requisitos: Python, un usuario específico... una clave ssh dada de alta -> file
        - El remoto no tiene porque ser necesariamente el entorno(recurso) que estoy creando, puede ser cualquier entorno remoto
            - Creo un servidor
            - Obtengo sus datos
            - Llamo a un programa que tengo en otro computador para darlo de alta en el cmdb
                (Aunque en cuestión de diseño del sistema... una solución un tanto ruinosa...)
                    Jenkins vvvv
                        Script de TERRAFORM -> Script que lo de de alta en el CMBD -> Ansible
    local-exec: 
        - Pruebas
        - Generar información que exportar posteriormente

En definitiva COSAS BASTANTE SENCILLAS
    
---

Quiero que a ejecutar mi script de terraform, se me genere un fichero con:
nombre_contenedor=IP
Pero... quiero poder generar 1 o 17 contenedores.. en base a la variable numero_contenedores