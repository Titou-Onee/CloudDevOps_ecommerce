variable "project_name" {}


variable "region" { default = "eu-west-3" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "availability_zones" { default = ["eu-west-3a", "eu-west-3b"] }
variable "bastion_key_name" { default = "bastion-key" }
variable "allowed_bastion_cidr" { default = "0.0.0.0/0" }

variable "ingress_name" { default = "ecommerce-ingress" }
variable "ingress_namespace" { default = "ecommerce" }
variable "service_name" { default = "ecommerce-service" }
variable "service_port" { default = 80 }
variable "hostname" { default = "api.mon-ecommerce.com" }


variable "cluster_name" {}
variable "cluster_version" { default = 1.34 }
variable "instance_types" { default = ["t3.large"] }
variable "desired_size" { default = 2 }
variable "min_size" { default = 2 }
variable "max_size" { default = 3 }
variable "max_unavailable" { default = 1 }
variable "app_port" { default = 80 }



#variable "bucket_name" { default = "terraform-ecommerce-app" }



