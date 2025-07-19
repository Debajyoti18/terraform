provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "deba" {
  ami = "ami-01637463b2cbe7cb6"
   instance_type = "t3.micro"
  subnet_id= "subnet-0125c6a3c582fe478"
}
resource "aws_s3_bucket" "dj" {
  bucket = "dj-123-b-2241002156"
}