
variable "numero_contenedores" { 
    description = "Cuantos contenedores se van a crear"
    type        = number
}
# Que os parece esta solución que hemos dado?
# Bien... aunque ... en algunos casos, se me puede quedar un poco pobre.
# Que pasa si quiero 10 contenedores, que abran los peurtos que a mi me de la real gana... y no secuenciales
# O que los nombres sean los que yo quiero... y no secuenciales?