terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Primera máquina (ya creada, ¡no borrar!)
resource "aws_instance" "mi_maquina1" {
  ami           = "ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS
  instance_type = "t2.medium"
  security_groups = [aws_security_group.allow_all.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y && apt upgrade -y
              mkdir -p /root/.ssh
              cat <<EOC > /root/.ssh/authorized_keys
              ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsVgu/XBih32vMzQp11891GF51OIMVnJKuK4zD9WTMytoGMrAhgGS366IJURBkMzuzdlslMe2bjXUprw5ZssOY9yDBlbMRjW7J5X2Xp9QDz33Gm9sWa0VFUZSqbHoTVhrTZTtn0LnLLjLTNP12itCTSYf9kA4BTbFWEwtfUqUquNVehD4MmnHFaalBenm9ZDwdq8cvPwgenJby6Gz8uP5eYrv6+HSzTN6PLdTbZAKmJv06rvsE3r4Ot2HJJdDcqpiZOPCe/Qrhvr9UIx6XXxMIJVSEFEFh6k8MKcZ29RRs6I9UMHDO+o+PyZAM4MytGdqIOvb0e032ctwTx7UiYNZP0zVc3ASot2fL3f0agJvsMkgppn+Jmla+W5WHJvCTBoO8KPi+XHrUllS1T74lMqBsFja2DulVkWZEkuEFz0dV0XmbcmktMMLnQCmswrIBHZihZFG4bMt4t6ycIbLYJLnJ4H7VMiSI8cWdprWzpYusiVAuXRKXstCGE6oA4r+/UZU= root@ip-172-31-17-14
              EOC
              chmod 700 /root/.ssh
              chmod 600 /root/.ssh/authorized_keys
              chown -R root:root /root/.ssh
              EOF

  tags = {
    Name = "mi_maquina1"
  }
}

resource "aws_eip" "ip_mi_maquina1" {
  instance = aws_instance.mi_maquina1.id
  vpc      = true
}

# Segunda máquina nueva
resource "aws_instance" "mi_maquina2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.medium"
  security_groups = [aws_security_group.allow_all.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y && apt upgrade -y
              mkdir -p /root/.ssh
              cat <<EOC > /root/.ssh/authorized_keys
              ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsVgu/XBih32vMzQp11891GF51OIMVnJKuK4zD9WTMytoGMrAhgGS366IJURBkMzuzdlslMe2bjXUprw5ZssOY9yDBlbMRjW7J5X2Xp9QDz33Gm9sWa0VFUZSqbHoTVhrTZTtn0LnLLjLTNP12itCTSYf9kA4BTbFWEwtfUqUquNVehD4MmnHFaalBenm9ZDwdq8cvPwgenJby6Gz8uP5eYrv6+HSzTN6PLdTbZAKmJv06rvsE3r4Ot2HJJdDcqpiZOPCe/Qrhvr9UIx6XXxMIJVSEFEFh6k8MKcZ29RRs6I9UMHDO+o+PyZAM4MytGdqIOvb0e032ctwTx7UiYNZP0zVc3ASot2fL3f0agJvsMkgppn+Jmla+W5WHJvCTBoO8KPi+XHrUllS1T74lMqBsFja2DulVkWZEkuEFz0dV0XmbcmktMMLnQCmswrIBHZihZFG4bMt4t6ycIbLYJLnJ4H7VMiSI8cWdprWzpYusiVAuXRKXstCGE6oA4r+/UZU= root@ip-172-31-17-14
              EOC
              chmod 700 /root/.ssh
              chmod 600 /root/.ssh/authorized_keys
              chown -R root:root /root/.ssh
              EOF

  tags = {
    Name = "mi_maquina2"
  }
}

resource "aws_eip" "ip_mi_maquina2" {
  instance = aws_instance.mi_maquina2.id
  vpc      = true
}
