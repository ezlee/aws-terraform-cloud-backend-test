terraform {

  cloud {
    organization = "ezlee"
    workspaces {
      name = "aws-terraform-cloud-backend-test"
    }
  }

  required_version = ">=0.13.0"

  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
    tls = {
      version = ">= 3.0.0"
      source  = "hashicorp/tls"
    }
    random = {
      version = ">= 3.0.0"
      source  = "hashicorp/random"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}