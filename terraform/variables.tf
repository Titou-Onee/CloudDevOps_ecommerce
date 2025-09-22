variable "project_name" {}
variable "cluster_name" {}
variable "region" { default = "eu-west-3" }
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "availability_zones" { default = ["eu-west-3a","eu-west-3b"] }

variable "key_name" {}
