resource "docker_container" "mi-contenedor" {
    name         = var.nombre_contenedor
                    # Para usar una variable, ponemos `var.` y el nombre de la variable
    image        = docker_image.mi-imagen.image_id
    env          = var.variables_entorno
    cpu_shares   = var.uso_cpu
    start        = var.arrancar_automaticamente
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

resource "docker_image" "mi-imagen" {
                   # INTERPOLACIÓN DE TEXTOS
    name         = "${var.imagen_contenedor_repo}:${var.imagen_contenedor_tag}"
}
