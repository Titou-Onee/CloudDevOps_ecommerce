project_name        = "CloudDevOps_Project"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones  = ["eu-west-3a", "eu-west-3b"]
cluster_name        = "eks-cluster"
key_name            = "github-actions-key"
