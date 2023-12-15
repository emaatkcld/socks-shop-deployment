# Creating Target Group
resource "aws_lb_target_group" "prom-tg" {
  name             = var.prom-tg
  port             = 31090
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  health_check {
    interval            = 30
    path                = "/graph"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

#Create prometheus target group attachment
resource "aws_lb_target_group_attachment" "prom-attachment" {
  target_group_arn      = aws_lb_target_group.prom-tg.arn
  target_id             = "${element(split(",", join(",", "${var.instance}")), count.index)}"
  port                  = 31090
  count                 = 3
}

# Creating promethues LB Target Group
resource "aws_lb" "prom-lb" {
  name                 = var.tag-prom-lb
  internal             = false
  load_balancer_type   = "application"
  subnets              = var.subnets
  security_groups      = var.k8s

  tags = {
    Name = var.tag-prom-lb
  }
}


#Creating Prometheus Load Balancer Listner for http
resource "aws_lb_listener" "prom-listener-1" {
  load_balancer_arn = aws_lb.prom-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prom-tg.arn
  }
}

#Creating Prometheus Load Balancer Listner for https
resource "aws_lb_listener" "prom-listener-2" {
  load_balancer_arn = aws_lb.prom-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prom-tg.arn
  }
}

# Creating Grafana LB Target Group
resource "aws_lb_target_group" "grafana-tg" {
  name       = var.graf-tg
  port       = 31300
  protocol   = "HTTP"
  vpc_id     = var.vpc_id
  health_check {
    healthy_threshold        = 3
    unhealthy_threshold      = 5
    interval                 = 30
    timeout                  = 5
    path = "/login"
  }
}

# Adding Target Group Attachment for Grafana
resource "aws_lb_target_group_attachment" "grafana-attachment" {
  target_group_arn      = aws_lb_target_group.grafana-tg.arn
  target_id             = "${element(split(",", join(",", "${var.instance}")), count.index)}"
  port                  = 31300
  count                 = 3
}

# Creating Grafana LoadBalancer
resource "aws_lb" "grafana-lb" {
  name                 = var.tag-grafana_lb
  internal             = false
  load_balancer_type   = "application"
  subnets              = var.subnets
  security_groups      = var.k8s

  tags = {
    Name = var.tag-grafana_lb
  }
}

# Creating Grafana grafana-listener-http
resource "aws_lb_listener" "grafana-listener-1" {
  load_balancer_arn = aws_lb.grafana-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}

#Creating Grafana Load Balancer Listner for https
resource "aws_lb_listener" "grafana-listener-2" {
  load_balancer_arn = aws_lb.grafana-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}