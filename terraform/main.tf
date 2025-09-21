module "network" {
  source              = "./modules/network"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zone   = var.availability_zones

}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  cluster_version  = "1.29"
  subnet_ids       = module.network.public_subnet_ids
  instance_types   = ["t3.medium"]
  desired_size     = 2
  min_size         = 1
  max_size         = 2
}
module "githubActions" {
  source = "./modules/githubActions"
}

module "server" {
  source       = "./modules/server"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}