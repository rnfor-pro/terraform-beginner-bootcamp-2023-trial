terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  #configuration option
}

provider "random" {
  #configuration option
}


resource "random_string" "bucket_name" {
  lower   = true
  upper   = false
  numeric = false
  length  = 16
  special = false
}


#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  #Bucket naming rules
  #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = random_string.bucket_name.result
}



#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "random_bucket_name" {
  value = random_string.bucket_name.result
}