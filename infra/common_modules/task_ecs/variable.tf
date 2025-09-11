variable "environment" {}
variable "backend_cpu" {}
variable "backend_memory" {}
variable "backend_image" {}
variable "backend_image_tag" {}
variable "backend_desired_count" {
  type = number
}
variable "frontend_cpu" {}
variable "frontend_memory" {}
variable "frontend_image" {}
variable "frontend_image_tag" {}
variable "frontend_desired_count" {
  type = number
}
variable "db_address" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "aws_region" {}
variable "cluster_id" {}
variable "task_exec_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ecs_sg_id" {}
variable "backend_tg_arn" {}
variable "frontend_tg_arn" {}
variable "alb_depends_on" {
  type = any
}