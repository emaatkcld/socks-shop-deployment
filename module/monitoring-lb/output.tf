output "prometheus-dns-name" {
  value = aws_lb.prom-lb.dns_name
}
output "prom-zoneid" {
  value = aws_lb.prom-lb.zone_id
}
output "grafana-zone_id" {
    value = aws_lb.grafana-lb.zone_id
}
output "grafana-dns-name" {
    value = aws_lb.grafana-lb.dns_name
}