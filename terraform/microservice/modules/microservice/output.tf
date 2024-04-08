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
