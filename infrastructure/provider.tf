provider "aws" {
  region     = var.AWS_REGION
}

terraform {
  backend "s3" {
    bucket = "my-tfstate-file-location"         
    key = "main"   
    region =  "us-east-2"         
    dynamodb_table = "my-tfstate-lock"  
  }
}