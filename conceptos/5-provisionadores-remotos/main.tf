resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}


resource "docker_container" "mi-contenedor" {
    name            = "contenedor"
    image = docker_image.mi-imagen.image_id
}
