terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.18.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 16
  special          = false
}


output "random_bucket_name" {
  value = random_string.bucket_name.result
}