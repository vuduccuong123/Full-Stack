output "app_url" {
  value = "https://${module.asg_alb.app_domain}"
}