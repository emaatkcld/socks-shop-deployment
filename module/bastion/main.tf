resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnets
  vpc_security_group_ids      = [var.bastion-sg]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = templatefile("./module/bastion/bastion.sh", {
    private-key             = var.private-key
})
  
  tags = {
    Name = var.tag-bastion
  }
}
