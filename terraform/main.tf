# --------------------------------
# Terraform Configuration
# --------------------------------
terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  // save tfstate file to s3 to share with team
  backend "s3" {
    region  = "ap-northeast-1"
    key     = "tastylog-dev.tfstate"
    profile = "tsukiyodev"
    bucket  = "tastlylog-tfstate-bucket-yugi"
  }
}

# --------------------------------
# Provider Configuration
# --------------------------------
provider "aws" {
  profile = "tsukiyodev"
  region  = "ap-northeast-1"
}

// for cloudfront related resources
provider "aws" {
  alias   = "virginia"
  profile = "tsukiyodev"
  region  = "us-east-1"
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