
output "direccion_ip" {
    value = docker_container.mi-contenedor.network_data[0].ip_address
    # Esto acaba de generar una dependencia nueva en el grafo
}
# Ahora tengo formas muy sencillas de extraer este output... ese valor:
# $ terraform output
# $ terraform output [--json | --raw] direccion_ip
