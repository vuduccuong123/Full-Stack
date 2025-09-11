data "aws_caller_identity" "current" {}

module "networking" {
  source              = "./common_modules/networking"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment         = var.environment
}

module "sg" {
  source      = "./common_modules/sg"
  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "rds" {
  source               = "./common_modules/rds"
  environment          = var.environment
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  private_subnet_ids   = module.networking.private_subnet_ids
  rds_sg_id            = module.sg.rds_sg_id
}

module "ecs_cluster" {
  source           = "./common_modules/ecs_cluster"
  environment      = var.environment
  ecs_cluster_name = var.ecs_cluster_name
  aws_region       = var.aws_region
}

module "asg_alb" {
  source            = "./common_modules/asg_alb"
  environment       = var.environment
  subdomain         = var.subdomain
  root_domain_name  = var.root_domain_name
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  vpc_id            = module.networking.vpc_id
}

module "task_ecs" {
  source                = "./common_modules/task_ecs"
  environment           = var.environment
  backend_cpu           = var.backend_cpu
  backend_memory        = var.backend_memory
  backend_image         = var.backend_image
  backend_image_tag     = var.backend_image_tag
  backend_desired_count = var.backend_desired_count
  frontend_cpu          = var.frontend_cpu
  frontend_memory       = var.frontend_memory
  frontend_image        = var.frontend_image
  frontend_image_tag    = var.frontend_image_tag
  frontend_desired_count = var.frontend_desired_count
  db_address            = module.rds.db_address
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  aws_region            = var.aws_region
  cluster_id            = module.ecs_cluster.cluster_id
  task_exec_role_arn    = module.ecs_cluster.task_exec_role_arn
  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_sg_id             = module.sg.ecs_sg_id
  backend_tg_arn        = module.asg_alb.backend_tg_arn
  frontend_tg_arn       = module.asg_alb.frontend_tg_arn
  alb_depends_on        = module.asg_alb
}

module "db_init" {
  source             = "./common_modules/db_init"
  environment        = var.environment
  db_address         = module.rds.db_address
  db_username        = var.db_username
  db_password        = var.db_password
  db_name            = var.db_name
  aws_region         = var.aws_region
  cluster_id         = module.ecs_cluster.cluster_id
  task_exec_role_arn = module.ecs_cluster.task_exec_role_arn
  private_subnet_ids = module.networking.private_subnet_ids
  ecs_sg_id          = module.sg.ecs_sg_id
  rds_depends_on     = module.rds
}

# data "aws_caller_identity" "current" {}

# module "networking" {
#   source              = "./common_modules/networking"
#   vpc_cidr            = var.vpc_cidr
#   public_subnet_cidrs = var.public_subnet_cidrs
#   private_subnet_cidrs = var.private_subnet_cidrs
#   environment         = var.environment
# }

# module "sg" {
#   source      = "./common_modules/sg"
#   environment = var.environment
#   vpc_id      = module.networking.vpc_id
# }

# module "rds" {
#   source               = "./common_modules/rds"
#   environment          = var.environment
#   db_instance_class    = var.db_instance_class
#   db_allocated_storage = var.db_allocated_storage
#   db_name              = var.db_name
#   db_username          = var.db_username
#   db_password          = var.db_password
#   private_subnet_ids   = module.networking.private_subnet_ids
#   rds_sg_id            = module.sg.rds_sg_id
# }

# module "ecs_cluster" {
#   source           = "./common_modules/ecs_cluster"
#   environment      = var.environment
#   ecs_cluster_name = var.ecs_cluster_name
#   aws_region       = var.aws_region
# }

# module "asg_alb" {
#   source            = "./common_modules/asg_alb"
#   environment       = var.environment
#   subdomain         = var.subdomain
#   root_domain_name  = var.root_domain_name
#   public_subnet_ids = module.networking.public_subnet_ids
#   alb_sg_id         = module.sg.alb_sg_id
#   vpc_id            = module.networking.vpc_id
# }

# module "task_ecs" {
#   source                = "./common_modules/task_ecs"
#   environment           = var.environment
#   backend_cpu           = var.backend_cpu
#   backend_memory        = var.backend_memory
#   backend_image         = var.backend_image
#   backend_image_tag     = var.backend_image_tag
#   backend_desired_count = var.backend_desired_count
#   frontend_cpu          = var.frontend_cpu
#   frontend_memory       = var.frontend_memory
#   frontend_image        = var.frontend_image
#   frontend_image_tag    = var.frontend_image_tag
#   frontend_desired_count = var.frontend_desired_count
#   db_address            = module.rds.db_address
#   db_name               = var.db_name
#   db_username           = var.db_username
#   db_password           = var.db_password
#   aws_region            = var.aws_region
#   cluster_id            = module.ecs_cluster.cluster_id
#   task_exec_role_arn    = module.ecs_cluster.task_exec_role_arn
#   private_subnet_ids    = module.networking.private_subnet_ids
#   ecs_sg_id             = module.sg.ecs_sg_id
#   backend_tg_arn        = module.asg_alb.backend_tg_arn
#   frontend_tg_arn       = module.asg_alb.frontend_tg_arn
#   alb_depends_on        = module.asg_alb
# }

# module "db_init" {
#   source             = "./common_modules/db_init"
#   environment        = var.environment
#   db_address         = module.rds.db_address
#   db_username        = var.db_username
#   db_password        = var.db_password
#   db_name            = var.db_name
#   aws_region         = var.aws_region
#   cluster_id         = module.ecs_cluster.cluster_id
#   task_exec_role_arn = module.ecs_cluster.task_exec_role_arn
#   private_subnet_ids = module.networking.private_subnet_ids
#   ecs_sg_id          = module.sg.ecs_sg_id
#   rds_depends_on     = module.rds
# }