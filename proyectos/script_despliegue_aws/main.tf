module "claves" {
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
  ami           = data.aws_ami.imagen_del_servidor.image_id  # "ami-0905a3c97561e0b69"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.nombre_despliegue}-servidor"
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