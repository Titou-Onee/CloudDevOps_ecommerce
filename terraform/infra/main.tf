# Creation of the network for eks
module "network" {
  source              = "./modules/network"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zone   = var.availability_zones

}

# Creation of the cluster eks with IAM
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

# Creation of the ingress for ecommerce application 
module "ingress" {
  source            = "./modules/ingress"
  ingress_name      = var.ingress_name
  ingress_namespace = var.ingress_namespace
  service_name      = var.service_name
  service_port      = var.service_port
  hostname          = var.hostname
}
