variable "project_name" {
  type        = string
  description = "Name of the project used as a prefix for resource naming."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster to be deployed."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC network (e.g., '10.0.0.0/16')."
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AWS availability zones where subnets will be provisioned."
}