output "cluster_id" {
  description = "ID du cluster EKS"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "Nom du cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Certificat du cluster EKS"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "nodes_security_group_id" {
  description = "ID du security group des nodes"
  value       = aws_security_group.eks_nodes.id
}

output "eks_oidc_url" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}
output "ebs_csi_driver_role_arn" {
  value       = aws_iam_role.ebs_csi_driver.arn
  description = "ARN du rôle IAM pour EBS CSI Driver"
}