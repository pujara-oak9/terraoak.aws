resource "aws_lb" "application" {
  name_prefix        = "foo"
  internal           = false
  load_balancer_type = ""
  subnet_mapping {
    subnet_id = ""
  }

  subnets            = [""]
  security_groups    = [""]
  idle_timeout       = 60
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  ip_address_type                  = "ipv4"
  drop_invalid_header_fields       = true

  access_logs {
    bucket = aws_s3_bucket.foo_lb_logs.bucket
    prefix = "foo-lb"
    enabled = true
  }

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "redirect" {
  # oak9: aws_lb_listener.default_action.authenticate_cognito.on_unauthenticated_request is not configured
  # oak9: aws_lb_listener.default_action.authenticate_oidc.client_id is not configured
  # oak9: aws_lb_listener.default_action.authenticate_cognito.user_pool_client_id is not configured
  # oak9: elastic_load_balancing_v2.listener[0].certificates is not configured
  # oak9: aws_lb_listener.default_action.authenticate_cognito.authentication_request_extra_params is not configured
  # oak9: aws_lb_listener.alpn_policy is not configured
  load_balancer_arn = aws_lb.application.arn
  
  port              = "80"
  protocol          = "HTTP"
  ssl_policy = ""

  default_action {
    type = "redirect"

    redirect {
      status_code = "HTTP_301"
      port = "80"
      protocol = "HTTPS"
    }

    authenticate_cognito {
      user_pool_arn = ""
    }
  }
}

resource "aws_lb_listener_rule" "redirect-rule" {
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.user_info_endpoint is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.token_endpoint is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.issuer is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.client_secret is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.client_id is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_oidc.authorization_endpoint is not configured
  # oak9: aws_lb_listener_rule.action.authenticate_cognito.user_pool_domain is not configured
  # oak9: aws_lb_listener_rule.action.target_group_arn is not configured
  listener_arn = aws_lb_listener.application.arn

  action {
    type  = "redirect"
    order = 1
    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = "34" 
      protocol    = "HTTPS" # Must be configured
      status_code = "HTTP_301"
      query       = "#{query}"
    }
  }
}