output "vpc_id" {
  description = "L'ID du VPC principal"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés pour EKS (liste par AZ)"
  value       =     aws_subnet.private-eks[*].id
}
output "azs" {
  description = "Liste des AZs utilisées"
  value       = var.availability_zones
}
output "public_subnet_id" {
  value = aws_subnet.public[*].id
}