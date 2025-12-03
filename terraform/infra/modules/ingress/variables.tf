variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "eks_node_sg_id" {
  description = "ID du security group des nodes EKS"
  type        = string
}

variable "eks_oidc_url" {
  description = "URL de l'OIDC provider du cluster EKS"
  type        = string
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
}
variable "ingress_namespace" {
}

variable "public_subnet_ids" {
  description = "Liste des IDs des subnets publics pour l'ALB"
  type        = list(string)
}

variable "app_port" {
  description = "Port sur lequel l'application écoute dans les pods"
  type        = number
  default     = 8080
}

variable "ingress_name" {
  description = "Nom de l'Ingress Kubernetes"
  type        = string
  default     = "ecommerce-ingress"
}

variable "hostname" {
  description = "Nom de domaine pour l'Ingress (peut être vide pour accepter tous les hosts)"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Nom du Service Kubernetes backend"
  type        = string
}

variable "service_port" {
  description = "Port du Service Kubernetes backend"
  type        = number
  default     = 80
}

variable "healthcheck_path" {
  description = "Chemin pour les healthchecks de l'ALB"
  type        = string
  default     = "/"
}
