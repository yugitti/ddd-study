variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "subnet_public_ids" {
 type        = list(string)
 description = "subnet public ids"
}

variable "subnet_private_ids" {
 type        = list(string)
 description = "subnet private ids"
}

variable "security_group_ecs_ids" {
 type        = string
 description = "security group ecs id"
}

variable "ecs_task_role_arn" {
  type = string
    description = "ecs task role arn"
}

variable "ecs_task_execution_role_arn" {
  type = string
    default = "ecs task execution role arn"
}

variable "remote_rest_api_id" {
  type = string
    description = "remote rest api id"
}

variable "remote_parent_id" {
  type = string
    description = "remote parent id"
}

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

