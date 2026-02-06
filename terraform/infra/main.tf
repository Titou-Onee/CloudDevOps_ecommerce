# Main file of this project
# Creation of the network, iam roles
# Creation of the bastion
# Creation of the cluster
# 2nd apply to create ingress and alb controller in the cluster using the ssh tunneling throug the ec2 bastion

# Creation of the network for eks
module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  bastion_key_name     = var.bastion_key_name
  allowed_bastion_cidr = var.allowed_bastion_cidr

}
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "bastion" {
  source                        = "./modules/bastion"
  project_name                  = var.project_name
  vpc_id                        = module.network.vpc_id
  bastion_subnet_id             = module.network.public_subnet_id[0]
  bastion_key_name              = var.bastion_key_name
  bastion_instance_profile_name = module.iam.bastion_instance_profile

  depends_on = [module.iam, module.network]
}

module "eks" {
  source          = "./modules/eks"
  project_name    = var.project_name
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnet_ids
  region          = var.region

  bastion_security_group_id = module.bastion.bastion_sg_id
  bastion_iam_role          = module.iam.bastion_iam_role

  node_role_arn    = module.iam.node_role_arn
  cluster_role_arn = module.iam.cluster_role_arn

  instance_types  = var.instance_types
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  max_unavailable = var.max_unavailable
  depends_on      = [module.bastion]

}