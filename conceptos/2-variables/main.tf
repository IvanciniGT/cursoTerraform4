resource "docker_container" "mi-contenedor" {
    name         = var.nombre_contenedor
    image        = docker_image.mi-imagen.image_id
    env          = ["VAR1=valor1", "VAR2=valor2"]
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
    name         = "nginx:latest"
}
