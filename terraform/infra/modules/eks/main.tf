# Main file of the EKS module
# Create a node group within a eks cluster
# define security group for nodes and cluster that allow intern traffic and a bastion connection
resource "aws_security_group" "eks_control_plane" {
  name   = "${var.project_name}-eks-control-plane-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-control-plane-sg"
  }
}


# Eks cluster definition
resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    role_arn = var.cluster_role_arn
    version = var.cluster_version
        access_config {
      authentication_mode = "API_AND_CONFIG_MAP"
      bootstrap_cluster_creator_admin_permissions = true
    }
    vpc_config {
      subnet_ids = var.subnet_ids
      endpoint_private_access = true
      endpoint_public_access = false
      security_group_ids = [aws_security_group.eks_control_plane.id]
    }
}

# EKS nodes security group
resource "aws_security_group" "eks_nodes" {
  name   = "${var.project_name}-eks-nodes-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.project_name}-eks-nodes-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


# Node group definition
resource "aws_eks_node_group" "main" {
  cluster_name = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn = var.node_role_arn
  subnet_ids = var.subnet_ids
  capacity_type = "SPOT"
  instance_types = var.instance_types
  
  scaling_config {
    desired_size = var.desired_size
    min_size = var.min_size
    max_size = var.max_size
  }
  update_config {
    max_unavailable = var.max_unavailable
  }
}

resource "aws_security_group_rule" "control_plane_to_nodes_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_control_plane.id
  description              = "Allow EKS control plane to talk to kubelets"
}

resource "aws_security_group_rule" "control_plane_to_nodes_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_control_plane.id
  description              = "Allow control plane bootstrap/API reach nodes"
}

resource "aws_security_group_rule" "control_plane_to_nodes_nodeport" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_control_plane.id
  description              = "Allow control plane to reach NodePort services"
}

resource "aws_security_group_rule" "control_plane_to_nodes_readonly" {
  type                     = "ingress"
  from_port                = 10255
  to_port                  = 10255
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_control_plane.id
  description              = "Optional kubelet read-only"
}

# Nodes -> Control plane
resource "aws_security_group_rule" "nodes_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane.id
  source_security_group_id = aws_security_group.eks_nodes.id
  description              = "Allow nodes to communicate with control plane API"
}

# Bastion -> Control plane
resource "aws_security_group_rule" "bastion_to_control_plane" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane.id
  source_security_group_id = var.bastion_security_group_id
  description              = "Admin access to cluster endpoint"
}



resource "aws_eks_access_entry" "bastion_access" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.bastion_iam_role 
  depends_on = [
    aws_eks_cluster.main
  ]
}


resource "aws_eks_access_policy_association" "bastion_policy" {
  cluster_name  = aws_eks_cluster.main.name

  principal_arn = aws_eks_access_entry.bastion_access.principal_arn 
  

  policy_arn    =             "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" 
  

  access_scope {
    type = "cluster"
  }
  
  depends_on = [
    aws_eks_access_entry.bastion_access
  ]
}

# data "aws_caller_identity" "current" {
# }
# resource "aws_eks_access_entry" "eks_admin_access" {
#   cluster_name = var.cluster_name
#   principal_arn = data.aws_caller_identity.current.arn
#   depends_on = [ aws_eks_cluster.main ]
# }

# resource "aws_eks_access_policy_association" "eks_admin_policy" {
#   cluster_name  = aws_eks_cluster.main.name

#   principal_arn = data.aws_caller_identity.current.arn
  

#   policy_arn    =             "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" 
  

#   access_scope {
#     type = "cluster"
#   }
  
#   depends_on = [
#     aws_eks_access_entry.eks_admin_access
#   ]
# }