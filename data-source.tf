# Data sources for existing VPC and Subnet
data "aws_vpc" "existing" {
  id = "vpc-0826bf64357b2c5df"
}

data "aws_subnet" "existing" {
  id = "subnet-06246514a55f3cf12" # 172.31.16.0/20
}

