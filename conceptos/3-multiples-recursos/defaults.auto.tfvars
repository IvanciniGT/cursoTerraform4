numero_contenedores = 1
contenedores_personalizados = {
    contenedorA = 8090
    contenedorB = 9090
}
contenedores_mas_personalizados = {
                                        contenedorA2 = {
                                                            puerto  = 10080
                                                            ip      = "127.0.0.1"
                                                       }
                                        contenedorB2 = {
                                                            puerto  = 10090
                                                       }
                                  }
                                  # En este caso, si repito clave... terraform no se queja, pero machaca el primero con el segundo... la infra se despliega... pero malamente!
# Y AQUI LA DECISION ES MERAMENTE ESTÉTICA / PRACTICA a la hora de rellenar la variable

contenedores_mas_personalizados_otra_forma = [
                                                {
                                                    nombre  = "contenedorA3"
                                                    puerto  = 10081
                                                    ip      = "127.0.0.1"
                                                },
                                                {
                                                    nombre  = "contenedorB3"
                                                    puerto  = 10091
                                                    ip      = "0.0.0.0"
                                                },
                                             ]
    # Esta segunda sintaxis la veo más explicita!              POR DIOS, SIEMPRE EXPLICITO !!!!! TODO LO EXPLICITO QUE PUEDA !   
    # (Salvo una pequeñita salvedad que ahora cuento)
    # En este caso, al tener una lista, terraform no chequea que el 
    # capullo que esté rellenando esta lista
    # no haya repetido NOMBRE
    # En este caso, terraform tampoco se queja.. pero el proveedor si se quejará... 
    # Lo bueno, que me entero de que la infra se ha desplegado malamente
    # En este caso tengo una oportunidad adicional,
    # Chequear que no me han repetido NOMBRE.
    # podría sacar un listado de los nombre: 
    #       length(distinct(var.contenedores_mas_personalizados_otra_forma[*].nombre)) == length(var.contenedores_mas_personalizados_otra_forma)
    #       length(distinct([for contenedor in var.contenedores_mas_personalizados_otra_forma: contenedor.nombre]))== length(var.contenedores_mas_personalizados_otra_forma)
    