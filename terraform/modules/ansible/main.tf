data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {

    name = "name"

    values = ["al2023-ami-2023.*-x86_64"]

  }

  filter {

    name = "virtualization-type"

    values = ["hvm"]

  }

}

resource "aws_security_group" "ansible" {

  name = "${var.project_name}-ansible-sg"

  description = "Security group for Ansible Controller"

  vpc_id = var.vpc_id

  ingress {

    description = "SSH from my workstation"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${var.project_name}-ansible-sg"

  }

}

resource "aws_instance" "ansible" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible.id]

  associate_public_ip_address = true

  key_name = var.key_name

  tags = {

    Name = "${var.project_name}-ansible-controller"

  }

  lifecycle {
    ignore_changes = [
      associate_public_ip_address,
    ]
  }
}
