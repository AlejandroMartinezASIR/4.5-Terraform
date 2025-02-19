# Terraform_AWS
Este repositorio es para realizar y explicar la estructura de Terraform para el despliegue de las instancias de AWS

- En está practica tendremos que realizar un script pero con una estructura de [*_Terraform_*](https://www.terraform.io) para implementar la estructura de las máquinas que utilizamos en la Práctica 1.11 de IAW del trimestre pasado.


# ¿ Qué es Terraform ?
- [*_Terraform_*](https://www.terraform.io) es un software de insfraestructura cómo codigo desarrollado por HashiCorp. 
    Es una herramienta que nos permite la configuración de software diseñada para potenciar la automatización de múltiples procesos a través de conceptos como el de insfraesture as *_code_*.


# Estructura de este script.

- Este script deberá tener tres funciones básicas:
1. Crear el `grupo de seguridad`
2. Crear la `instancia`
3. Crear y asociar la `IP flotante`

- Como estructura de Terraform nuestro directorio tendrá que tener la siguiente estructura.

    ```
    .
    ├── README.md
    └── Terraform
        ├── main.tf
        ├── terraform.tfstate
        └── terraform.tfstate.backup

    ```

- Añadiendo archivos también como el `.gitignore` que explicaremos al final.


# Creación del grupo de seguridad.

- La sintáxis que vamos a seguir para crear el grupo de seguridad es la siguiente:

    ```
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

    ```
- Los apartados principales son:

1. `from_port = Que nos indica el puerto de salida`
2. `to_port = Que nos indica el puerto de entrada`
3. `protocol = Puede ser o TCP o UDP`
4. `cird_blocks = Hace referencia al bloque de redes que queremos que se conecte.`

- En este caso podemos observar el *_script_* para el *_frontend_*. También podemos observar la diferencia entre `ingress` o `egress`. Esto hace referencia a las reglas de entrada que queremos generar, como a las reglas de salida.

# Creación de la instancia.

- Para crear la instancia tendremos que seguir el ejemplo siguiente:

    ```
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
    ```

- *_¿Cuales son los apartados más importantes_*?

1. `ami = Es el código de identificación del SO que queremos utilizar`
2. `Instancie_key = Es el vockey, o claves de seguridad por las que accedemos por ssh a nuestras máquinas`
3. `Instance_type = Es el nivel de flavours que queremos ponerle, es decir, el hardware virtual de la máquina.`
4. `Security_Group = Hace referencia a la variable que anteriormente hemos creado con el nombre del grupo de seguridad.`


# Creación y asociación de la IPS.

- Para crear las ips tendremos que seguir la siguiente estructura:

    ```
        # Creamos una IP elástica y la asociamos a la instancia al frontend1
    resource "aws_eip" "ip_elastica1" {
    instance = aws_instance.FrontEnd.id
    }

    # Mostramos la IP pública de la instancia del frontend1
    output "elastic_ip1" {
    value = aws_eip.ip_elastica1.public_ip
    }
    ```

- El primer bloque del script nos permite crear una ip elástica a través de `aws` gracias al uso de `aws_eip` como *_resource_*. Al declararle un nombre de instancía en este caso `FrontEnd` automáticamente hará la acciónd de asociarse con la instancia que anteriormente creemos y se llame así.

    El segundo bloque nos permite que una vez hayamos lanzado el `terraform apply` y haga todo correctamente, podremos ver que ips se han asociado con que máquina.