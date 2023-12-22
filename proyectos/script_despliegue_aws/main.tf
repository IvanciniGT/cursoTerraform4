module "mis_claves" {
    source                      = "../modulo_claves_ssh"
    directorio_ficheros_claves  = "./claves"
}

# Solamente nos vamos a preocupar de crear una máquina en AWS

# Qué servicio de AWS es el que me permite crear máquinas virtuales

data "aws_ami" "imagen_del_servidor" {
  most_recent      = true
  owners           = ["099720109477"] # Canonical (los que hacen ubuntu)

  filter {
    name   = "name"
    values = ["*ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.imagen_del_servidor.image_id  # "ami-0905a3c97561e0b69"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.clave_en_aws.key_name # Esto fuerza la dependencia en el grafo
  security_groups = [ aws_security_group.reglas_firewall_red.name ]
  tags = {
    Name = "${var.nombre_despliegue}-servidor"
  }
  
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command =<<EOT
                count=20
                demora=2
                for (( i=0; i<=count; i++ ))
                do
                  echo "Intento de ping $i"
                  ping -c 1 ${self.public_ip}
                  [[ $? == 0 ]] && exit 0 || echo "Ping fallido"
                  sleep $demora
                done
                exit 1
               EOT
  }
}

resource "aws_key_pair" "clave_en_aws" {
  key_name   = "${var.nombre_despliegue}-claves"
  public_key = module.mis_claves.claves.publica.openssh
}

# No tengo claves ... bueno si las tengo , gracias a mi módulo... pero no se las he puesto a la máquina
# La máquina si tiene red (dios mediante)... pero todas las comunicaciones cerradas (SECURITY GROUP)

resource "aws_security_group" "reglas_firewall_red" {
  name        = "${var.nombre_despliegue}-reglas-firewall-red-servidor-web"
  description = "Abrir los puertos adecuados"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.nombre_despliegue}-reglas-firewall-red-servidor-web"
  }
}


# AMI:
#ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20231207
#ami-0905a3c97561e0b69
#Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-12-07
#OwnerAlias: amazon
#Plataforma: Ubuntu
#Arquitectura: x86_64
#Propietario: 099720109477
#Publish date: 2023-12-07
#Tipo de dispositivo raíz: ebs
#Virtualización: hvm
#ENA enabled: Sí


# script ---> terraform ---> hashicorp/aws-provider ---> aws ----> aws.com
                                                #         ^
                                                #    credenciales
                                                #       aws configure
                                                #         Si no hago login, buscan variables de entorno con mis credenciales: GENIAL PARA LLAMARLO DESDE JENKINS
                                                #       az login