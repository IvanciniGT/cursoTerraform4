resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}


resource "docker_container" "mi-contenedor" {
    count           = var.numero_contenedores
    name            = "contenedor-${count.index+1}"
    image = docker_image.mi-imagen.image_id
    
    # Quiero asegurarme que el contenedor responde a ping (tiene conectividad a red)
    provisioner "local-exec" {
        command = "ping -c 1 ${self.network_data[0].ip_address}"   # Poner algo adicional dentro de las comillas para probarlo
        # El provisioner se ejecuta solo si el recurso es creado o modificado
        # Por defecto si un provisionador falla, el script se corta
        on_failure = continue # Con esto fuerzo a que aunque el provisionador falle, el script continue
    }   
    
    provisioner "local-exec" {
    # Dentro de cualquier recurso, puedo usar la variable "self" para referirme al propio recurso
        command = "ping -c 1 ${self.network_data[0].ip_address}"   
    }    

    # Puedo configurar provisionadores que se ejecuten solamente en caso de eliminación del recurso
    provisioner "local-exec" {
    # Dentro de cualquier recurso, puedo usar la variable "self" para referirme al propio recurso
        command = "echo CONTENEDOR ELIMINADO: ${self.name}"
        when = destroy # Con esto le indico a terraform que me ejecute el provisionador al borrar el recurso. 
        # De lo contrario se ejecutaría solo en su creación o modificación, como hemos visto arriba
    }

    # Donde se ejecuta el comando? "/bin/sh" "-c"
    # Y me interesa que se ejecute usando la sh como intérprete? QUIZAS SI... QUIZAS NO
    # Funcionaría esto en windows? NO
    # Podemos elegir el intérprete de ejecución de nuestros comandos: sw, bash, ps1, cmd, python, perl
    provisioner "local-exec" {
        interpreter = [ "/bin/bash", "-c" ]
        command = "echo La ip del contenedor:  ${self.name} es: ${self.network_data[0].ip_address} "
    }
    provisioner "local-exec" {
        interpreter = [ "python" , "-c" ]
        command = "print( 'La ip del contenedor: ${self.name} es: ${self.network_data[0].ip_address}')"
    }
    
    provisioner "local-exec" {
        interpreter = [ "python" , "-c" ]
        # Terraform tiene una sintaxis especial para crear textos multilinea
        # Esto lo puedo aplicar para rellenar CUALQUIER propiedad de tipo texto de mis recursos
        # No solo para los comandos
        command = <<-EOT
                    print('La ip del contenedor: ${self.name}')
                    print(' es: ${self.network_data[0].ip_address}')
                    EOT
    }
    # Podemos fijar VARIABLES DEL ENTORNO para el intérprete    
    provisioner "local-exec" {
        interpreter = [ "/bin/bash", "-c" ]
        command = "echo La ip del contenedor: $NOMBRE_DEL_CONTENEDOR es: ${self.network_data[0].ip_address} "
        environment = {
            NOMBRE_DEL_CONTENEDOR = self.name
        }
    }
}

locals {
    contenido_fichero = join("\n", [ for contenedor in docker_container.mi-contenedor:
                                    "${contenedor.name}=${contenedor.network_data[0].ip_address}" ])
}

resource "null_resource" "regenerar_fichero_ips"{
    # Cuando necesito regenerar el recurso? Me interesa que el recurso sea regenerado... cuando necesite regenerar el fichero
    # Cuando necesito regenerar el fichero? Cuando cambie el contenido del fichero
    triggers = {
        #recrear_cuando_cambie_el_texto = local.contenido_fichero
        # Imaginad que quiero que el fichero se regenere siempre que se ejecuta el script:
        # Por ejemplo... me da miedo que el fichero me lo hayan borrado
        propiedad_cambia_en_cada_ejecucion = uuid() # ESTO YA ES UN TRUCO RASTRERO DENTRO DE LA ÑAPA SUCIA QUE ESTAMOS HACIENDO !
    }
    # Si alguno de los valores del mapa cambia entre ejecuciones, el recurso será recreado
    # Y al recrearse, su propvisionador se ejecuta.
    # Es una ÑAPA gigante OFICIALIZADA para poder tener más control de cuando se debe ejecutar un provisionador

    provisioner "local-exec" {
        interpreter = [ "/bin/bash", "-c" ]
        command = <<-EOT
                    mkdir -p carpeta_ips
                    echo "$CONTENIDO_FICHERO" > carpeta_ips/ips.txt
                    EOT
        environment = {
            CONTENIDO_FICHERO = local.contenido_fichero
        }
    }
}
