resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "${var.project}-${var.environment}-ecs-log-group"
  retention_in_days = 30
  tags = {
    Name    = "${var.project}-${var.environment}-ecs-log-group"
    Project = var.project
    Env     = var.environment
  }
}