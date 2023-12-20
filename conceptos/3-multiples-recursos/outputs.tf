
output "direcciones_ip" {
    value = [ for contenedor in docker_container.mi-contenedor:
                contenedor.network_data[0].ip_address ]
}
output "direcciones_ip_opcion_2" {
    value = docker_container.mi-contenedor[*].network_data[0].ip_address
}
# Hay una notacion alternativa que nos ofrece terraform, para lidiar con bucles en listas.
# Es muy peculiar... Yo no suelo usarla... me parece un poco oscura... deja poco claro lo que estamos haciendo
# Gente que no entiendo mucho de terraform, no la comprende.
# Pero lo cierto es que es una sintaxis MUY COMPACTA.

# terraform output --json direcciones_ip
output "direcciones_ip_como_texto" {
    value = join(";", docker_container.mi-contenedor[*].network_data[0].ip_address )
}
output "inventario_de_contenedores" {
    value = join("\n",[ for contenedor in docker_container.mi-contenedor:
                "${contenedor.name}=${contenedor.network_data[0].ip_address}" ] )
}
output "direcciones_ip_contenedores_personalizados" {
                # Un mapa lo puedo iterar solo obteniendo los valores, u obteniendo tanto las claves como los valores
                # Eso lo puedo hacer en cualquier sitio.
    value = [ for nombre, contenedor in docker_container.mis-contenedores-personalizados:
                "${nombre}=${contenedor.network_data[0].ip_address}" ]
}
# Necesito pasar a mi cliente la ip que deben usar para conectar con el servicio que ofrezco
# Si hay balanceador, la del balanceador, sino, la del unico contenedor que habré creado.
output "ip_servicio_web" {
#    value = (var.numero_contenedores > 1 ? docker_container.mi-balanceador[0].network_data[0].ip_address :
#                                           docker_container.mi-contenedor[0].network_data[0].ip_address)
    value = (local.quiero_balanceo ? docker_container.mi-balanceador[0] :
                                     docker_container.mi-contenedor[0]
            ).network_data[0].ip_address
}