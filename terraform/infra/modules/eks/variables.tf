variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = number
}
variable "subnet_ids" {
  type = list(string)
}
variable "instance_types" {
  type = list(string)
}
variable "desired_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "max_unavailable" {
  type = number
}
