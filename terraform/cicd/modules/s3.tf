# --------------------------------
# S3 static bucket for public access
# --------------------------------
resource "random_string" "s3_unique_key" {
  length  = 6
  special = false
  upper   = false
  lower   = true
}


// S3 Bucket
resource "aws_s3_bucket" "s3_codepipeline_bucket" {
  bucket = "${var.project}-${var.environment}-codepipeline-bucket-${random_string.s3_unique_key.result}"
}
