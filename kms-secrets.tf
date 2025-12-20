# Generate SSH key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair

resource "random_string" "secret_suffix" {
  length  = 6
  special = false # If valid, add only alphanumeric characters
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-linux-key-pair-${random_string.secret_suffix.result}"
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "EC2 Linux Key Pair"
  }
}

# KMS Key for EC2 and Secrets Manager encryption
resource "aws_kms_key" "ec2_key" {
  description             = "KMS key for EC2 instance and Secrets Manager encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name = "EC2 and Secrets Manager KMS Key"
  }
}

resource "aws_kms_alias" "ec2_key" {
  name          = "alias/ec2-secrets-key"
  target_key_id = aws_kms_key.ec2_key.key_id
}

# Store private key in AWS Secrets Manager
resource "aws_secretsmanager_secret" "ec2_private_key" {
  name        = aws_key_pair.ec2_key_pair.key_name
  description = "Private key for EC2 Linux instance SSH access"
  kms_key_id  = aws_kms_key.ec2_key.id

  tags = {
    Name = "EC2 Linux Private Key"
  }
}

resource "aws_secretsmanager_secret_version" "ec2_private_key" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key.id
  secret_string = tls_private_key.ec2_key.private_key_pem
}
