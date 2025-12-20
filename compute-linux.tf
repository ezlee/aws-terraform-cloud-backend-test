
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

