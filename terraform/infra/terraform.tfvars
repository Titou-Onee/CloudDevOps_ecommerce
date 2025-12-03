project_name = "CloudDevOps_Project"

region             = "eu-west-3"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["eu-west-3a", "eu-west-3b"]

bastion_key_name = "bastion-key"

ingress_name      = "ecommerce-ingress"
ingress_namespace = "ecommerce"

cluster_name    = "eks-cluster"
cluster_version = 1.34
instance_types  = ["t3.large"]
desired_size    = 2
min_size        = 1
max_size        = 2
max_unavailable = 1





