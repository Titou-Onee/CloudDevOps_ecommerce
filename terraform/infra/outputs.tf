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
output "ssh_bastion" {
  value = "ssh -i bastion-key.pem ec2-user@${module.bastion.public_ip}"
}
output "ssh_tunnel_bastion" {
  value = "ssh -i bastion-key.pem -L <local_port>:localhost:<bastion_portforwarding_port> ec2-user@${module.bastion.public_ip}"
}
output "kubectl_config_command" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}

output "ebs_csi_driver_role_arn" {
  value = module.eks.ebs_csi_driver_role_arn
}