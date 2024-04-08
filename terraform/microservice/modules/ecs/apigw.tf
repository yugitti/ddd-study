
####################################
# path: user
# method: GET
####################################

resource "aws_api_gateway_resource" "user" {
  rest_api_id = var.remote_rest_api_id
  parent_id   = var.remote_parent_id
      depends_on = [ aws_api_gateway_vpc_link.apigw_vpc_link ]

  path_part   = "user"
}

####################################
# path: user/{id}
# method: GET
####################################

resource "aws_api_gateway_resource" "user_id" {
  rest_api_id = var.remote_rest_api_id
  parent_id   = aws_api_gateway_resource.user.id
  path_part   = "{id}"
  depends_on = [ aws_api_gateway_vpc_link.apigw_vpc_link ]
}

resource "aws_api_gateway_method" "user_id_get" {
  rest_api_id      = var.remote_rest_api_id
  resource_id      = aws_api_gateway_resource.user_id.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
  depends_on = [ aws_api_gateway_vpc_link.apigw_vpc_link ]

  request_parameters = {
    "method.request.header.x-api-key" = true
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method_response" "user_id_get_res_200" {
  rest_api_id = var.remote_rest_api_id
  resource_id = aws_api_gateway_resource.user_id.id
  http_method = aws_api_gateway_method.user_id_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "user_id_integration" {
  rest_api_id             = var.remote_rest_api_id
  resource_id             = aws_api_gateway_resource.user_id.id
  http_method             = aws_api_gateway_method.user_id_get.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  uri                     = "http://${aws_lb.nlb.dns_name}/user/{id}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.apigw_vpc_link.id

  

  request_parameters = {
    "integration.request.header.x-api-key" = "method.request.header.x-api-key"
    "integration.request.path.id" = "method.request.path.id"
  }

}


####################################
# path: user/create
# method: PUT
####################################

resource "aws_api_gateway_resource" "user_create" {
  rest_api_id = var.remote_rest_api_id
  parent_id   = aws_api_gateway_resource.user.id
  path_part   = "create"
  depends_on = [ aws_api_gateway_vpc_link.apigw_vpc_link ]
}

resource "aws_api_gateway_method" "user_create_put" {
  rest_api_id      = var.remote_rest_api_id
  resource_id      = aws_api_gateway_resource.user_create.id
  http_method      = "PUT"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.header.x-api-key" = true
  }
}

resource "aws_api_gateway_method_response" "user_create_put_res_200" {
  rest_api_id = var.remote_rest_api_id
  resource_id = aws_api_gateway_resource.user_create.id
  http_method = aws_api_gateway_method.user_create_put.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "user_create_integration" {
  rest_api_id             = var.remote_rest_api_id
  resource_id             = aws_api_gateway_resource.user_create.id
  http_method             = aws_api_gateway_method.user_create_put.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "PUT"
  uri                     = "http://${aws_lb.nlb.dns_name}/user/create"
  passthrough_behavior    = "WHEN_NO_MATCH"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.apigw_vpc_link.id
    depends_on = [ aws_api_gateway_vpc_link.apigw_vpc_link ]


  request_parameters = {
    "integration.request.header.x-api-key" = "method.request.header.x-api-key"
  }

}



