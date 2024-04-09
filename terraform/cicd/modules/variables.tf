# --------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  description = "The region the resources are created in"
  type        = string
  default     = "ap-northeast-1"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "source_code_repository_name" {
  description = "The name of the source code repository"
  type        = string
}

variable "source_code_branch" {
  description = "The branch of the source code repository"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of ECR repository"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of ECS service"
  type        = string
}