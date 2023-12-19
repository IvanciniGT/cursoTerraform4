
resource "docker_container" "mi-contenedor" {
    name = "mi-nginx"
    image = docker_image.mi-imagen.image_id
    ports {
        internal = 80
        external = 8080
        ip       = "0.0.0.0"
    }    
}
resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}
