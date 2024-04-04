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
    region = "ap-northeast-1"
    key    = "ddd-study-dev.tfstate"
    bucket = "ddd-study-tfstate-bucket-yugi"
  }
}

# --------------------------------
# Provider Configuration
# --------------------------------
provider "aws" {
  region = "ap-northeast-1"
}

// for cloudfront related resources
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

