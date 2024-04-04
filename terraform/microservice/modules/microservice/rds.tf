
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project}-${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_private_ids
}

##########################
## RDS Parameter Group
##########################
resource "aws_rds_cluster_parameter_group" "rds" {
  name        = "${var.project}-${var.environment}-rds-parameter-group"
  family      = "aurora-mysql8.0"
  description = "Custom parameter group for Aurora MySQL 8.0"

  parameter {
    name = "time_zone"
    value = "Asia/Tokyo"
   }

     parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
}


##########################
## RDS Cluster  
##########################

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "${var.project}-${var.environment}-rds-cluster"

  // instance
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  engine_mode = "provisioned" // aurora serverless
  port                    = var.rds_port

  // network & security group
  vpc_security_group_ids  = [var.security_group_rds_ids]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name

  // username, password & database name
  database_name           = var.rds_database_name
  master_username         = var.rds_master_username
  manage_master_user_password = true


  ## backup
  skip_final_snapshot     = true
#   backup_retention_period = 5
#   preferred_backup_window = "07:00-09:00"

## serverless
serverlessv2_scaling_configuration {
  max_capacity = 1.0
  min_capacity = 0.5
}

allow_major_version_upgrade = true

  tags = {
    Name    = "${var.project}-${var.environment}-rds-cluster"
    Project = var.project
    Env     = var.environment
  }
}

##########################
## RDS Cluster Instance 
##########################

resource "aws_rds_cluster_instance" "rds"{

    identifier              = "${var.project}-${var.environment}-rds-instance"
    cluster_identifier      = aws_rds_cluster.rds.id

    // instance
    instance_class          = "db.serverless" // aurora serverless
    engine                  = aws_rds_cluster.rds.engine
    engine_version          = aws_rds_cluster.rds.engine_version

    // network
    db_subnet_group_name    = aws_rds_cluster.rds.db_subnet_group_name
    publicly_accessible     = false

    tags = {
        Name    = "${var.project}-${var.environment}-rds-instance"
        Project = var.project
        Env     = var.environment
    }
}

##########################
## RDS Cluster Endpoint Url ( save to SSM)
##########################

resource "aws_ssm_parameter" "rds_username" {
  name  = "/${var.project}/${var.environment}/rds/USERNAME"
  type  = "String"
  value = aws_rds_cluster.rds.endpoint
}

resource "aws_ssm_parameter" "rds_port" {
  name  = "/${var.project}/${var.environment}/rds/PORT"
  type  = "String"
  value = aws_rds_cluster.rds.port
}

resource "aws_ssm_parameter" "rds_database_name" {
  name  = "/${var.project}/${var.environment}/rds/DATABASE_NAME"
  type  = "String"
  value = aws_rds_cluster.rds.database_name
}
resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "/${var.project}/${var.environment}/rds/ENDPOINT"
  type  = "String"
  value = aws_rds_cluster.rds.endpoint
}