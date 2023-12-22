nombre_contenedor        = "menchu"
uso_cpu                  = 1024 # Por defecto lo suyo sería null
arrancar_automaticamente = true
imagen_contenedor_repo   = "nginx"
imagen_contenedor_tag    = "latest"
variables_entorno        = {
                                "VARIABLE1" = "value1"
                                "VARIABLE2" = "value2"
                           }
                           # Por defecto lo suyo sería: {}
                            # ["VAR1=valor1", "VAR1=valor2"]
                            # ["VAR1", "valor1", "VAR2", "valor2"]
                            # ["VAR1:valor1", "VAR2:valor2"]
                            # ["VAR1=valor1", "VAR2=valor2"]
variables_puertos        =  [
                                {
                                    interno = 80
                                    externo = 8080
                                    ip      = "0.0.0.0"
                                },
                                {
                                    interno = 443
                                    externo = 8443
                                }
                            ]
                            # Por defecto lo suyo sería: []
                           