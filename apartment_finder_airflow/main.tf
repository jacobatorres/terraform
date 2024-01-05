terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }

  required_version = ">= 1.5.6"
}


provider "aws" {

  region = var.aws_region

}


data "aws_availability_zones" "available" {
  state = "available"
}







