terraform {
  required_version = ">= 1.11"

  backend "s3" {
  bucket         = var.bucket_name
  key            = "projet/terraform.tfstate"
  region         = "eu-west-3"
  use_lockfile = true
  profile = "default"
  }
}

provider "aws" {
  region = "eu-west-3"
  profile = "default"
}
