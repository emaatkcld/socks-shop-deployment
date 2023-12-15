resource "aws_instance" "haproxy1" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnets
  vpc_security_group_ids      = [var.haproxy-sg]
  key_name                    = var.key_name
  user_data                   = templatefile("./module/haproxy/haproxy1.sh", {
    master1 = var.master1
    master2 = var.master2
    master3 = var.master3
})
  
  tags = {
    Name = var.tag-haproxy1
  }
}

resource "aws_instance" "haproxy2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnets2
  vpc_security_group_ids      = [var.haproxy-sg]
  key_name                    = var.key_name
  user_data                   = templatefile("./module/haproxy/haproxy2.sh", {
    master1 = var.master1
    master2 = var.master2
    master3 = var.master3
})
  
  tags = {
    Name = var.tag-haproxy2
  }
}