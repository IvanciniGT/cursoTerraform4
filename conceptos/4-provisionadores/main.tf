
resource "docker_container" "mi-contenedor" {
    name = "mi-nginx"
    image = docker_image.mi-imagen.image_id
}
resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}
