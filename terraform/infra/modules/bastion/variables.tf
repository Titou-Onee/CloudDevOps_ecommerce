variable "project_name" {
  type = string
}

variable "vpc_id" {
  description = "L'ID du VPC fourni par le module réseau"
  type        = string
}

variable "bastion_subnet_id" {
  description = "L'ID du sous-réseau public spécifiquement pour le bastion"
  type        = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bastion_key_name" {
  type = string
}

variable "allowed_bastion_cidr" {
  description = "Liste des CIDR autorisés à se connecter au Bastion (SSH 22)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "bastion_instance_profile_name" {
  
}