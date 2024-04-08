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

variable "tfstate_bucket" {
  description = "The name of the S3 bucket to store the tfstate file"
  type        = string
}

variable "tfstate_key" {
  description = "The path to the tfstate file"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key used to access the bastion server"
  type        = string
}
