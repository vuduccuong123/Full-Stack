output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "backend_tg_arn" {
  value = aws_lb_target_group.backend.arn
}

output "app_domain" {
  value = "${var.subdomain}.${var.root_domain_name}"
}