
# Get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "ip_whitelist" {
  type        = string
  description = "IP addresses for whitelist, format: x.x.x.x/y"
}

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

# Security Group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-linux-sg-2"
  description = "Security group for EC2 Linux instance - SSH access from specific IP"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_whitelist]
  }

  #tfsec:ignore:AVD-AWS-0104
  egress {
    description = "Allow all outbound traffic for package updates and API calls"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Linux Security Group"
  }
}

# EC2 Instance
resource "aws_instance" "linux" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = data.aws_subnet.existing.id

  root_block_device {
    encrypted   = true
    kms_key_id  = aws_kms_key.ec2_key.arn
    volume_type = "gp3"
    volume_size = 8
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "EC2 Linux Instance"
  }
}

