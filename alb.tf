# ═══════════════════════════════════════════════════════════════════════════════
# EXTERNAL ALB (Internet-facing) - Web Tier
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_lb" "external" {
  name               = "Lab-External-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = { Name = "Lab-External-ALB" }
}

resource "aws_lb_target_group" "web" {
  name     = "Lab-Web-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = { Name = "Lab-Web-TG" }
}

resource "aws_lb_listener" "external" {
  load_balancer_arn = aws_lb.external.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# ═══════════════════════════════════════════════════════════════════════════════
# INTERNAL ALB (Private) - Backend Tier (BONUS)
# ═══════════════════════════════════════════════════════════════════════════════

resource "aws_lb" "internal" {
  name               = "Lab-Internal-ALB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb.id]
  subnets            = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = { Name = "Lab-Internal-ALB" }
}

resource "aws_lb_target_group" "backend" {
  name     = "Lab-Backend-TG"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/api/health"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = { Name = "Lab-Backend-TG" }
}

resource "aws_lb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
