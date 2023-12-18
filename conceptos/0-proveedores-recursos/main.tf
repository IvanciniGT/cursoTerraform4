# Estos ficheros se escriben usando sintaxis HCL.
# Puedo pponer comentarios!, con el cuadradito!

# Este script nos va a ayudar a gestionar un contenedor de nginx
# Aunque vamos a necesitar definir 2 recursos: Imagen de contenedor y el contenedor

# Pero esos recursos los voy a crear en Docker.
# Lo primero que necesito es un programa con el que terraform sepa comunicarse que nos permita 
# gestionar recursos en ese proveedor externo, que para nosotros es Docker: PROVEEDOR para docker

# Los proveedores que necesita mi script los defino en el elemento "terraform"
terraform {
    # Defino aquí los proveedores    
    required_providers {
        docker = {
            # Los proveedores los sacamos del registry de terraform. 
            # Necesitamos dar el nombre del proveedor en el registry de terraform. 
            source = "kreuzwerker/docker"
            # Esos proveedores, como programas que son, tendrán una versión... 
            # que también necesito especificar:
            version = "3.0.2"
        }
    }
}

# Ahora que ya tengo el proveedor, necesito (o no) configurarlo
# Y eso se hace mediante el elemento "provider"

provider "docker" {
  # Aquí pondríamos las opciones de configuración... en nuestro caso ninguna.
}

# Ahora ya puedo comenzar a definir/declarar recursos
# Para cada recurso escribiremos
#resource "tipo de recurso" "nombre/id interno al script" {
    # Y aquí dentro configuración especial/específica para este recurso concreto
#}

# El nombre del tipo de recurso es algo que define el proveedor, y que saco de la documentacion.

resource "docker_container" "mi-contenedor" {
           # v Valor
    name = "mi-nginx"
    # ^
    # Prop name
    
    # Dependiendo del tipo de dato asociado a la propiedad, así la sintaxis que necesito emplear
    image = docker_image.mi-imagen.image_id
            # ^^^ Y esto me resuelve 2 problemas del tirón:
            # Por un lado, ya no tengo que preconocer el ID de la imagen
            # Pero además, terraform usa esta información a la hora
            # de calcular el grafo de dependencias.
    env = ["VAR1=valor1", "VAR2=valor2"]
    #cpu_shares (Number) CPU shares (relative weight) for the container.
    cpu_shares = 512 # Media CPU, ya que va en base 1024 = 1 CPU
    start = true
    # PROHIBIDO depends_on = [ docker_image.mi-imagen ]... salvo en casos ultraespeciales QUE NUNCA OS VAIS A ENCONTRAR 
    # Esto está considerado una muy mala práctica. Dificulta muchisimo el mnto de los scripts.
    # -p 0.0.0.0:8080:80
    ports {
        internal = 80
        external = 8080
        ip       = "0.0.0.0"
    }    
    ports {
        internal = 443
        external = 8443
        ip       = "0.0.0.0"
    }
}
# Cada vez que creamos un recurso, terraform nos brinda una VARIABLE, llamada:
# tipo_del_recurso.nombre_del_recurso para referirnos a ese recurso, que podemos usar
# dentro del script en cualquier sitio (dentro de este fichero o de otro)
resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}

# SI: II
# NO: IIIIIII 
# NPI: Esta es la buena. Y por qué? porque sé como funciona terraform. Puede que si... puede que no... depende como le pille el día.
# A terraform se la trae al peiro el orden en el que yo escriba estos recursos en el fichero... 
# para determinar el orden de creación o de eleminación de los mismos.

# El orden de creación / eliminación de recursos se obtiene de un grafo de dependencias entre recursos
# que terraform genera de nuestro script.

    # docker_container.mi-contenedor
    # docker_image.mi-imagen
# OJO: LO QUE SE GENERA es un grafo de DEPENDENCIAS. No de FLUJO
# Los grafos de dependencias se leen al revés (las flechas para el otro lado)