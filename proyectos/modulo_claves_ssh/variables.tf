
variable "directorio_ficheros_claves" {
    description     = "Directorio en el que se crearán (o del que se leeran) las claves"
    type            = string
    nullable        = false

    validation {
        condition       = length( regexall("^((([.]{1,2}[\\/])|[\\/])?(([a-zA-Z0-9_-]+[\\/])*([a-zA-Z0-9_-]+[\\/]?))|[.]{1,2})$", var.directorio_ficheros_claves) ) == 1
                                # Valores que vamos a permitir:
                                #   claves-029
                                #   ./clavES_12
                                #   ../claves
                                #   /claves
                                #   claves/
                                #   ./claves/
                                #   ../claves/
                                #   /claves/
                                #   mis/claves/
                                #   ./mis/claves/
                                #   ../mis/claves/
                                #   /mis/claves/
                                #   .
                                #   ..
        error_message   = "El directorio no es válido. Se admiten rutas relativas y absolutas, sin espacios en blanco, ni caracteres especiales salvo el guión medio y bajo"
    }
}

variable "forzar_regeneracion" {
    description     = "Indica si aun a pesar de existir ficheros de claves previos en el `directorio_ficheros_claves`, se deben generar y exportar nuevas claves"
    type            = bool
    nullable        = false
    default         = false
}

variable "algoritmo" {
    description     = "Algoritmo a utilizar para la generación de las claves"
    type            = object({
                                nombre          =   string
                                configuracion   =   optional(string) # Si al poner optional no pongo valor por defecto, se toma como valor por defecto null
                             })
    nullable        = false
    default         = {
                        nombre          =   "rsa"
                        configuracion   =   4096
                      }
    validation{
        condition       = contains( ["RSA", "ECDSA", "ED25519"], upper(var.algoritmo.nombre) ) 
        error_message   = "El nombre del algoritmo debe ser: RSA, ECDSA, ED25519"
    }
    validation{
        condition       = ( upper(var.algoritmo.nombre) != "RSA" 
                                                                    ? true
                                                                    : ! can ( tonumber(var.algoritmo.configuracion) ) 
                                                                            ? false
                                                                            :    tonumber(var.algoritmo.configuracion) >= 512
                                                                              && tonumber(var.algoritmo.configuracion) <= 4096
                                                                              && tonumber(var.algoritmo.configuracion) == ceil(tonumber(var.algoritmo.configuracion)) )
                                                                            
        error_message   = "La configuración del algoritmo RSA debe ser un número entero entre 512-4096"
    }
    validation{
        condition       = ( upper(var.algoritmo.nombre) != "ECDSA" 
                                                                    ? true
                                                                    : contains( ["P224", "P256", "P384", "P521"], upper(var.algoritmo.configuracion) ) )
        error_message   = "La configuración del algoritmo ECDSA debe ser: P224, P256, P384, P521"
    }
    validation{
        condition       = ( upper(var.algoritmo.nombre) != "ED25519" 
                                                                    ? true
                                                                    : var.algoritmo.configuracion == null )
        error_message   = "El algoritmo ED25519 no admite configuración (dejar sin asignar o asignar a null)"
    }
}
