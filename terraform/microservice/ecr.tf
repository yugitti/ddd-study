resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project}-${var.environment}-ecr"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {

    scan_on_push = true
  }
  tags = {
    Name    = "${var.project}-${var.environment}-ecr"
    Project = var.project
    Env     = var.environment
  }
}

resource "null_resource" "default" {
  triggers = {
    ecr_id = aws_ecr_repository.ecr.id
  }

  provisioner "local-exec" {
    command = "sh ${path.root}/build_push.sh"

    environment = {
      AWS_REGION     = var.region
      AWS_ACCOUNT_ID = var.account_id
      REPO_URL       = aws_ecr_repository.ecr.repository_url
      CONTAINER_NAME = "${var.container_name}"
      DOCKER_DIR     = "${var.docker_dir}"
    }
  }

  depends_on = [aws_ecr_repository.ecr]

}