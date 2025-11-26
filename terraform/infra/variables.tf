# default variable for main and modules 
variable "project_name" {}
variable "cluster_name" {}
variable "cluster_version" { default = 1.33 }
variable "instance_type" { default = ["t3.medium"] }
variable "desired_size" { default = 2 }
variable "min_size" { default = 1 }
variable "max_size" { default = 2 }
variable "max_unavailable" { default = 1 }

variable "region" { default = "eu-west-3" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidrs" { default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "availability_zones" { default = ["eu-west-3a", "eu-west-3b"] }
variable "bucket_name" { default = "terraform-ecommerce-app" }

variable "github_repo" { default = "Titou-onee/CloudDevops_ecommerce" }
variable "git_orga_name" { default = "Titou-Onee" }

variable "ingress_name" { default = "ecommerce-ingress" }
variable "ingress_namespace" { default = "ecommerce" }
variable "service_name" { default = "ecommerce-service" }
variable "service_port" { default = 80 }
variable "hostname" { default = "api.mon-ecommerce.com" }       