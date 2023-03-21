resource "aws_s3_bucket_policy" "foo" {
  bucket = aws_s3_bucket.foo.id

  # Terraform's "jsonencode" function converts a Terraform expression's result to valid JSON syntax.
  policy = <<POLICY
  # oak9: Explicitly define S3 bucket actions instead of using wildcards ['*', 's3:*']
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}