resource "aws_s3_bucket_policy" "foo" {
  bucket = aws_s3_bucket.foo.id

  # Terraform's "jsonencode" function converts a Terraform expression's result to valid JSON syntax.
  policy = <<POLICY
  # oak9: S3 bucket policy grants broad access to resources using * (wildcards)
  # oak9: S3 bucket policy allows any action using s3:* (wildcards)
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