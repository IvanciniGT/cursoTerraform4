
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
