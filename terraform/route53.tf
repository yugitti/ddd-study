# --------------------------------
# Route53
# --------------------------------
resource "aws_route53_zone" "route53_zone" {
  name          = var.domain
  force_destroy = false
  tags = {
    Name    = "${var.project}-${var.environment}-domain"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------------
# Route53 Record
# --------------------------------
// A record (IP)
# resource "aws_route53_record" "route53_record_A_IP" {
#   zone_id = aws_route53_zone.route53_zone.zone_id
#   name    = "app.${var.domain}"
#   type    = "A"
#   ttl     = "300" // cache minuts
#   records = [aws_instance.app_server.public_ip] // target routing ip
# }

// A record (AWS resource, exp: CloudFront, ALB, etc)
resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = "dev-elb.${var.domain}" // record name
  type    = "A"
  // AWS Resource Unique [ALB case]
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
// CNAME record (IP)
# resource "aws_route53_record" "route53_record_CNAME" {
#   zone_id = aws_route53_zone.route53_zone.zone_id
#   name    = "app.${var.domain}"
#   type    = "CNAME"
#   ttl     = "300" // cache minuts
#   records = [aws_instance.app_server.public_ip] // target routing ip
# }

