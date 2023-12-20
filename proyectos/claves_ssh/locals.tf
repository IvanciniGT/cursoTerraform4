locals {

    nombre_algoritmo                                = upper(var.algoritmo.nombre)

    directorio_ficheros_claves_acabando_en_barra    = ( endswith(var.directorio_ficheros_claves, "/") 
                                                         ? var.directorio_ficheros_claves
                                                         : "${var.directorio_ficheros_claves}/" )
                                                             
    ruta_del_fichero_clave_publica_pem              = "${local.directorio_ficheros_claves_acabando_en_barra}public_key.pem"
    ruta_del_fichero_clave_publica_openssh          = "${local.directorio_ficheros_claves_acabando_en_barra}public_key.openssh"
    ruta_del_fichero_clave_privada_pem              = "${local.directorio_ficheros_claves_acabando_en_barra}private_key.pem"
    ruta_del_fichero_clave_privada_openssh          = "${local.directorio_ficheros_claves_acabando_en_barra}private_key.openssh"
    
    existe_el_fichero_clave_publica_pem             = fileexists( local.ruta_del_fichero_clave_publica_pem     )
    existe_el_fichero_clave_publica_openssh         = fileexists( local.ruta_del_fichero_clave_publica_openssh )
    existe_el_fichero_clave_privada_pem             = fileexists( local.ruta_del_fichero_clave_privada_pem     )
    existe_el_fichero_clave_privada_openssh         = fileexists( local.ruta_del_fichero_clave_privada_openssh )

    existen_ficheros_de_claves                      = ( local.existe_el_fichero_clave_publica_pem
                                                        && local.existe_el_fichero_clave_publica_openssh
                                                        && local.existe_el_fichero_clave_privada_pem
                                                        && local.existe_el_fichero_clave_privada_openssh )
    
    se_generan_claves                               = ! local.existen_ficheros_de_claves || var.forzar_regeneracion

    contenido_del_fichero_clave_publica_pem         = local.existe_el_fichero_clave_publica_pem     ? file(local.ruta_del_fichero_clave_publica_pem)     : null
    contenido_del_fichero_clave_publica_openssh     = local.existe_el_fichero_clave_publica_openssh ? file(local.ruta_del_fichero_clave_publica_openssh) : null
    contenido_del_fichero_clave_privada_pem         = local.existe_el_fichero_clave_privada_pem     ? file(local.ruta_del_fichero_clave_privada_pem)     : null
    contenido_del_fichero_clave_privada_openssh     = local.existe_el_fichero_clave_privada_openssh ? file(local.ruta_del_fichero_clave_privada_openssh) : null
}