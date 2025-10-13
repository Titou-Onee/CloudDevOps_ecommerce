terraform {
  required_version = ">= 1.11"

  backend "s3" {
  bucket         = "terraform-ecommerce-app"  # À créer au préalable
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
