terraform {
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket = "terraform-get-started"
    key    = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}
