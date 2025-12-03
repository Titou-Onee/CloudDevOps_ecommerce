output "public_ip" {
  description = "IP publique du bastion"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  description = "ID de l'instance bastion"
  value       = aws_instance.bastion.id
}

output "bastion_sg_id" {
  description = "L'ID du Security Group du Bastion"
  value       = aws_security_group.bastion.id
}