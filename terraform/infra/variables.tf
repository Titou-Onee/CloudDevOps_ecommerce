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
