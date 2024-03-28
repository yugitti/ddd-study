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
resource "aws_s3_bucket" "s3_static_bucket" {
  bucket = "${var.project}-${var.environment}-static-bucket-${random_string.s3_unique_key.result}"
}

// S3 Access Block Control
resource "aws_s3_bucket_public_access_block" "s3_static_bucket" {
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false // need to be false to apply bucket policy
  restrict_public_buckets = false // need to be false to apply bucket policy (changed default value to true from 2023/4)
}

// S3 Bucket Policy
resource "aws_s3_bucket_policy" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.s3_static_bucket.json
  // deploy after S3 bucket Access Block Control
  depends_on = [aws_s3_bucket_public_access_block.s3_static_bucket]
}

// policy document for S3 bucket
data "aws_iam_policy_document" "s3_static_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_static_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = [aws_cloudfront_origin_access_identity.cf_s3_origin_access_identity.iam_arn]
    }
  }
}

# --------------------------------
# S3  bucket for private access to save source code
# --------------------------------
// S3 Bucket
resource "aws_s3_bucket" "s3_deploy_bucket" {
  bucket = "${var.project}-${var.environment}-deploy-bucket-${random_string.s3_unique_key.result}"
}

// S3 Access Block Control
resource "aws_s3_bucket_public_access_block" "s3_private_bucket" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 Bucket Policy
resource "aws_s3_bucket_policy" "s3_private_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  policy = data.aws_iam_policy_document.s3_private_bucket.json
  // deploy after S3 bucket Access Block Control
  depends_on = [aws_s3_bucket_public_access_block.s3_private_bucket]
}

// policy document for S3 bucket
data "aws_iam_policy_document" "s3_private_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_deploy_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.app_iam_role.arn]
    }
  }
}