output "vpc_id" {
  value = module.network.vpc_id
}
output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}
output "node_group_name" {
  value = module.eks.node_group_name
}
output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
}

output "argocd_url" {
  value       = "https://${helm_release.argocd.status[0].load_balancer[0].ingress[0].hostname}"
}

output "argocd_admin_password" {
  value       = base64decode(data.kubernetes_secret.argocd_admin.data["password"])
  sensitive   = true
}

output "kubectl_config_command" {
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}