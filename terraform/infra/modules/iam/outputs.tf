output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
output "node_role_arn" {
  description = "ARN du rôle IAM des nodes"
  value       = aws_iam_role.node_role.arn
}
output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion_profile.name
}
output "bastion_iam_role"{
  value = aws_iam_role.bastion_role.arn
}
output "nodes_instance_profile" {
  value = aws_iam_role.node_role.arn
}
