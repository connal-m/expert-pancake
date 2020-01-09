resource "aws_alb" "expert_pancake" {
  name            = "expert-pancake"
  subnets         = data.aws_subnet_ids.subnets.ids
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name        = "expert-pancake"
  port        = var.app_port
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_alb_listener" "main_http" {
  load_balancer_arn = aws_alb.expert_pancake.id
  port              = var.app_port

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener_rule" "forwarding_http" {
  listener_arn = aws_alb_listener.main_http.arn
  action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
