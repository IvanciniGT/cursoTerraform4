# modulo_claves_ssh

Este módulo se encarga de crear pares de claves SSH, con cierta parametrización 
según se indica en las variables del proyecto.

## Requisitos

- Terraform v0.12.x o superior.
- Acceso a una cuenta de proveedor de nube compatible (si es aplicable).

## Instalación y Configuración

1. Clona el repositorio a tu máquina local.
2. Asegúrate de tener Terraform instalado. Si no, puedes descargarlo desde [la página oficial de Terraform](https://www.terraform.io/downloads.html).

## Ejemplo de uso: 

Para usar este módulo en tu proyecto Terraform, puedes partir de este ejemplo:

```tf
module "claves" {
    source                      = "https://migitlab.miempresa.com/terraform/modulo_claves_ssh"
    directorio_ficheros_claves  = "./claves"
    forzar_regeneracion         = false
    algoritmo                   = {
                                    nombre          =   "rsa"
                                    configuracion   =   4096
                                  }
}
```

## Salidas

Se generan ficheros para las claves publica y privada en formato pem y openss en al carpeta indicada en `directorio_ficheros_claves`.
Además se genera un output que puede usarse de la sieguinte forma:
```tf
module.claves.privada.pem       # Clave privada en formato pem
module.claves.privada.openssh   # Clave privada en formato openssh
module.claves.public.pem        # Clave publica en formato pem
module.claves.public.openssh    # Clave publica en formato openssh

```

## Mantenimiento

Este proyecto lo ha creado Ivan Osuna <ivan.osuna.ayuste@gmail.com>.

Ayudas bienvenidas.... cafecitos también!
