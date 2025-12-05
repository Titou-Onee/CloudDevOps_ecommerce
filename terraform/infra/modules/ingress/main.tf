# Main file of the ingress module
# Using the ssh tunneling to the bastion
# Create ecommerce namespace
# Create the ingress controller inside the cluster via "campaand/alb-ingress-controller/aws" module
# Create the ingress inside the cluster

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      configuration_aliases = [kubernetes.tunnel]
    }
    helm = {
      source  = "hashicorp/helm"
      configuration_aliases = [helm.helm_tunnel]
    }
  }
}

resource "kubernetes_namespace" "ecommerce" {
  provider = kubernetes.tunnel
  metadata {
    name = "ecommerce"
  }
}

module "alb_controller" {
  source = "campaand/alb-ingress-controller/aws"
  version = "2.1.1"
  helm_chart_version = "1.16.0"
  namespace = var.ingress_name
  cluster_name = var.cluster_name

  controller_iam_role_name = "${var.project_name}-alb-role"
  use_eks_pod_identity = true
  settings = {
    enableShield = false
    enableWaf = false
    hostNetwork = true
  }
  providers = {
    kubernetes = kubernetes.tunnel
    helm       = helm.helm_tunnel
  }
}




resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}


resource "aws_security_group_rule" "allow_alb_to_nodes" {
  type                     = "ingress"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = var.eks_node_sg_id
  description              = "Allow ALB to reach application pods on nodes"
}


resource "kubernetes_ingress_v1" "ecommerce_ingress" {
  provider = kubernetes.tunnel
  metadata {
    name      = var.ingress_name
    namespace = kubernetes_namespace.ecommerce.metadata[0].name
    
    labels = {
      app = "ecommerce-app"
    }

    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/security-groups" = aws_security_group.alb.id
      "alb.ingress.kubernetes.io/subnets"         = join(",", var.public_subnet_ids)
      "alb.ingress.kubernetes.io/listen-ports"    = jsonencode([{ HTTP = 80 }])
      "alb.ingress.kubernetes.io/healthcheck-path" = var.healthcheck_path
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "30"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "5"
      "alb.ingress.kubernetes.io/healthy-threshold-count"      = "2"
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "2"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = var.hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.service_name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.ecommerce,
    module.alb_controller
  ]
}
