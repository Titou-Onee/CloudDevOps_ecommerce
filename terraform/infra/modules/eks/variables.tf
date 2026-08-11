variable "project_name" {
  description = "Name of the project used as a prefix for resource naming"
  type        = string
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster and nodes will be deployed"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS node group and cluster control plane"
  type        = list(string)
}
variable "bastion_security_group_id" {
  description = "ID of the bastion security group allowed to access the EKS cluster control plane"
  type        = string
}
variable "bastion_iam_role" {
  type        = string
  description = "Name or ARN of the IAM role attached to the bastion host for EKS access."
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the IAM role that provides permissions for the EKS worker nodes."
}

variable "cluster_role_arn" {
  type        = string
  description = "ARN of the IAM role that allows the EKS control plane to manage AWS resources."
}

variable "instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the EKS node group (e.g., ['t3.medium'])."
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes in the EKS node group."
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes in the EKS node group."
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes in the EKS node group."
}

variable "max_unavailable" {
  type        = number
  description = "Maximum number of worker nodes unavailable during node group updates."
}
