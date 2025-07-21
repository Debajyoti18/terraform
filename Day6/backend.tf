terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-bucket2241002156"
    key            = "env/dev/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
  }
}
