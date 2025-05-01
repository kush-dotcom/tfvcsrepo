terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1" //Here the resources will get created
}

data "aws_ami" "this" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_vpc" "this" {
  default = true
}

locals { //Both ingress & egress are defined in locals
  ports = {
    ssh = {
      direction = "ingress" //Taking this as string as we need to print it
      f_port    = 22
      protocol  = "tcp"
      cidr      = "192.168.29.86/32"
    }
    http = {
      direction = "ingress"
      f_port    = 80
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
    https = {
      direction = "ingress"
      f_port    = 443
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    }
    all = {
      direction = "egress"
      f_port    = 0
      to_port   = 65535
      protocol  = "-1"
      cidr      = "0.0.0.0/0"
    }
  }
}

resource "aws_security_group" "main" {
  name   = "mysg"
  vpc_id = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "main" {
  for_each          = local.ports //Using for_each calling the direction & printing the port,protocol,cidr seperately
  type              = each.value.direction
  from_port         = each.value.f_port
  to_port           = each.value.f_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr] //It will always come in LIST
  security_group_id = aws_security_group.main.id
}

resource "aws_key_pair" "sre" {
  key_name   = "mykey"
  public_key = file("./aws.pub")
}

resource "aws_instance" "this" {
  ami             = data.aws_ami.this.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.sre.key_name
  security_groups = [aws_security_group.main.name]
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
