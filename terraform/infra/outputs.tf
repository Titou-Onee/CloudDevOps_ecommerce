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
output "ebs_csi_driver_role_arn" {
  value = module.eks.ebs_csi_driver_role_arn
}
output "github_oidc_role_arn" {
  value       = module.OICD.github_actions_role_arn
}
