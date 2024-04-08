# --------------------------------
# ami
# --------------------------------
data "aws_ami" "basion" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }

}

# --------------------------------
# Key Pair
# --------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-basion-keypair"
  public_key = file(var.public_key_path) // read public key from file
  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# Security Group
# --------------------------------
## Basion Server on Public Subnet Security Group
resource "aws_security_group" "basion_public_sg" {
  name        = "${var.project}-${var.environment}-basion_public_sg"
  description = "basion public security group"
  vpc_id      = var.vpc_id

  ingress{
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-basion_public_sg"
    Project = var.project
    Env     = var.environment
  }
}

## Basion Server on Private Subnet Security Group
resource "aws_security_group" "basion_private_sg" {
  name        = "${var.project}-${var.environment}-basion_private_sg"
  description = "basion public security group"
  vpc_id      = var.vpc_id

  ingress{
    protocol          = "tcp"
    from_port         = 22
    to_port           = 22
    security_groups = [ aws_security_group.basion_public_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-basion_private_sg"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# IAM Role
# --------------------------------
resource "aws_iam_role" "basion_server_role" {
  name = "${var.project}-${var.environment}-basion_server_role"
  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    })

  tags = {
    Name    = "${var.project}-${var.environment}-basion_server_role"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_iam_role_policy_attachment" "secrets_manager" {
  role       = aws_iam_role.basion_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "bsion_server_profile" {
  name = "${var.project}-${var.environment}-basion_server_profile"
  role = aws_iam_role.basion_server_role.name
}


# --------------------------------
# EC2 instance
# --------------------------------
## Basion Server on Public Subnet Security Group
resource "aws_instance" "basion_public" {
  // General Configuration
  ami           = data.aws_ami.basion.id
  instance_type = "t2.micro"

  // Network Configuration
  subnet_id = var.subnet_public_ids[0]
  vpc_security_group_ids = [aws_security_group.basion_public_sg.id]
  associate_public_ip_address = true // for public subnet


  // Others
  key_name = aws_key_pair.keypair.key_name

  // Tags
  tags = {
    Name    = "${var.project}-${var.environment}-basion-public"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}

## Basion Server on Public Subnet Security Group
resource "aws_instance" "basion_private" {
  // General Configuration
  ami           = data.aws_ami.basion.id
  instance_type = "t2.micro"

  // Network Configuration
  subnet_id = var.subnet_private_ids[0]
  vpc_security_group_ids = [aws_security_group.basion_private_sg.id]
  associate_public_ip_address = false

  // IAM Role
  iam_instance_profile = aws_iam_instance_profile.bsion_server_profile.name

  // Others
  key_name = aws_key_pair.keypair.key_name

  // Tags
  tags = {
    Name    = "${var.project}-${var.environment}-basion-private"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}