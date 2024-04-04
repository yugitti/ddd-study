# --------------------------------
# Provider Configuration
# --------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
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

variable "docker_dir" {
  description = "The directory containing the Dockerfile"
  type        = string
}

variable "tfstate_bucket" {
  description = "The name of the S3 bucket to store the tfstate file"
  type        = string
}

variable "tfstate_key" {
  description = "The path to the tfstate file"
  type        = string
}
## AUTO SCALING
variable "min_capacity" {
  description = "The minimum number of tasks to run"
  type        = number
  default     = 1
}
variable "max_capacity" {
  description = "The maximum number of tasks to run"
  type        = number
  default     = 1
}



## ECS Service Variables

variable "ecs_desired_task_count" {
  description = "The number of tasks to run"
  type        = number
  default     = 1
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = "ddd-study"
}

## ECS Task Definition Variables

variable "container_port" {
  description = "The port the container listens on"
  type        = number
  default     = 8080
}

variable "image_tag" {
  description = "The tag of the image to deploy"
  type        = string
  default     = "latest"
}

variable "cloudwatch_log_prefix" {
  description = "The prefix for the cloudwatch log stream"
  type        = string
  default     = "ecs"
}

variable "rds_database_name" {
  description = "The name of the RDS database"
  type        = string
}

variable "rds_master_username" {
  description = "The master username for the RDS database"
  type        = string
}

variable "rds_port" {
  description = "The port the RDS database listens on"
  type        = number
  default     = 3306
}

variable "rds_engine" {
  description = "The engine of the RDS database"
  type        = string
  default     = "aurora"
}

variable "rds_engine_version" {
  description = "The engine version of the RDS database"
  type        = string
  default     = "8.0.mysql_aurora.3.01.0"
}



