resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}
resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr_subnet
}