
resource "null_resource" "pruebas_servidor" {

  triggers = {
    ejecutar = var.ejecutar_pruebas_si_el_servidor_no_se_ha_creado ? uuid() : "NO EJECUTAR"
    servidor = var.id_servidor
  }
  
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command =<<EOT
                count=20
                demora=2
                for (( i=0; i<=count; i++ ))
                do
                  echo "Intento de ping $i"
                  ping -c 1 ${var.ip}
                  [[ $? == 0 ]] && exit 0 || echo "Ping fallido"
                  sleep $demora
                done
                exit 1
               EOT
  }

  connection {
      type        = "ssh"
      user        = var.usuario
      private_key = var.clave_privada
      port        = 22
      host        = var.ip
  }
  
  provisioner "remote-exec" {
      inline = [ "echo Eureka" ]
  }
}
