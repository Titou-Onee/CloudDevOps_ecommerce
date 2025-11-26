terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



#backend "s3" {
# bucket         = "terraform-bucket"  # À créer au préalable
#key            = "eks/ecommerce/terraform.tfstate"
#region         = "eu-west-3"
#dynamodb_table = "terraform-state-lock"  # Pour le verrouillage
#encrypt        = true
#}
 