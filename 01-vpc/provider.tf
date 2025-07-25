terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.60.0"
    }
  }
  backend"s3"{
    bucket="dev-daw9"
    key="exp-dev-vpc"
    region="us-east-1"
    dynamodb_table="dev-daw9"   
}
}
provider "aws" {
 region="us-east-1"
}