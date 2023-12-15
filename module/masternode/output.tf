output "masternodes-privateip" {
  value = aws_instance.master-nodes.*.private_ip
}
output "masternodes-id" {
    value = aws_instance.master-nodes.*.id
}