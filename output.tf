# Outputs
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.linux.id
}

output "ec2_instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.linux.arn
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.linux.public_ip
}

output "ec2_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.linux.private_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.linux.public_dns
}

output "ec2_instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.linux.private_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.ec2_sg.arn
}

output "key_pair_id" {
  description = "ID of the key pair"
  value       = aws_key_pair.ec2_key_pair.key_pair_id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "secrets_manager_secret_id" {
  description = "ID of the Secrets Manager secret containing the private key"
  value       = aws_secretsmanager_secret.ec2_private_key.id
}

output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the private key"
  value       = aws_secretsmanager_secret.ec2_private_key.arn
}

output "secrets_manager_secret_name" {
  description = "Name of the Secrets Manager secret containing the private key"
  value       = aws_secretsmanager_secret.ec2_private_key.name
}

output "kms_key_id" {
  description = "ID of the KMS key used for EC2 and Secrets Manager encryption"
  value       = aws_kms_key.ec2_key.id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for EC2 and Secrets Manager encryption"
  value       = aws_kms_key.ec2_key.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key used for EC2 and Secrets Manager encryption"
  value       = aws_kms_alias.ec2_key.name
}

# Outputs
output "bucket_name" {
  value       = aws_s3_bucket.example.bucket
  description = "The name of the S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.example.arn
  description = "The ARN of the S3 bucket."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.example.bucket_domain_name
  description = "The domain name of the S3 bucket."
}

output "regional_bucket_domain_name" {
  value       = aws_s3_bucket.example.bucket_regional_domain_name
  description = "The regional domain name of the bucket."
}

output "bucket_host_name" {
  value       = aws_s3_bucket.example.hosted_zone_id
  description = "The host name of the S3 bucket."
}
