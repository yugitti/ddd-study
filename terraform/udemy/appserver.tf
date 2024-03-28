
# --------------------------------
# Key Pair
# --------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-keypair.pub") // read public key from file
  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# EC2 instance
# --------------------------------
# resource "aws_instance" "app_server" {
#   // General Configuration
#   ami           = data.aws_ami.app.id
#   instance_type = "t2.micro"

#   // Network Configuration
#   subnet_id = aws_subnet.public_subnet_1a.id
#   vpc_security_group_ids = [
#     aws_security_group.app_sg.id,
#     aws_security_group.ops_sg.id
#   ]
#   associate_public_ip_address = true // for public subnet

#   // IAM Role
#   iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name

#   // Others
#   key_name = aws_key_pair.keypair.key_name

#   // Tags
#   tags = {
#     Name    = "${var.project}-${var.environment}-app"
#     Project = var.project
#     Env     = var.environment
#     Type    = "app"
#   }
# }

# --------------------------------
# Parameter Store
# --------------------------------
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}

resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}

resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.db_name
}

resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type  = "String"
  value = aws_db_instance.mysql_standalone.username
}

resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type  = "String"
  value = aws_db_instance.mysql_standalone.password
}

# --------------------------------
# Launch Template
# --------------------------------
resource "aws_launch_template" "app_lt" {
  update_default_version = true
  name                   = "${var.project}-${var.environment}-app-lt"
  image_id               = data.aws_ami.app.id
  key_name               = aws_key_pair.keypair.key_name

  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }

  // need to use subnet_id instead of subnet_name if laouch instance in VPC
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.ops_sg.id
  ]

  // error occurred when using subnet_name
  # security_group_names = [
  #   aws_security_group.app_sg.name,
  #   aws_security_group.ops_sg.name
  # ]
  user_data = filebase64("./resource/initialize.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project}-${var.environment}-app-lt"
      Project = var.project
      Env     = var.environment
      Type    = "app"
    }
  }
}