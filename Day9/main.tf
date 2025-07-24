provider "aws" {
  region = "eu-north-1"
}

module "my_bucket" {
  source      = "./s3_module"
  bucket_name = "my-example-bucket-2241002156"

  tags = {
    Environment = "dev"
    Project     = "example"
  }

  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
  AWS = "arn:aws:iam::976193223501:user/debajyoti-dj"
}

        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${module.my_bucket.bucket_name}/*"
      }
    ]
  })
}
