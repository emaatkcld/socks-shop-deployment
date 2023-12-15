output "ansible" {
  value = module.ansible.ansible-ip
}
output "bastion" {
  value = module.bastion.bastion_public_ip
}
output "haproxy1" {
  value = module.haproxy.haproxy1_private_ip
}
output "haproxy2" {
  value = module.haproxy.haproxy2_private_ip
}
output "masternodes" {
  value = module.masternodes.masternodes-privateip
}
output "workernodes" {
  value = module.workernodes.workernodes-privateip
}