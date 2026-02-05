terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26"
    }
        helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

backend "s3" {
 bucket         = "remotestate18569402"  # need to be created before apply
  key            = "eks/ecommerce/terraform.tfstate"
  region         = "eu-west-3"
  encrypt = true
  use_lockfile = true
}
}
 