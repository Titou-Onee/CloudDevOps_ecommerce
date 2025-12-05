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

# ssh tunneling definitino for ingress installation
# 1st apply need to be commented (ctrl+k+c)
# 2nd apply usign the ssh tunneling through ec2 bastion 
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
# bucket         = "terraform-bucket"  # need to be created before apply
#key            = "eks/ecommerce/terraform.tfstate"
#region         = "eu-west-3"
#dynamodb_table = "terraform-state-lock"  # state lock
#encrypt        = true
#}
 