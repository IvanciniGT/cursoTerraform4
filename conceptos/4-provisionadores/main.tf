resource "docker_image" "mi-imagen" {
    name = "nginx:latest"
}


resource "docker_container" "mi-contenedor" {
    name = "mi-nginx"
    image = docker_image.mi-imagen.image_id
    
    # Quiero asegurarme que el contenedor responde a ping (tiene conectividad a red)
    provisioner "local-exec" {
        command = "ping -c 1 ${docker_container.mi-contenedor.network_data[0].ip_address}8"   
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
        interpreter = [ "/bin/bash" "-c" ]
        command = "echo CONTENEDOR ELIMINADO: ${self.name}"
    }
    
    
}
