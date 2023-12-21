variable "db" {
    description = "Datos de la BBDD"
    type        = object({
                            tag = string
                            root_password = string
                            usuario = string
                            password = string
                         })
}

variable "wp" {
    description = "Datos del WP"
    type        = object({
                            tag = string
                            puerto= number
                         })
}
variable "nombre_despliegue" {
    description = "nombre del despliegue de este WP"
    type        = string
}
