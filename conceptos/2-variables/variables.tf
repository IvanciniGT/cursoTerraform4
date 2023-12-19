# Nombre del contenedor
variable "nombre_contenedor" {
    description = "Nombre del contenedor que se va a generar"
    type        = string #number, bool, set() list() map()
    nullable    = false
    # default = "federico" Olvidado
    # La palabrita default no se ha inventado para poner valor 
    # por defecto a las variables de un script.
    # Sirve para otra cosa... que ya os contaré
    validation {
        # Una expresión que devuelva un bool (true, false).
        # En terraform tenemos un huevo y medio de funciones que podemos usar en las expresiones.
        #       https://developer.hashicorp.com/terraform/language/functions
        # Si se develve true, se entiende que el valor ha superado la validacion
        condition       = length( regexall("^[a-zA-Z0-9_-]{5,20}$", var.nombre_contenedor) ) == 1
                                                                                        # Operadores: > < >= <= == != && || ! + - * /
        # Mensaje que se muestra cuando la condicion devuelve false, es decir, cuando no se ha superado la validación.
        # En este caso, terraform CORTA la ejecución de script... mostrando este mensaje.
        error_message   = "El nombre del contenedor solo puede contener letras (en mayusculas y/o minúsculas), dígitos, y el guión medio y bajo. Al menos 5 caracteres."
    }
    # Puedo poner tantos validation como quiera dentro de una variable.
    # Si tengo varios, se debe superar todos ellos para dar por bueno el valor de la variable.
    # Es decir, se anidan con AND
}

# Uso cpu_shares
variable "uso_cpu" { 
    description = "Limitar el uso de cpu (en base 1024 = 1 cpu) permitido para el contenedor"
    type        = number
    nullable    = true
                  # La variable, además de contener datos de su tipo, en este caso números,
                  # tambien puede contener el valor null, que es un valor que existe en terraform
                 
    validation {
        condition       = var.uso_cpu == null ? true : ( ceil(var.uso_cpu) == var.uso_cpu && var.uso_cpu > 0 )
                         # Operador ternaario de terraform: Es un condicional en linea, lo teneis también en la mayoría de lenguajes de programación
                         # (condicion) ? (valor si se cumple) : (valor si no se cumple)
                         # O se ejecuta el código asociado a si el valor se cumple, o el otro, pero no los 2.
        # var.uso_cpu == null || ( ceil(var.uso_cpu) == var.uso_cpu && var.uso_cpu > 0 )
        # PROBLEMA CON ESTA SINTAXIS: 
        # Normalmente, en cualquier lenguaje de programación, los operadores & y | como operadores AND y OR sin cortocircuito
        # Normalmente, en cualquier lenguaje de programación, los operadores || y && son operadores en CORTO-CIRCUITO
            # Lo que significa que si no se cumple la primera parte de la condicion, no se evalua la segunda parte
        # Pero en terraform NO. Aunque se cumpla (||) o no se cumpla (&&) la primera parte, la segunda SIGUE EVALUANDOSE
        error_message   = "El valor debe ser un número entero, mayor que cero (número natural)"
    }
}

# Si arranca o no
variable "arrancar_automaticamente" {
    description = "Arrancar automáticamente el contenedor tras su creación"
    type        = bool
    nullable    = false
}

# Imagen
variable "imagen_contenedor_repo" {
    description = "Nombre del repo de la imagen de contenedor que se va a utilizar para generar el contenedor"
    type        = string
    nullable    = false
    # Validacion similar al nombre del contenedor
}

# Imagen
variable "imagen_contenedor_tag" {
    description = "Tag de la imagen de contenedor que se va a utilizar para generar el contenedor"
    type        = string
    nullable    = false
    # Validacion similar al nombre del contenedor
}

# Variables de entorno
variable "variables_entorno" {
    description = "Variables de entorno que se van a utilizar para generar el contenedor."
    type        = map(string)
                  #set(string) # ESTO ES UNA MIERDA !!!!!
                               # Aqui hay un comportamiento MAGICO ! 
    nullable    = false
    # Validacion similar al nombre del contenedor, para los nombres de las variables JAVA_HOME, PATH, MYSQL_ROOT_PASSWORD, MAL: #·")(/&"
    # Pero... en este caso... debemos aplicar ese patrón de validación a  cada clave
    validation {
        condition       = alltrue( 
                                [ for clave, valor in var.variables_entorno: 
                                    length( regexall("^[a-zA-Z0-9_-]{5,}$", clave) ) == 1 
                                ]
                            )
                        # EN ESTAS VALIDACIONES SOLO PUEDO REFERIRME A LA PROPIA VARIABLE EN LA QUE ESTA DEFINIDA LA VALIDACION
                        # No puedo hacer validaciones cruzadas entre variables: WORKAROUNDS
        error_message   = "El nombre de la variable solo puede contener letras (en mayusculas y/o minúsculas), dígitos, y el guión medio y bajo. Al menos 5 caracteres."
    }

    
}

# Puertos
variable "variables_puertos" {
    description = "Puertos a exponer en el contenedor."
    type        = set(object({
                                interno     =   number
                                externo     =   number
                                ip          =   optional(string, "127.0.0.1")
                                protocolo   =   optional(string, "tcp") # upd
                             }))
                    #list(map(string)) # Esta podría ser una solución (PERO DE MIERDA)... ya que terraform permite convertir entre string y number en automático
    nullable    = false
    
    validation {
        condition       = alltrue( 
                                    [ for puerto in var.variables_puertos: 
                                        puerto.interno == ceil(puerto.interno) && puerto.externo == ceil(puerto.externo)
                                    ] 
                                 )
        error_message   = "Lo puertos (tanto interno como externo) deben números enteros"
    }
    
    validation {
        condition       = alltrue( 
                                    [ for puerto in var.variables_puertos: 
                                        puerto.interno > 0 && puerto.externo > 0
                                    ] 
                                 )
        error_message   = "Lo puertos (tanto interno como externo) deben ser mayores que cero"
    }
    
    validation {
        condition       = alltrue( 
                                    [ for puerto in var.variables_puertos: 
                                        puerto.interno <= 65535 && puerto.externo <= 65535
                                    ] 
                                 )
        error_message   = "Lo puertos (tanto interno como externo) deben ser menores que 65535"
    }
    validation {
        condition       = alltrue( 
                                    [ for puerto in var.variables_puertos: 
                                        length( regexall("^([01]?\\d\\d?|2[0-4]\\d|25[0-5])(?:\\.(?:[01]?\\d\\d?|2[0-4]\\d|25[0-5])){3}(?:/[0-2]\\d|/3[0-2])?$", puerto.ip) ) == 1 
                                    ]
                            )
        error_message   = "Las IPs de los puertos deben ser válidas (se admiten mascaras)."
    }
    validation {
        condition       = alltrue( 
                                    [ for puerto in var.variables_puertos: 
#                                        length( regexall("^(tcp|udp)$", puerto.protocolo) ) == 1
                                        contains( ["tcp","udp"], puerto.protocolo)
                                    ]
                            )
        error_message   = "El protocolo debe ser tcp o udp"
    }

}
