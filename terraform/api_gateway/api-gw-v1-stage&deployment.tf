resource "aws_api_gateway_deployment" "foo" {
  # All options # Must be configured
  rest_api_id       = aws_api_gateway_rest_api.foo.id
  description       = "Foo api-gw deployment"
  stage_description = "Foo api-gw deployment stage"

  # Conflicts with resource type stage
  # stage_name = "Foo"
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.foo.id,
      aws_api_gateway_method.foo.id,
      aws_api_gateway_integration.foo.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  variables = {
    "version" = "02"
  }

  depends_on = [
    aws_api_gateway_integration.foo,
    aws_api_gateway_integration_response.foo,
    aws_api_gateway_method_response.foo,
    aws_api_gateway_integration.foo
  ]
}

resource "aws_api_gateway_stage" "foo" {
  # All options # Must be configured
  deployment_id         = aws_api_gateway_deployment.foo.id
  description           = "Deployment stage for foos testing"
  rest_api_id           = aws_api_gateway_rest_api.foo.id
  stage_name            = "foo"
  cache_cluster_enabled = true
  cache_cluster_size    = 237
  xray_tracing_enabled  = false
  client_certificate_id = aws_api_gateway_client_certificate.foo.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.foo_apigw.arn
    format          = <<EOF
  { 
  "requestId":"$context.requestId", \
  "ip": "$context.identity.sourceIp", \
  "caller":"$context.identity.caller", \
  "user":"$context.identity.user", \
  "requestTime":"$context.requestTime", \
  "httpMethod":"$context.httpMethod", \
  "resourcePath":"$context.resourcePath", \
  "status":"$context.status", \
  "protocol":"$context.protocol", \
  "responseLength":"$context.responseLength" \
}
EOF
  }
  variables = {
    "version" = "02"
  }

  tags = {
    # oak9: aws_api_gateway_stage.tags is not configured
    Environment = "production"
    Application = "foo"
  }

  depends_on = [
    aws_api_gateway_account.foo_apigw_cw
  ]
}

resource "aws_api_gateway_model" "foo" {
  rest_api_id  = aws_api_gateway_rest_api.foo.id
  name         = "foo"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "type": "object"
}
EOF
}
