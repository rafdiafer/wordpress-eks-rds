# Wordpress k8s deployment being defined here. Using RDS DB defined on module.eks

# Configuration for the Kubernetes provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Kubernetes deployment for Wordpress app. Service on port 80.
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = var.app_name
    labels = {
      App = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          App = var.app_name
        }
      }

      spec {
        container {
          image = "${var.app_name}:latest"
          name  = var.app_name

          port {
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = aws_db_instance.wordpress_db.address
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "${var.app_name}db"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "admin"
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = var.dbpassword
          }
        }
      }
    }
  }
}

# Exposing port 80 on an ELB (AWS Load balancer) service type
resource "kubernetes_service" "wordpress" {
  metadata {
    name = var.app_name
  }

  spec {
    selector = {
      App = var.app_name
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}