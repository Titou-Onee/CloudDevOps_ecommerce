module "network" {
  source              = "./modules/network"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zone   = var.availability_zones

}

# creation of the cluster eks and roles
module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.network.public_subnet_ids
  instance_types  = ["t3.large"]
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  max_unavailable = var.max_unavailable
  depends_on      = [module.network]
}
