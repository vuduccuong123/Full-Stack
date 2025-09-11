output "backend_task_arn" {
  value = aws_ecs_task_definition.backend.arn
}

output "frontend_task_arn" {
  value = aws_ecs_task_definition.frontend.arn
}

# output "mysql_client_task_arn" {
#   value = aws_ecs_task_definition.mysql_client.arn
# }