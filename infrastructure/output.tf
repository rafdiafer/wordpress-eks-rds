output "lb_hostname" {
  description = "Load Balancer hostname to connect to the Wordpress app"
  value       = kubernetes_service.wordpress.status.0.load_balancer.0.ingress.0.hostname
}