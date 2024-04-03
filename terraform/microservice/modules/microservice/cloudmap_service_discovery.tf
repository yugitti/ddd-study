
resource "aws_service_discovery_service" "ecs_service_discovery" {
  name = "${var.project}-${var.environment}-ecs-service-discovery"

  #   namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id

  dns_config {
    # namespace_id = var.dns_namespace_id
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-service-discovery"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_service_discovery_private_dns_namespace" "private_dns_namespace" {
  name        = "${var.project}-${var.environment}-private-dns-namespace"
  vpc         = var.vpc_id
  description = "Private DNS namespace for ${var.project}-${var.environment} ECS service discovery"
  tags = {
    Name    = "${var.project}-${var.environment}-private-dns-namespace"
    Project = var.project
    Env     = var.environment
  }
}