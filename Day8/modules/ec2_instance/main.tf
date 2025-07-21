provider "aws" {
  region = "us-east-1"
}
variable "ami" {
  description = "This is the ami value for the instance"
}
variable "instance_type" {
  description = "This is the instance type "
}
variable "subnet_id" {
  description = "This is the subnet where instance will run"
}
variable "security_group_id" {
  description = "This is the security at instance level"
}
resource "aws_instance" "my" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = [ var.security_group_id ]


  
}