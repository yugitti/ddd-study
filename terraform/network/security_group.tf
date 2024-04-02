# --------------------------------
# Security Group
# --------------------------------

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-${var.environment}-ecs_sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-ecs-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group" "private_app_vpc_endpoint" {
  name        = "${var.project}-${var.environment}-private_app_vpc_endpoint_sg"
  description = "private app vpc endpoint security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project}-${var.environment}-private_app_vpc_endpoint_sg"
    Project = var.project
    Env     = var.environment
  }
}


# web security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-alb_sg"
  description = "alb role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-alb-sg"
    Project = var.project
    Env     = var.environment
  }
}

# resource "aws_security_group_rule" "web_in_http" {
#   security_group_id = aws_security_group.web_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "web_in_https" {
#   security_group_id = aws_security_group.web_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = "443"
#   to_port           = "443"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "web_out_tcp3000" {
#   security_group_id        = aws_security_group.web_sg.id
#   type                     = "egress"
#   protocol                 = "tcp"
#   from_port                = 3000
#   to_port                  = 3000
#   source_security_group_id = aws_security_group.app_sg.id
# }

# # application security group
# resource "aws_security_group" "app_sg" {
#   name        = "${var.project}-${var.environment}-app_sg"
#   description = "application role security group"
#   vpc_id      = aws_vpc.vpc.id

#   tags = {
#     Name    = "${var.project}-${var.environment}-app-sg"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# resource "aws_security_group_rule" "app_in_tcp3000" {
#   security_group_id        = aws_security_group.app_sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = "3000"
#   to_port                  = "3000"
#   source_security_group_id = aws_security_group.web_sg.id
# }

# resource "aws_security_group_rule" "app_out_tcp3306" {
#   security_group_id        = aws_security_group.app_sg.id
#   type                     = "egress"
#   protocol                 = "tcp"
#   from_port                = "3306"
#   to_port                  = "3306"
#   source_security_group_id = aws_security_group.db_sg.id
# }

# resource "aws_security_group_rule" "app_out_http" {
#   security_group_id = aws_security_group.app_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = "80"
#   to_port           = "80"
#   prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
# }

# resource "aws_security_group_rule" "app_out_https" {
#   security_group_id = aws_security_group.app_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = "443"
#   to_port           = "443"
#   prefix_list_ids   = [data.aws_prefix_list.s3_pl.id]
# }


# # operation security group
# resource "aws_security_group" "ops_sg" {
#   name        = "${var.project}-${var.environment}-ops_sg"
#   description = "operation role security group"
#   vpc_id      = aws_vpc.vpc.id

#   tags = {
#     Name    = "${var.project}-${var.environment}-ops-sg"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# resource "aws_security_group_rule" "ops_in_ssh22" {
#   security_group_id = aws_security_group.ops_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 22
#   to_port           = 22
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "ops_in_tcp3000" {
#   security_group_id = aws_security_group.ops_sg.id
#   type              = "ingress"
#   protocol          = "tcp"
#   from_port         = 3000
#   to_port           = 3000
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "ops_out_http" {
#   security_group_id = aws_security_group.ops_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "ops_out_https" {
#   security_group_id = aws_security_group.ops_sg.id
#   type              = "egress"
#   protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# # database security group
# resource "aws_security_group" "db_sg" {
#   name        = "${var.project}-${var.environment}-db_sg"
#   description = "database role security group"
#   vpc_id      = aws_vpc.vpc.id

#   tags = {
#     Name    = "${var.project}-${var.environment}-db-sg"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# resource "aws_security_group_rule" "ops_in_tcp3306" {
#   security_group_id        = aws_security_group.db_sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 3306
#   to_port                  = 3306
#   source_security_group_id = aws_security_group.app_sg.id
# }
