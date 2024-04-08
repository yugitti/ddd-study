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

variable "public_key_path" {
  type        = string
  description = "The name of the EC2 Key Pair to allow SSH access to the instances"
}