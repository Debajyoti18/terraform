variable "cidr" {
  description = "This is the cidr block for vpc"
   type = string
}
variable "cidr_subnet" {
  description = "This is the cidr for subnet you want to make"
  type = string
}

module "vpc" {
  source = "./vpc"
  cidr = "10.0.0.0/16"
  cidr_subnet = "10.0.1.0/24"

}