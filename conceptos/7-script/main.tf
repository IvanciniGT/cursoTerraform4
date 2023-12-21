module "contenedor-bd" {
    source                   = "../6-modulos" 
    nombre_contenedor        = "mi-bd-${var.nombre_despliegue}"
    imagen_contenedor_repo   = "mariadb"
    imagen_contenedor_tag    = var.db.tag
    variables_entorno        = {
                                    "MARIADB_ROOT_PASSWORD" = var.db.root_password
                                    "MARIADB_DATABASE" = "db"
                                    "MARIADB_USER"     = var.db.usuario
                                    "MARIADB_PASSWORD" = var.db.password
                                }
}
module "contenedor-wp" {
    source                   = "../6-modulos" 
    nombre_contenedor        = "mi-wp-${var.nombre_despliegue}"
    imagen_contenedor_repo   = "wordpress"
    imagen_contenedor_tag    = var.wp.tag
    variables_entorno        = {
                                    "WORDPRESS_DB_HOST"     = "${module.contenedor-bd.direccion_ip}:3306"
                                    # además de trincar la ip del otro contenedor... esto nos genera una dependencia en el grafo
                                    "WORDPRESS_DB_USER"     = var.db.usuario
                                    "WORDPRESS_DB_PASSWORD" = var.db.password
                                    "WORDPRESS_DB_NAME"     = "db"
                               }
    variables_puertos        = [
                                    {
                                        interno = 80
                                        externo = var.wp.puerto
                                        ip      = "0.0.0.0"
                                    }
                               ]
}
# Usando esa misma sintaxis, podría definir mis propios outputs del script!

# Los módulos los puedo tener ubicados en muchos sitios:
# Local (entonces, lo que ponga aquí empezará por . o ..) NO SE ADMITE OTRA COSA
# Terraform registry
    #  source = "terraform-aws-modules/vpc/aws" << Esto es el repo dentro del terraform registry donde está el modulo
# Repo de git 
# Bucket S3
# Servidor web
# VER TODAS LAS POSIBLES UBICACIONES EN:
# https://developer.hashicorp.com/terraform/language/modules/sources
