variable "cluster_name" {
  
}
variable "cluster_version" {
  default = "1.29"
}
variable "subnet_ids" {}
variable "instance_types" {
  default = ["t3.medium"]
}
variable "desired_size" {
  default = 2
}
variable "min_size" {
  default = 1
}
variable "max_size" {
  default = 2
}