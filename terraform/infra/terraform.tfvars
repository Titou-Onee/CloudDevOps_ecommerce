project_name    = "CloudDevOps_Project"
cluster_name    = "eks-cluster"
cluster_version = 1.33
instance_type   = ["t3.medium"]
desired_size    = 2
min_size        = 1
max_size        = 2
max_unavailable = 1

region              = "eu-west-3"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
availability_zones  = ["eu-west-3a", "eu-west-3b"]

bucket_name = "terraform-ecommerce-app"



