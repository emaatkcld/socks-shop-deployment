locals {
  name = "sock"
}
# create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.name}-vpc"
  }
}
# create pub subnet 1
resource "aws_subnet" "pubsub01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${local.name}-pubsub01"
  }
}
# create pub subnet 2
resource "aws_subnet" "pubsub02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "${local.name}-pubsub02"
  }
}
# create pub subnet 3
resource "aws_subnet" "pubsub03" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${local.name}-pubsub03"
  }
}
# create prv subnet 1
resource "aws_subnet" "prvtsub01" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${local.name}-prvtsub01"
  }
}
# create prv subnet 2
resource "aws_subnet" "prvtsub02" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "${local.name}-prvtsub02"
  }
}
# create prv subnet 3
resource "aws_subnet" "prvtsub03" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${local.name}-prvtsub03"
  }
}
# create an IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}
# Allocate Elastic IP Address
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${local.name}-EIP"
  }
}
# Create Nat Gateway  in Public Subnet 1
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pubsub01.id

  tags = {
    Name = "${local.name}-nat-gateway"
  }
}
# create a public route table
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.name}-public-RT"
  }
}
# assiociation of route table to public subnet 1
resource "aws_route_table_association" "Public-RT-ass" {
  subnet_id      = aws_subnet.pubsub01.id
  route_table_id = aws_route_table.public-RT.id
}
# assiociation of route table to public subnet 2
resource "aws_route_table_association" "Public-RT-ass-2" {
  subnet_id      = aws_subnet.pubsub02.id
  route_table_id = aws_route_table.public-RT.id
}
# assiociation of route table to public subnet 3
resource "aws_route_table_association" "Public-RT-ass-3" {
  subnet_id      = aws_subnet.pubsub03.id
  route_table_id = aws_route_table.public-RT.id
}
# Create Private Route Table  and Add Route Through Nat Gateway 
resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "${local.name}-private-RT"
  }
}
# Associate Private Subnet 1 with "Private Route Table "
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.prvtsub01.id
  route_table_id = aws_route_table.private-RT.id
}
# Associate Private Subnet 2 with "Private Route Table "
resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.prvtsub02.id
  route_table_id = aws_route_table.private-RT.id
}
# Associate Private Subnet 3 with "Private Route Table "
resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  subnet_id      = aws_subnet.prvtsub03.id
  route_table_id = aws_route_table.private-RT.id
}
# Creating Jenkins security group
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 8080
    to_port     = 8080
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
    Name = "${local.name}-jenkins-sg"
  }
}
# Creating RSA key of size 4096 bits
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "keypair" {
  content         = tls_private_key.keypair.private_key_pem
  filename        = "jenkins-keypair.pem"
  file_permission = "600"
}
# Creating keypair
resource "aws_key_pair" "keypair" {
  key_name   = "jenkins-keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}
#Create Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami                         = "ami-0f2cb8c8044faf2da" # RedHat eu west1 
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.id
  subnet_id                   = aws_subnet.pubsub01.id
  key_name                    = aws_key_pair.keypair.id
  user_data                   = local.jenkins_user_data 

  tags = {
    Name = "${local.name}-jenkins"
  }
}

#  Create IAM Policy
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}
# Create IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role2"
  assume_role_policy = "${file("${path.root}/ec2-assume.json")}"
}
# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile2"
  role = aws_iam_role.ec2_role.name
}