resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${var.project}-${var.environment}-ecs-task"

  requires_compatibilities = ["FARGATE"]

  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${aws_ecr_repository.ecr.repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.cloudwatch_log_prefix
        }
      }
    }
  ])

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-task"
    Project = var.project
    Env     = var.environment
  }
}