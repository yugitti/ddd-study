
# --------------------------------
# IAM Role
# --------------------------------

resource "aws_iam_role" "ecs_task" {
  name = "${var.project}-${var.environment}-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-${var.environment}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name = "${var.project}-${var.environment}-api_gw_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}



# --------------------------------
# IAM Instance Profile
# --------------------------------
resource "aws_iam_instance_profile" "ecs_task_profile" {
  name = aws_iam_role.ecs_task.name
  role = aws_iam_role.ecs_task.name
}

resource "aws_iam_instance_profile" "ecs_task_execution_profile" {
  name = aws_iam_role.ecs_task_execution_role.name
  role = aws_iam_role.ecs_task_execution_role.name
}

# --------------------------------
# IAM Role Policy 
# --------------------------------

resource "aws_iam_role_policy" "api_gw_cloudwatch_policy" {
  name = "${var.project}-${var.environment}-api_gw_cloudwatch_policy"
  role = aws_iam_role.api_gw_cloudwatch_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
        ]
        Resource = "*"
        Effect   = "Allow"
      },
    ]
  })
}


# --------------------------------
# IAM Role Policy Attachment
# --------------------------------

// For ECS role
// To access DynamoDB from ECS
resource "aws_iam_role_policy_attachment" "ecs_dynamodb" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

// To access RDS from ECS
resource "aws_iam_role_policy_attachment" "ecs_rds" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

// For ECS Execution
// Task Execution Basic Role
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// To access ECR from ECS
resource "aws_iam_role_policy_attachment" "ecs_execution_ecr" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

// To access Secrets Manager from ECS 
resource "aws_iam_role_policy_attachment" "ecs_execution_secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

