variable "nombre_despliegue" {
    description = "prefijo que se pondrá a los recursos que creemos"
    type        = string
    nullable    = false
}

variable "recrear_el_servidor_si_nueva_imagen" {
    description = "Indica si quiero recrear el servidor si aparece una nueva imagen"
    type        = bool
    nullable    = false
    default     = false
}