# RDS Information
output "rds_host" {
  value = aws_rds_cluster.rds.endpoint
}

output "rds_port" {
  value = aws_rds_cluster.rds.port
}

output "rds_db_name" {
  value = aws_rds_cluster.rds.database_name
}

output "rds_secrets_arn" {
  value = aws_rds_cluster.rds.master_user_secret[0].secret_arn
}

output "ecr_repo_name"{
  value = aws_ecr_repository.ecr.name
}

output "ecs_cluster_name"{
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name"{
  value = aws_ecs_service.ecs.name
}