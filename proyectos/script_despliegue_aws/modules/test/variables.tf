
variable "ejecutar_pruebas_si_el_servidor_no_se_ha_creado" {
  description   = "Forzar la ejecución de las pruebas aunque no se recree el servidor"
  type          = bool
  nullable      = false
  default       = true
}

variable "ip" {
  description   = "Ip del servidor a probar"
  type          = string
  nullable      = false
}

variable "usuario" {
  description   = "Usuario del servidor a probar"
  type          = string
  nullable      = false
}

variable "clave_privada" {
  description   = "Clave privada del usuario del servidor a probar"
  type          = string
  nullable      = false
}

variable "id_servidor" {
  description   = "Id del servidor a probar"
  type          = string
  nullable      = false
}
