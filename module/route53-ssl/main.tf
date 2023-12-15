#Route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name         = var.domain-name
  private_zone = false
}

#Create route 53 A record for stage environment
resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain-name1
  type    = "A"
  alias {
    name                   = var.stage_lb_dns_name
    zone_id                = var.stage_lb_zoneid
    evaluate_target_health = false
  }
}

#Create route 53 A record for production environment
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain-name2
  type    = "A"
  alias {
    name                   = var.prod_lb_dns_name
    zone_id                = var.prod_lb_zoneid
    evaluate_target_health = false
  }
}

#Create route 53 A record for grafana
resource "aws_route53_record" "graf" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain-name3
  type    = "A"
  alias {
    name                   = var.graf_lb_dns_name
    zone_id                = var.graf_lb_zoneid
    evaluate_target_health = false
  }
}

#Create route 53 A record for prometheus
resource "aws_route53_record" "prom" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain-name4
  type    = "A"
  alias {
    name                   = var.prom_lb_dns_name
    zone_id                = var.prom_lb_zoneid
    evaluate_target_health = false
  }
}

# SSL certificate
resource "aws_acm_certificate" "ssl-cert" {
  domain_name = var.domain-name
  subject_alternative_names = [var.domain-name5]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Record for Route 53 domain validation
resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.ssl-cert.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.route53_zone.zone_id
}

# SSL validation
resource "aws_acm_certificate_validation" "ssl-validation" {
  certificate_arn = aws_acm_certificate.ssl-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}