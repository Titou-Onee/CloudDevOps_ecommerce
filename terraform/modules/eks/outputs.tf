output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "node_group_asg_name" {
  value = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
}