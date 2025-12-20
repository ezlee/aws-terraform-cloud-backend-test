# Data sources for existing VPC and Subnet
data "aws_vpc" "existing" {
  id = "vpc-0826bf64357b2c5df"
}

data "aws_subnet" "existing" {
  id = "subnet-06246514a55f3cf12" # 172.31.16.0/20
}

# Reference the existing Linux-Admin IAM group
data "aws_iam_group" "linux_admin_group" {
  group_name = "Linux-Admin" # Ensure this matches the name of your group
}