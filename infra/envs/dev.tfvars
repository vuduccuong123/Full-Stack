aws_region             = "ap-southeast-1"

environment            = "dev"
 
vpc_cidr               = "10.0.0.0/16"

public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]

private_subnet_cidrs   = ["10.0.20.0/24", "10.0.22.0/24"]
 
db_name                = "example"

db_username            = "admin"

 
db_allocated_storage   = 10

db_instance_class      = "db.t3.micro"
 
ecs_cluster_name       = "my-app-cluster"
 
backend_cpu            = 256

backend_memory         = 512

frontend_cpu           = 256

frontend_memory        = 512
 
backend_image          = "cuong2003/myapp-backend"

frontend_image         = "cuong2003/myapp-frontend"

backend_image_tag      = "dev-0a612e0v"

frontend_image_tag     = "dev-0a612e0v"
 
root_domain_name       = "tudaolw.io.vn"

subdomain              = "appv2"
 
frontend_desired_count = 1

backend_desired_count  = 1