output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "node_group_asg_name" {
  value = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "ebs_csi_driver_role_arn" {
  value = aws_iam_role.ebs_csi_driver.arn
}
