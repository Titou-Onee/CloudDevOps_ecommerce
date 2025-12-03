output "alb_sg_id" {
  description = "ID du Security Group créé pour l'Application Load Balancer"
  value       = aws_security_group.alb.id
}