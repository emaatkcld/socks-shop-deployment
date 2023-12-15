output "haproxy1_private_ip" {
    value = aws_instance.haproxy1.private_ip
}
output "haproxy2_private_ip" {
    value = aws_instance.haproxy2.private_ip
}
