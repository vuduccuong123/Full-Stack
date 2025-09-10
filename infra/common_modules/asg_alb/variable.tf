variable "environment" {}
variable "subdomain" {}
variable "root_domain_name" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {}
variable "vpc_id" {}