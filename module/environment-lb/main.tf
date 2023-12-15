# Creating stage lb
resource "aws_lb" "stage-lb" {
  name               = var.tag-stage-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb-sg
  subnets            = var.subnet-id
  enable_deletion_protection = false
  tags = {
    Name = var.tag-stage-alb
  }
}

# creating Stage LB Target group
resource "aws_lb_target_group" "stage-target-group" {
  name     = var.stage-tg-name
  port     = 30001
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

# Add target group attachment for stage to workernodes
resource "aws_lb_target_group_attachment" "stage-target-group-attach" {
  target_group_arn = aws_lb_target_group.stage-target-group.arn
  target_id        = element(split(",", join(",", "${var.instance}")), count.index)
  port             = 30001
  count            = 3
}

# creating http listener for stage
resource "aws_lb_listener" "stage-listener" {
  load_balancer_arn = aws_lb.stage-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-target-group.arn
  }
}

#Creating Stage Load Balancer Listner for https
resource "aws_lb_listener" "stage-listener-2" {
  load_balancer_arn = aws_lb.stage-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-target-group.arn
  }
}

# Creating Prod Application Load balancer
resource "aws_lb" "prod-alb" {
  name               = var.tag-prod-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb-sg
  subnets            = var.subnet-id
  enable_deletion_protection = false
  tags = {
    Name = var.tag-prod-alb
  }
}

#Creating Target Group Prod
resource "aws_lb_target_group" "prod-tg" {
  name     = var.prodtg
  port     = 30002
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }
}

# Add target group attachment for Prod workernodes
resource "aws_lb_target_group_attachment" "prod-target-group-attach" {
  target_group_arn = aws_lb_target_group.prod-tg.arn
  target_id        = element(split(",", join(",", "${var.instance}")), count.index)
  port             = 30002
  count            = 3
}

# creating http listener for prod
resource "aws_lb_listener" "prod-listener" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-tg.arn
  }
}

#Creating Production Load Balancer Listner for https
resource "aws_lb_listener" "prod-listener-2" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-tg.arn
  }
}