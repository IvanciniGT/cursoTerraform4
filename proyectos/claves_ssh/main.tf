resource "tls_private_key" "claves" {
    count         = local.se_generan_claves ? 1 : 0
    algorithm     = local.nombre_algoritmo
    ecdsa_curve   = local.nombre_algoritmo == "ECDSA" ? upper(var.algoritmo.configuracion) : null
    rsa_bits      = local.nombre_algoritmo == "RSA"   ? var.algoritmo.configuracion        : null
    
    provisioner "local-exec" {
    
        command = <<EOT
                        mkdir -p ${local.directorio_ficheros_claves_acabando_en_barra}
                        echo -n "${self.public_key_pem}"      > ${local.ruta_del_fichero_clave_publica_pem}
                        echo -n "${self.public_key_openssh}"  > ${local.ruta_del_fichero_clave_publica_openssh}
                        echo -n "${self.private_key_pem}"     > ${local.ruta_del_fichero_clave_privada_pem}
                        echo -n "${self.private_key_openssh}" > ${local.ruta_del_fichero_clave_privada_openssh}
                    EOT
    }
    
}
