# default variable for main and modules 
variable "project_name" {
  type        = string
  description = "Name of the project used as a prefix for resource naming."
}

variable "region" {
  type        = string
  default     = "eu-west-3"
  description = "AWS region where all resources will be created."
}
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block allocated for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
  description = "List of AWS availability zones for subnet distribution."
}

variable "bastion_key_name" {
  type        = string
  default     = "bastion-key"
  description = "Name of the AWS SSH key pair associated with the bastion host."
}
variable "allowed_bastion_cidr" { 
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "CIDR IP block allowed to SSH (port 22) into the bastion"    
}
variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  default     = "1.34"
  description = "Kubernetes version to deploy for the EKS control plane."
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.large"]
  description = "EC2 instance types allocated for the EKS node group."
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Desired number of active worker nodes in the node group."
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum allowed number of worker nodes in the node group."
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Maximum allowed number of worker nodes in the node group."
}

variable "max_unavailable" {
  type        = number
  default     = 1
  description = "Maximum number of nodes that can be unavailable during node group updates."
}
variable "app_port" {
  type        = number
  default     = 80
  description = "Target application port configured on the worker nodes."
}

variable "ingress_name" {
  type        = string
  default     = "ecommerce-ingress"
  description = "Name of the Kubernetes Ingress resource."
}

variable "ingress_namespace" {
  type        = string
  default     = "ecommerce"
  description = "Kubernetes namespace where the Ingress resource will be created."
}

variable "service_name" {
  type        = string
  default     = "ecommerce-service"
  description = "Target Kubernetes service name routed by the Ingress controller."
}

variable "service_port" {
  type        = number
  default     = 80
  description = "Target service port routed by the Ingress controller."
}

variable "hostname" {
  type        = string
  default     = "api.mon-ecommerce.com"
  description = "Domain name (FQDN) assigned to the application Ingress rule."
}

#variable "bucket_name" { default = "terraform-ecommerce-app" }



