# --------------------------------
# CloudFront cache distribution
# --------------------------------
resource "aws_cloudfront_distribution" "cn" {

  // Basic settings
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All" // default

  // Origin settings
  origin {
    domain_name = aws_route53_record.route53_record.fqdn
    origin_id   = aws_lb.alb.name // unique id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  // origin for S3 static bucket
  origin {
    domain_name = aws_s3_bucket.s3_static_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3_static_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_s3_origin_access_identity.cloudfront_access_identity_path
    }
  }

  // Befavior
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }

    }
    target_origin_id       = aws_lb.alb.name // should be match to origin_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0 // no cache
    default_ttl            = 0 // no cache
    max_ttl                = 0 // no cache
  }

  ordered_cache_behavior {
    path_pattern           = "/public/"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.s3_static_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = aws_cloudfront_cache_policy.s3_static_cache_policy.id
  }

  // Geo Restriction
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // Aliases settings, this should be match to Route53 record
  aliases = ["dev.${var.domain}"]

  // SSL settings
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.virginia_cert.arn // acm must put on virginia region
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_cache_policy" "s3_static_cache_policy" {
  name = "s3_cache_policy"

  comment     = "S3 static bucket cache policy"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    query_strings_config {
      query_string_behavior = "none"
    }
    cookies_config {
      cookie_behavior = "none"
    }
    enable_accept_encoding_gzip = true
    headers_config {
      header_behavior = "none"
    }
  }
}


// S3 Origin Identity
resource "aws_cloudfront_origin_access_identity" "cf_s3_origin_access_identity" {
  comment = "S3 static buckets access identity"
}



// Route53 record for CloudFront
resource "aws_route53_record" "route53_cloudfront" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "dev.${var.domain}" // shoudl match cloudfront distribution alias
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cn.domain_name
    zone_id                = aws_cloudfront_distribution.cn.hosted_zone_id
    evaluate_target_health = true
  }

}
