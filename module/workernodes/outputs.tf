output "workernodes-privateip" {
    value = aws_instance.worker-nodes.*.private_ip
}
output "workernodes-id" {
    value = aws_instance.worker-nodes.*.id
}
