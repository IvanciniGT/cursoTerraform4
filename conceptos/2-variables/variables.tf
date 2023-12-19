# Nombre del contenedor
variable "nombre_contenedor" {
    description = "Nombre del contenedor que se va a generar"
    type = string #number, bool, set() list() map()
    # default = "federico" Olvidado
    # La palabrita default no se ha inventado para poner valor 
    # por defecto a las variables de un script.
    # Sirve para otra cosa... que ya os contaré
}

# Uso cpu_shares
variable "uso_cpu" {
    description = "Uso de cpu (en base 1024 = 1 cpu) permitido para el contenedor"
    type = number
}
# Si arranca o no
variable "arrancar_automaticamente" {
    description = "Arrancar automáticamente el contenedor tras su creación"
    type = bool
}

# Imagen


# Variables de entorno
# Puertos
