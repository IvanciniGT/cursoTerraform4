output "claves" {
    sensitive   = true # Y así las claves no salen en los logs
    value       = (
                    local.se_generan_claves 
                      ? { # Las relleno desde el recurso que las genera
                            privada = {
                                        openssh = tls_private_key.claves[0].private_key_openssh
                                        pem     = tls_private_key.claves[0].private_key_pem
                                      } 
                            publica = {
                                        openssh = tls_private_key.claves[0].public_key_openssh
                                        pem     = tls_private_key.claves[0].public_key_pem
                                      }
                        }
                      : { # Las relleno desde los correspondientes ficheros
                            privada = {
                                        openssh = local.contenido_del_fichero_clave_privada_openssh
                                        pem     = local.contenido_del_fichero_clave_privada_pem
                                      } 
                            publica = {
                                        openssh = local.contenido_del_fichero_clave_publica_openssh
                                        pem     = local.contenido_del_fichero_clave_publica_pem
                                      }
                        }
                  )
}

# Así usarán mis outputs: 
    # claves.privada.pem
    # claves.public.openssh

# NECESITO AHORA 
# necesito un recurso llamado "claves" de tipo "tls_private_key"