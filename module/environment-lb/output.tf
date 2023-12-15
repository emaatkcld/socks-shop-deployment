output "stage-dns-name" {
  value = aws_lb.stage-lb.dns_name
}
output "stage-zoneid" {
  value = aws_lb.stage-lb.zone_id
}
output "prod-dns-name" {
  value = aws_lb.prod-alb.dns_name
}
output "prod-zoneid" {
  value = aws_lb.prod-alb.zone_id
}