##########################
## create RDS instance ##
##########################

resource "aws_db_instance" "rds" {
  identifier = "${var.name}-rds"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "${var.name}-rds"
  username = "${var.db_username}"
  password = "${var.db_password}"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = false
  skip_final_snapshot = true
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.rds.name}"
  tags {
    Name = "${var.name}-rds"
  }
}

resource "aws_security_group" "rds" {
  name = "${var.name}-rds"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [""]
    }
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["
    "]
    }
}

resource "aws_db_subnet_group" "rds" {
  name = "${var.name}-rds"
  subnet_ids = ["${var.subnet_ids}"]
  tags {
    Name = "${var.name}-rds"
  }
}

resource "null_resource" "rds" {
  triggers = {
    rds_id = aws_db_instance.rds.id
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/create_db.sh"

    environment = {
      DB_HOST = aws_db_instance.rds.address
      DB_PORT = aws_db_instance.rds.port
      DB_NAME = var.db_name
      DB_USERNAME = var.db_username
      DB_PASSWORD = var.db_password
    }
  }

  depends_on = [aws_db_instance.rds]
}
