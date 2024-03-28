# --------------------------------
# RDS parameter Group
# --------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

}

# --------------------------------
# RDS option Group
# --------------------------------
resource "aws_db_option_group" "mysql_standalone_optionrgroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optionrgroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# --------------------------------
# RDS subnet Group
# --------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name       = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# RDS instance
# --------------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {

  // General Configuration
  engine         = "mysql"
  engine_version = "8.0"
  identifier     = "${var.project}-${var.environment}-mysql-stanalone" // db instance name, different from db name

  // Credentials
  username = "admin"
  password = random_string.db_password.result

  // Instance Configuration
  instance_class        = "db.t2.micro"
  allocated_storage     = 20 // GB
  max_allocated_storage = 50 // GB
  # storayge_type = "gp2" // General Purpose SSD, default
  storage_encrypted = false // default

  // Network Configuration
  multi_az               = false // default
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false //default, set to true if you want to access from outside of VPC
  port                   = 3306

  // Database Configuration
  db_name              = "tastylog" // db name
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optionrgroup.name

  // Backup Maintenance
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7                     // how many days to keep backups
  maintenance_window         = "Mon:05:00-Mon:08:00" // When to appply maintenance updates, shuld be later than backup window
  auto_minor_version_upgrade = false                 // default

  // Delete Protection
  //// Protected
  deletion_protection = true  // protect from accidental deletion
  skip_final_snapshot = false // skip final snapshot when deleting
  apply_immediately   = true  // apply changes immediately

  // If you want to delete the instance, you need to set deletion_protection to false and skip_final_snapshot to true
  #   deletion_protection = false
  #   skip_final_snapshot = true
  #   apply_immediately   = true

  // Tags
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
