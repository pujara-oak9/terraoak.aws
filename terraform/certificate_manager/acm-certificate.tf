resource "aws_acm_certificate" "foo" { 
  domain_name               = ""
  subject_alternative_names = ["www.foo.com"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = "foo.com"
    }, {
      Environment = "test"
    }
  )

  options {
    certificate_transparency_logging_preference = "DISABLED"
  }
}


resource "aws_acm_certificate_validation" "default" {
   # oak9: aws_acm_certificate.tags is not configured
   
  certificate_arn=aws_acm_certificate.foo.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

