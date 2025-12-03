# Output file for main 
output "eks_cluster_name" {
  value = var.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "bastion_ip" {
  value = module.bastion.public_ip
}
output "ssh_tunneling_bastion" {
  value = "ssh -i bastion-key.pem -L 8086:${module.eks.cluster_endpoint}:443 ec2-user@${module.bastion.public_ip} -N"
}
output "kubectl_config_command" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}
output "deploy_argocd" {
  value = "../../deploy-argo.sh"
}
