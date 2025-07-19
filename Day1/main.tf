provider "aws" {
  region = "eu-north-1"
}
module "EC2" {
    source = "./module/EC2"
   ami_value = "ami-01637463b2cbe7cb6"
   instance_type_value = "t3.micro"
  subnet_id_value = "subnet-0125c6a3c582fe478"
}