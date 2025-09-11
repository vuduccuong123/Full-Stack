variable "environment" {}
variable "db_instance_class" {}
variable "db_allocated_storage" {
  type = number
}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "rds_sg_id" {}