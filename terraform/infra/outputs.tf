output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}
output "node_group_name" {
  value = module.eks.node_group_name
}
output "kubectl_config_command" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.eks_cluster_name}"
}
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
output "ebs_csi_driver_role_arn" {
  value       = module.eks.ebs_csi_driver_role_arn
}
