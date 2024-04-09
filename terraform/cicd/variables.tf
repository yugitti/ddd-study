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

variable "tfstate_bucket" {
  description = "The name of the S3 bucket to store the tfstate file"
  type        = string
}

variable "tfstate_microservice_key" {
  description = "The path to the tfstate file for microservice"
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

