resource "docker_image" "mi-imagen" {
    name = "rastasheep/ubuntu-sshd:18.04"
}

resource "docker_container" "mi-contenedor" {
    name  = "contenedor"
    image = docker_image.mi-imagen.image_id
    
    connection {
        # Configurar según las necesidades concretas según la documentación:
        # https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
        type        = "ssh"  # winrm | ssh
        user        = "root"
        password    = "root"
        port        = 22
        host        = self.network_data[0].ip_address
    }
    
    provisioner "remote-exec" {
        # Cambios con respecto al "local-exec":
        # No tiene propiedad interpreter... ein??? si tengo un script python??? Uso scripts... y le meto un SHEBANG
        # No tiene variables de entorno
        # Si tiene when = destroy
        # Si tiene on_failure = continue
        # Tampoco tiene command... en su lugar se llama inline... y es una lista de strings... cada item es un comando
        # Para poder ejecutarse necesita una conexión con un remoto, que es donde se ejecutan los comandos
        inline = [ "echo HOLA", "echo ADIOS" ]
    }
    
    provisioner "remote-exec" {
    # En esta caso pongo la ruta de un script que tenga en local, para que se copie y ejecute en el remoto
        script = "./mi-script.sh"
    }
    
    provisioner "remote-exec" {
        scripts = [ "./mi-script.sh", "./mi-script-2.sh" ]
    }
    
    # Provisionadores de tipo file
    provisioner "file" {
        # Tengo también: on_failure, when
        destination = "/tmp/miarchivo" # Donde dejo el archivo en el remoto
        source      = "./miarchivo.txt" # Ruta en local del archivo a copiar
    }   
    provisioner "file" {
        # Tengo también: on_failure, when
        destination = "/tmp/miarchivo-generado" # Donde dejo el archivo en el remoto
        content     = "CONTENIDO DEL ARHIVO GENERADO" #Contenido del archivo
                      # ^ ESTO NO SE USA NUNCA ASI
                      # Si acaso con la sintaxis HEREDOC <<-EOF ... puede tener alguna gracia.
                      # Lo que más gracia tiene y solemos usar aquí es la función: templatefile(path, vars)

    }
    
    
}
