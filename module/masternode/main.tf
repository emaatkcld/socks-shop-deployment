# Create three EC2 instances for master nodes
resource "aws_instance" "master-nodes" {
  count         = var.instance-count
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.k8-sg
  subnet_id     = element(var.subnet_id, count.index)
  key_name      = var.key_name

  tags = {
    name = "${var.tag-masternodes}${count.index}"
  }
}
