resource "aws_api_gateway_vpc_link" "apigw_vpc_link" {
  name        = "${var.project}-${var.environment}-apigw-vpc-link"
  target_arns = [aws_lb.nlb.arn]
  tags = {
    Name    = "${var.project}-${var.environment}-apigw-vpc-link"
    Project = var.project
    Env     = var.environment
  }
}