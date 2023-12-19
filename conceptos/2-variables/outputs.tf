
output "direccion_ip" {
    value = docker_container.mi-contenedor.network_data[0].ip_address
}
