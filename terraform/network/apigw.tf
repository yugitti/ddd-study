# API Gateway REST APIの作成
resource "aws_api_gateway_rest_api" "apigw" {
  name        = "${var.project}-${var.environment}-api-gateway"
  description = "My REST API"
  tags = {
    Name    = "${var.project}-${var.environment}-apigw"
    Project = var.project
    Env     = var.environment
  }
}

####################################
# Dummy Resource
####################################
# ダミーのリソースの作成
resource "aws_api_gateway_resource" "dummy_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "dummy"
}

# ダミーのGETメソッドの作成
resource "aws_api_gateway_method" "dummy_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.dummy_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# ダミーの統合の作成
resource "aws_api_gateway_integration" "dummy_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_resource.dummy_resource.id
  http_method = aws_api_gateway_method.dummy_get_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  # ダミーのHTTPエンドポイント。必要に応じてMock統合を使用することもできます。
  uri  = "http://example.com"
}


####################################
# deployment
####################################
resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = var.environment
  deployment_id = aws_api_gateway_deployment.deploy.id
}



####################################
# API Key
####################################

resource "aws_api_gateway_api_key" "api_key" {
  name        = "${var.project}-${var.environment}-api-key"
  description = "API key for accessing example resources"
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name        = "${var.project}-${var.environment}-api-usage-plan"
  description = "API Usage Plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.apigw.id
    stage  = var.environment
  }

  depends_on = [aws_api_gateway_deployment.deploy]

  quota_settings {
    limit  = 5000
    offset = 2
    period = "MONTH"
  }

  tags = {
    Name    = "${var.project}-${var.environment}-api-usage-plan"
    Project = var.project
    Env     = var.environment
  }

}

resource "aws_api_gateway_usage_plan_key" "api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
  depends_on = [aws_api_gateway_deployment.deploy]

  key_type      = "API_KEY"
}


####################################
# logging
####################################
resource "aws_api_gateway_method_settings" "method_setting" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
  depends_on          = [aws_api_gateway_method_settings.method_setting]
}

