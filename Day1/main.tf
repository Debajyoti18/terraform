

variable "instance_type_value" {
  description = "Instance  type "
}
variable "ami_value" {
  description = "ami id of the instance"
}
variable "subnet_id_value" {
  description = "What subnet instance would be lunch "
}

provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "my-instance" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  subnet_id = var.subnet_id_value
}