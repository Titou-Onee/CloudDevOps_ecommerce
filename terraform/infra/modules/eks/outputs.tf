output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "ebs_csi_driver_role_arn" {
  value = aws_iam_role.ebs_csi_driver.arn
}
