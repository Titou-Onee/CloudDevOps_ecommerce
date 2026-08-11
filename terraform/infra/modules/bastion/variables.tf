variable "project_name" {
  type = string
  description = "Name of the project used as a prefix for resource naming"
}

variable "vpc_id" {
  description = "ID of the VPC created by the network module"
  type        = string
}

variable "bastion_subnet_id" {
  description = "ID of the public subnet specifically dedicated to the bastion host"
  type        = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
  description = "EC2 instance type used for the bastion server"
}

variable "bastion_key_name" {
  type = string
  description = "Name of the AWS SSH key pair for administrative access to the bastion"
}

variable "allowed_bastion_cidr" {
  description = "List of CIDR IP blocks allowed to connect to the bastion via SSH (port 22)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "bastion_instance_profile_name" {
  type        = string
  description = "Name of the IAM instance profile attached to the bastion EC2 instance"
}