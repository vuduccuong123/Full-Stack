output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "task_exec_role_arn" {
  value = aws_iam_role.task_exec.arn
}