# Configuramos el proveedor de AWS
provider "aws" {
  region = "us-east-1"
}

#----------------------------------------------------------------
# Creamos un grupo de seguridad frontedn1
resource "aws_security_group" "FrontEnd" {
  name        = "FrontEnd"
  description = "Grupo de seguridad para la instancia de Frontend"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

# Creamos una instancia EC2 solamente para el FrontEnd
resource "aws_instance" "FrontEnd" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.FrontEnd.name]

  tags = {
    Name = "FrontEnd"
  }
}


# Creamos una IP elástica y la asociamos a la instancia al frontend1
resource "aws_eip" "ip_elastica1" {
  instance = aws_instance.FrontEnd.id
}

# Mostramos la IP pública de la instancia del frontend1
output "elastic_ip1" {
  value = aws_eip.ip_elastica1.public_ip
}

#----------------------------------------------------------------

#----------------------------------------------------------------


# Creamos un grupo de seguridad para el frontend2
resource "aws_security_group" "FrontEnd2" {
  name        = "FrontEnd2"
  description = "Grupo de seguridad para la instancia de Frontend2"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

# Creamos una instancia EC2 solamente para el FrontEnd2
resource "aws_instance" "FrontEnd2" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.FrontEnd2.name]

  tags = {
    Name = "FrontEnd2"
  }
}

# Creamos una IP elástica y la asociamos a la instancia al frontedn2
resource "aws_eip" "ip_elastica2" {
  instance = aws_instance.FrontEnd2.id
}

# Mostramos la IP pública de la instancia del frontend2
output "elastic_ip2" {
  value = aws_eip.ip_elastica2.public_ip
}

#----------------------------------------------------------------


#----------------------------------------------------------------


# Creamos un grupo de seguridad del backend
resource "aws_security_group" "BackEnd" {
  name        = "BackEnd"
  description = "Grupo de seguridad para la instancia de Frontend"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}
# Creamos una instancia EC2 solamente para el backend 
resource "aws_instance" "BackEnd" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.small"
  key_name        = "vockey"
  security_groups = [aws_security_group.BackEnd.name]

  tags = {
    Name = "BackEnd"
  }
}

# Creamos una IP elástica y la asociamos a la instancia del backend
resource "aws_eip" "ip_elastica3" {
  instance = aws_instance.BackEnd.id
}

# Mostramos la IP pública de la instancia del backend
output "elastic_ip3" {
  value = aws_eip.ip_elastica3.public_ip
}


#----------------------------------------------------------------


#----------------------------------------------------------------


# Creamos un grupo de seguridad del load balancer
resource "aws_security_group" "LoadBalancer" {
  name        = "LoadBalancer"
  description = "Grupo de seguridad para la instancia de LoadBalancer"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}


# Creamos una instancia EC2 solamente para el LoadBalancer 
resource "aws_instance" "LoadBalancer" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.small"
  key_name        = "vockey"
  security_groups = [aws_security_group.LoadBalancer.name]

  tags = {
    Name = "LoadBalancer"
  }
}



# Creamos una IP elástica y la asociamos a la instancia load balancer
#resource "aws_eip" "ip_elastica4" {
  #instance = aws_instance.LoadBalancer.id
#}

# Mostramos la IP pública de la instancia del load balancer
#output "elastic_ip" {
  #value = aws_eip.ip_elastica4.public_ip
#}

#----------------------------------------------------------------


#----------------------------------------------------------------


# Creamos un grupo de seguridad del NFS
resource "aws_security_group" "NFS" {
  name        = "NFS"
  description = "Grupo de seguridad para la instancia de NFS"

  # Reglas de entrada para permitir el tráfico SSH, HTTP y HTTPS
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Reglas de salida para permitir todas las conexiones salientes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}


# Creamos una instancia EC2 solamente para el NFS 
resource "aws_instance" "NFS" {
  ami             = "ami-0c7217cdde317cfec"
  instance_type   = "t2.small"
  key_name        = "vockey"
  security_groups = [aws_security_group.NFS.name]

  tags = {
    Name = "NFS"
  }
}



# Creamos una IP elástica y la asociamos a la instancia NFS
resource "aws_eip" "ip_elastica5" {
  instance = aws_instance.NFS.id
}

# Mostramos la IP pública de la instancia NFS
output "elastic_ip5" {
  value = aws_eip.ip_elastica5.public_ip
}

#----------------------------------------------------------------





