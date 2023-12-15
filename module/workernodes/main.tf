#Create Worker Nodes (WN) Host
resource "aws_instance" "worker-nodes" {
  ami                    = var.ami
  instance_type          = var.instance-type
  vpc_security_group_ids = var.k8-sg
  subnet_id              = element(var.prvsubnet, count.index)
  key_name               = var.keypair
  count                  = 3
 
  tags = {
    Name = "${var.workernodes}${count.index}"
  }
}
