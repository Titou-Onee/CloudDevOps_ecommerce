variable "project_name" {
  description = "Nom du projet"
  type        = string
}
variable "cluster_name" {
  type        = string
}
variable "cluster_version" {
  type        = string
}
variable "vpc_id" {
  type        = string
}
variable "subnet_ids" {
  type        = list(string)
}
variable "region" {
  
}
variable "bastion_security_group_id" {
  type        = string
}
variable "bastion_iam_role"{}

variable "node_role_arn" {
  
}
variable "cluster_role_arn" {
  
}

variable "instance_types" {
  type        = list(string)
}
variable "desired_size" {
  type        = number
}
variable "min_size" {
  type        = number
}
variable "max_size" {
  type        = number
}
variable "max_unavailable" {
  type        = number
}
