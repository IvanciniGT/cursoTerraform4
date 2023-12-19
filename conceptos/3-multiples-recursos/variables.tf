
variable "numero_contenedores" { 
    description = "Cuantos contenedores se van a crear"
    type        = number
}
# Que os parece esta solución que hemos dado?
# Bien... aunque ... en algunos casos, se me puede quedar un poco pobre.
# Que pasa si quiero 10 contenedores, que abran los peurtos que a mi me de la real gana... y no secuenciales
# O que los nombres sean los que yo quiero... y no secuenciales?
variable "contenedores_personalizados" { 
    description = "Contenedores personalziados que se van a crear"
    type        = map(number)
}
# Que os parece esta solución que hemos dado?
# Bien!!! Aunque... si quiero personalizar más datos... necesitaré una estructura de variable más compleja
# Por ejemplo:
# Quiero personalizar de cada contenedor:
# - nombre
# - puerto externo
# - ip en la que se abre ese puerto externo
variable "contenedores_mas_personalizados" { 
    description = "Contenedores personalizados que se van a crear"
    type        = map(object({
                                puerto = number
                                ip     = optional(string, "0.0.0.0")
                            }))
}
# Qué os parece esta solución?
# GUAY ! y es muy versatil.. me permite personalziar lo que quiera... vete metiendo props al object
# Aunque... que feo... como se rellena la variable.

variable "contenedores_mas_personalizados_otra_forma" { 
    description = "Contenedores personalizados que se van a crear"
    type        = list(object({
                                nombre = string
                                puerto = number
                                ip     = optional(string, "0.0.0.0")
                            }))
}

# Definiré la variable como me venga en gana... ESO SI, tendré que vivir con las consecuencias de mi decisión !