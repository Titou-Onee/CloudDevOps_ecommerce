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
}
data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

provider "kubernetes" {
  alias = "tunnel"
  host = "https://127.0.0.1:8086"
  insecure = true


  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.main.name,
    ]
  }
}

provider "helm" {
  alias = "helm_tunnel"
  kubernetes {
    host       = "https://127.0.0.1:8086"
    insecure   = true
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.aws_eks_cluster.main.name,
      ]
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
