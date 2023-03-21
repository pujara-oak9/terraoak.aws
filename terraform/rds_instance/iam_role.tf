resource "aws_iam_role" "rds_s3_role" {
  name = "rds_s3_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["s3.amazonaws.com","rds.amazonaws.com"]
        }
      }
    ]
  })

  tags = {
    # oak9: Define asset inventory tags
    tag-key = "tag-value"
  }
}

resource "aws_iam_role" "db_proxy_role" {
  name = "rds_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "rds.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    # oak9: Define asset inventory tags
    tag-key = "tag-value"
  }
}
