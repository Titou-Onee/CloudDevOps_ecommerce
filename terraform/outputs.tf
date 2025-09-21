output "vpc_id" {
  value = module.network.vpc_id
}
output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}
output "node_group_name" {
  value = module.eks.node_group_name
}