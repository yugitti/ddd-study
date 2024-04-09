
resource "aws_codebuild_project" "codebuild" {
  name         = "${var.project}-${var.environment}-codebuild"
  description  = "CodeBuild project for ${var.project}-${var.environment}"
  service_role = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }
    environment_variable {
      name  = "REPO_NAME"
      value = var.ecr_repo_name
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  tags = {
    Name    = "${var.project}-${var.environment}-codebuild"
    Project = var.project
    Env     = var.environment
  }
}