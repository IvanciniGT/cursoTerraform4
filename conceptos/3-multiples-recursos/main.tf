
# Os dije, que al crear un recurso, puedo usar la variable: 
#       tipo_recurso.nombre_recurso
# para acceder a los datos específicos de ese recurso.
resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}


# Pero... cunado creo un recurso qon la palabra COUNT,
# La variable:
#       tipo_recurso.nombre_recurso
# NO APUNTA a un único recurso, del que puede pedir datos...
# SINO A UNA LISTA DE RECURSOS
# Mi variable `docker_container.mi-contenedor` apunta a una LISTA de recursos
# De cada uo de ellos, podré pedir sus datos...
resource "docker_container" "mi-contenedor" {
    count           = var.numero_contenedores # Número de recursos que quiero crear
    # Cuando usamos la palabra COUNT:
    # Terraform me regala una variable nueva, que puedo usar dentro del recurso: count.index
    # Esa variable, empezando en 0, irá incrementandose para cada recurso que se cree, hasta llevar a valer: count-1
    name            = "mi-nginx-${count.index+1}"
    image           = docker_image.mi-imagen.image_id
    ports {
        internal    = 80
        external    = 8080 + count.index # Sumo número 8080 + 0 = 8080
        ip          = "0.0.0.0"
    }    
}
# Pero... cunado creo un recurso con la palabra FOR_EACH,
# La variable:
#       tipo_recurso.nombre_recurso
# NO APUNTA a un único recurso, ni a una lista, del que puede pedir datos...
# SINO A UN MAPA, cuyas claves coinciden con las suministradas en el mapa de entrada al for_each
# Mi variable `docker_container.mis-contenedores-personalizados` apunta a un MAPA de recursos
# De cada uo de ellos, podré pedir sus datos...
# Las claves que encientro en ese mapa serán: contenedorA y contenedorB

# En caso de haber metipo en el for_each una lista de strings?
# Mi variable `docker_container.mis-contenedores-personalizados` apunta a un MAPA de recursos
# donde las claves serían cada uno de los strings de la lista de strings usada en el for_each

resource "docker_container" "mis-contenedores-personalizados" {
    #count           = length(var.contenedores_personalizados) # UPS! La variable count.index, no me sirve para aceder a los valores del mapa
    for_each        = var.contenedores_personalizados
                      # Pero... en este for_each SOLO Puedo meter o un MAPA o una lista de strings.
                      # MIERDA! este for_each es distinto al for_each del dynamic!
                      # Cuando uso la palabra for_each, terraform me regala las variables:
                      # each.key: Va tomando como valor cada una de las claves del mapa:
                      # each.value: Va tomando como valor cada uno de los valores del mapa
    name            = each.key
    image           = docker_image.mi-imagen.image_id
    ports {
        internal    = 80
        external    = each.value
        ip          = "0.0.0.0"
    }    
}

resource "docker_container" "mis-contenedores-mas-personalizados" {
    #count           = length(var.contenedores_personalizados) # UPS! La variable count.index, no me sirve para aceder a los valores del mapa
    for_each        = var.contenedores_mas_personalizados
                      # Pero... en este for_each SOLO Puedo meter o un MAPA o una lista de strings.
                      # MIERDA! este for_each es distinto al for_each del dynamic!
                      # Cuando uso la palabra for_each, terraform me regala las variables:
                      # each.key: Va tomando como valor cada una de las claves del mapa:
                      # each.value: Va tomando como valor cada uno de los valores del mapa
    name            = each.key
    image           = docker_image.mi-imagen.image_id
    ports {
        internal    = 80
        external    = each.value.puerto
        ip          = each.value.ip
    }    
}

resource "docker_container" "mis-contenedores-mas-personalizados-2" {
    count           = length(var.contenedores_mas_personalizados_otra_forma)
    name            = var.contenedores_mas_personalizados_otra_forma[count.index].nombre
    image           = docker_image.mi-imagen.image_id
    ports {
        internal    = 80
        external    = var.contenedores_mas_personalizados_otra_forma[count.index].puerto
        ip          = var.contenedores_mas_personalizados_otra_forma[count.index].ip
    }    
}
