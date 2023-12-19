resource "docker_container" "mi-contenedor" {
    name         = var.nombre_contenedor
                    # Para usar una variable, ponemos `var.` y el nombre de la variable
    image        = docker_image.mi-imagen.image_id
    env          = [ for clave, valor in var.variables_entorno: "${clave}=${valor}" ]
                    # Bucle, para cada par clave, valor -> genero un string, con un "= entre medias
                    # Y meto la salida en un set: []
    cpu_shares   = var.uso_cpu
                    # Asignar a una propiedad de un recurso el valor null,
                    # Hace que terraform no suministre esa propiedad al provider
                    # Es como si no hubiera escrito la linea
                    # Al pasarlo mediante una variable, controlo si quiero hacer llegar el dato al provider o no.
                    # Convierto la propiedad en OPCIONAL
                    #     if(var.uso_cpu != null){
                    #        cpu_shares   = var.uso_cpu
                    #     }
                    # SERIA EQUIVALENTE A ^^^^esa sintaxis, que no es válida en terraform.
    start        = var.arrancar_automaticamente
    
    dynamic "ports" { # permite generar blocks dinamicamente dentro de un resource
        for_each = var.variables_puertos # Lista o un set
        iterator = puerto
        content {
            internal = puerto.value.interno
            external = puerto.value.externo
            ip       = puerto.value.ip
            protocol = puerto.value.protocolo
        }
    }
}

resource "docker_image" "mi-imagen" {
                   # INTERPOLACIÓN DE TEXTOS
    name         = "${var.imagen_contenedor_repo}:${var.imagen_contenedor_tag}"
}
