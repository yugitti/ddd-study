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
      environment = [
        {
          name  = "RDS_SECRET_ARN"
          value = aws_rds_cluster.rds.master_user_secret[0].secret_arn
        },
        {
          name  = "DB_URL"
          value = aws_rds_cluster.rds.endpoint
        },
                {
          name  = "DB_PORT"
          value = tostring(aws_rds_cluster.rds.port)
        },
                {
          name  = "DB_TABLE"
          value = aws_rds_cluster.rds.database_name
        }
      ],
      secrets = [
        {
          name      = "DB_USER"
          valueFrom = "${aws_rds_cluster.rds.master_user_secret[0].secret_arn}:username::"
        },
        {
          name      = "DB_PASS"
          valueFrom = "${aws_rds_cluster.rds.master_user_secret[0].secret_arn}:password::"
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