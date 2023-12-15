# create Ansible_server
resource "aws_instance" "ansible" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = var.ansible-sg
  key_name                    = var.key_name
  user_data                   = templatefile("./module/ansible/userdata.sh",{
    keypair  = var.private-key,
    haproxy1 = var.haproxy1,
    haproxy2 = var.haproxy2,
    main-master = var.main-master,
    member-master01 = var.member-master01,
    member-master02 = var.member-master02,
    worker01 = var.worker01,
    worker02 = var.worker02,
    worker03 = var.worker03
  })
  tags = {
    Name = var.instance-name
  }
}

# create null resource to help copy the playbook directory into our ansible server
resource "null_resource" "copy-playbook-dir" {
  connection {
    type = "ssh"
    host = aws_instance.ansible.private_ip
    user = "ubuntu"
    private_key = var.private-key
    bastion_host = var.bastion-host
    bastion_user = "ubuntu"
    bastion_private_key = var.private-key
  }
  provisioner "file" {
    source = "./module/ansible/playbooks"
    destination = "/home/ubuntu/playbooks"
  }
}