terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "tls" {
  # Configuration options
}

provider "aws" {
  region = "eu-west-1"
}