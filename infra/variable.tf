variable "aws_region" {
  type = string
}
variable "environment" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "root_domain_name" {
  type = string
}
variable "subdomain" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_allocated_storage" {
  type = number
}
variable "db_name" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
  sensitive = true
}
variable "ecs_cluster_name" {
  type = string
}
variable "backend_cpu" {
  type = string
}
variable "backend_memory" {
  type = string
}
variable "backend_image" {
  type = string
}
variable "backend_image_tag" {
  type = string
}
variable "backend_desired_count" {
  type = number
}
variable "frontend_cpu" {
  type = string
}
variable "frontend_memory" {
  type = string
}
variable "frontend_image" {
  type = string
}
variable "frontend_image_tag" {
  type = string
}
variable "frontend_desired_count" {
  type = number
}