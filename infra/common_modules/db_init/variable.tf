variable "environment" {}
variable "db_address" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "db_name" {}
variable "aws_region" {}
variable "cluster_id" {}
variable "task_exec_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ecs_sg_id" {}
variable "rds_depends_on" {
  type = any
}