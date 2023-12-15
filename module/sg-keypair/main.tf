# Creating RSA key of size 4096 bits
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "keypair" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}
# Creating keypair
resource "aws_key_pair" "keypair" {
  key_name   = "keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}
# Bastion security group
resource "aws_security_group" "bastion" {
  name        = var.bastion-sg
  description = "Bastion Security Group"
  vpc_id      = var.vpc-id
  ingress {
    description = "bastion ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = var.bastion-sg
  }
}
# Ansible security group
resource "aws_security_group" "ansible" {
  name        = var.ansible-sg
  description = "Ansible Security Group"
  vpc_id      = var.vpc-id
  ingress {
    description = "ansible ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = var.ansible-sg
  }
}
# k8s security group
resource "aws_security_group" "k8s" {
  name        = var.k8s-sg
  description = "k8s Security Group"
  vpc_id      = var.vpc-id
  ingress {
    description = "k8s port"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = var.k8s-sg
  }
}
