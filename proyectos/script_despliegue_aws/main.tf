module "mis_claves" {
  source                     = "../modulo_claves_ssh"
  directorio_ficheros_claves = "./claves"
}

# Solamente nos vamos a preocupar de crear una máquina en AWS

# Qué servicio de AWS es el que me permite crear máquinas virtuales

data "aws_ami" "imagen_del_servidor" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (los que hacen ubuntu)

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

locals {
  existe_ya_el_servidor = length(data.aws_instances.saber_si_la_instancia_existe.ids) == 1
  id_servidor_existente = data.aws_instances.saber_si_la_instancia_existe.ids[0]
  nombre_servidor       = "${var.nombre_despliegue}-servidor"
  imagen_servidor = (local.existe_ya_el_servidor
    ? var.recrear_el_servidor_si_nueva_imagen      # Y me piden recrearlo si hay un cambio de imagen 
    ? data.aws_ami.imagen_del_servidor.image_id    # Pongo la nueva imagen
    : data.aws_instance.instancia_existente[0].ami # Caso contrario, la que tiene el actual, para que no se recree
    : data.aws_ami.imagen_del_servidor.image_id    # Y si no existia... la que haya ahora.
  )
}
# ( length(data.aws_instances.saber_si_la_instancia_existe.ids) == 1 && ! var.recrear_el_servidor_si_nueva_imagen     # Y me piden recrearlo si hay un cambio de imagen 
#        ? data.aws_instance.instancia_existente[0].ami  # Caso contrario, la que tiene el actual, para que no se recree
#    : data.aws_ami.imagen_del_servidor.image_id  # Y si no existia... la que haya ahora.
#)

data "aws_instances" "saber_si_la_instancia_existe" {
  filter {
    name   = "tag:Name"
    values = [local.nombre_servidor]
  }
}

data "aws_instance" "instancia_existente" {
  count       = local.existe_ya_el_servidor ? 1 : 0
  instance_id = local.id_servidor_existente
}

resource "aws_instance" "web" {
  ami             = local.imagen_servidor
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.clave_en_aws.key_name # Esto fuerza la dependencia en el grafo
  security_groups = [aws_security_group.reglas_firewall_red.name]
  tags = {
    Name = local.nombre_servidor
  }
  network_interface {
    network_interface_id = aws_network_interface.interfaz.id
    device_index         = 0
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

module "prueba_servidor" {
  source                                          = "./modules/test"
  ip                                              = aws_instance.web.public_ip
  usuario                                         = "ubuntu"
  clave_privada                                   = module.mis_claves.claves.privada.pem
  id_servidor                                     = aws_instance.web.id
  ejecutar_pruebas_si_el_servidor_no_se_ha_creado = true
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

resource "aws_vpc" "red" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.nombre_despliegue}-network"
  }
}
resource "aws_subnet" "subred" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.nombre_despliegue}-internal"
  }
}

resource "aws_network_interface" "interfaz" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "${var.nombre_despliegue}--network_interface"
  }
}