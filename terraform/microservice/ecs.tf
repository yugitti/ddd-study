resource "aws_ecs_service" "ecs" {
  name             = "${var.project}-${var.environment}-ecs"
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  cluster          = aws_ecs_cluster.ecs_cluster.arn
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  depends_on       = [aws_ecs_task_definition.ecs_task_definition]

  desired_count                      = var.ecs_desired_task_count
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  enable_execute_command = true

  force_new_deployment = true

  network_configuration {
    subnets          = local.subnet_private_ids
    security_groups  = [local.security_group_ecs_ids]
    assign_public_ip = false

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  ## NLB, not created yet  
  # load_balancer {
  #     target_group_arn = aws_lb_target_group.alb_target_nlb.group.arn
  #     container_name = var.container_name
  #     container_port = var.container_port
  # }

  lifecycle {
    ignore_changes = [desired_count]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ecs_service_discovery.arn

  }

  tags = {
    Name    = "${var.project}-${var.environment}-ecs"
    Project = var.project
    Env     = var.environment
  }



}