variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "availability_zones" { default = ["eu-west-3a","eu-west-3b"] }
variable "cluster_name" {}
variable "key_name" {}
variable "region" { default = "eu-west-3" }