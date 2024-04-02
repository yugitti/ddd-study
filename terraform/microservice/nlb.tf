resource "aws_lb" "nlb" {
  name                       = "${var.project}-${var.environment}-nlb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = local.subnet_private_ids
  enable_deletion_protection = false
  tags = {
    Name    = "${var.project}-${var.environment}-nlb"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_target_group" "nlb_target_group" {
  name        = "${var.project}-${var.environment}-nlb-tg"
  target_type = "ip"
  port        = var.container_port
  protocol    = "TCP"
  vpc_id      = local.vpc_id
  tags = {
    Name    = "${var.project}-${var.environment}-nlb-tg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.container_port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
  }

}