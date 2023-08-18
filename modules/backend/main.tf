data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "backend_sg" {
  name_prefix = "backend-sg-"

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
}

resource "aws_instance" "ec2_instance" {
  instance_type = var.instance_type
  key_name      = var.key_name
  ami           = data.aws_ami.ubuntu22.id
  tags = {
    Name        = join("_", [var.env_short, "app", "01"])
    Environment = var.env_short
  }

  security_groups = [aws_security_group.backend_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}

