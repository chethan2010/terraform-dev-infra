terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }

  backend "s3" {
    bucket         = "dev-daw9"
    key            = "expense-dev-vpn/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "daws83s"
  }
}

provider "aws" {
  region = "us-east-1"
}