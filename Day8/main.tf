provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  description = "This is the ami value for the instance you have to specify"
}
variable "instance_type" {
  description = "This is the instance type "
  type = map(string)

  default = {
      "dev" = "t2.micro",
      "stage" ="t2.medium",
      "prod" = "t2.xlarge"
  }
}
variable "subnet_id" {
  description = "This is the subnet where instance will run"
}
variable "security_group_id" {
  description = "This is the security at instance level"
}
module "ec2_instance"  {
  source           = "./modules/ec2_instance"
  ami              = var.ami
  instance_type    =  lookup(var.instance_type,terraform.workspace,"t2.micro")
  subnet_id        = var.subnet_id
  security_group_id = var.security_group_id
  
}
