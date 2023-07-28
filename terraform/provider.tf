terraform {
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket = "s3-terraform-state"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}
