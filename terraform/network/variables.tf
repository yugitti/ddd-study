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

# variable "public_subnet_cidrs" {
#   type        = map(string)
#   description = <<-EOT
#     key: Availability Zone, value: subnet cidr
#     (e.g.
#     {
#       "ap-northeast-1a" = "10.120.0.0/21
#       "ap-northeast-1b" = "10.120.8.0/21
#       "ap-northeast-1c" = "10.120.16.0/21
#     )
#   EOT
# }