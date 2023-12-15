output "stage" {
  value = aws_route53_record.stage.id
}
output "prod" {
  value = aws_route53_record.prod.id
}
output "graf" {
    value = aws_route53_record.graf.id
}
output "prom" {
    value = aws_route53_record.prom.id
}
output "zone_id" {
  value = data.aws_route53_zone.route53_zone.zone_id
}
output "certificate-arn" {
  value = aws_acm_certificate.ssl-cert.arn
}