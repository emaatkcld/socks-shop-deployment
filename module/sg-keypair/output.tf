output "bastion-sg" {
  value = aws_security_group.bastion.id
}
output "ansible-sg" {
  value = aws_security_group.ansible.id
}
output "k8s-sg" {
  value = aws_security_group.k8s.id
}
output "keypair-id" {
  value = aws_key_pair.keypair.id
}
output "private-key" {
  value = tls_private_key.keypair.private_key_pem
}