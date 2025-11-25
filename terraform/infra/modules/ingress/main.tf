resource "kubernetes_ingress_v1" "ecommerce_ingress_http_only" {
  metadata {
    name      = var.ingress_name
    namespace = var.ingress_namespace

    labels = {
      app = "ecommerce-app"
    }

    annotations = {
      "alb.ingress.kubernetes.io/scheme" : "internet-facing"
      "alb.ingress.kubernetes.io/target-type" : "ip"
      
      "alb.ingress.kubernetes.io/listen-ports" : jsonencode([
        { HTTP = 80 }
      ])
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "api.mon-ecommerce.com"

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
}