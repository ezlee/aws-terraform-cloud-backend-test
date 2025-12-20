variable "aws_access_key_id" {
  type        = string
  description = "AWS access key for authentication"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS secret key for authentication"
  sensitive   = true
}

variable "ip_whitelist" {
  type        = string
  description = "IP addresses for whitelist, format: x.x.x.x/y"
}

variable "iam_group_name" {
  type        = string
  description = "Name of the IAM group"
}