# # resource "aws_cloudwatch_log_group" "mysql_client" {
# #   name              = "/ecs/${var.environment}/mysql-client"
# #   retention_in_days = 7
# #   tags              = { Name = "${var.environment}-mysql-client-logs" }
# # }

# # resource "aws_ecs_task_definition" "mysql_client" {
# #   family                   = "${var.environment}-mysql-client"
# #   network_mode             = "awsvpc"
# #   requires_compatibilities = ["FARGATE"]
# #   cpu                      = "256"
# #   memory                   = "512"
# #   execution_role_arn       = var.task_exec_role_arn
# #   task_role_arn            = var.task_exec_role_arn

# #   container_definitions = jsonencode([{
# #     name  = "mysql-client"
# #     image = "mysql:8.0"
# #     command = ["tail", "-f", "/dev/null"] # Keeps container running
# #     environment = [
# #       { name = "MYSQL_HOST", value = var.db_address },
# #       { name = "MYSQL_USER", value = var.db_username },
# #       { name = "MYSQL_PASSWORD", value = var.db_password },
# #       { name = "MYSQL_DATABASE", value = var.db_name }
# #     ]
# #     logConfiguration = {
# #       logDriver = "awslogs"
# #       options = {
# #         awslogs-group         = "/ecs/${var.environment}/mysql-client"
# #         awslogs-region        = var.aws_region
# #         awslogs-stream-prefix = "ecs"
# #       }
# #     }
# #     linuxParameters = {
# #       capabilities = {
# #         add  = []
# #         drop = []
# #       }
# #       initProcessEnabled = true # Required for ECS Exec
# #     }
# #   }])
# # }

# # resource "aws_ecs_service" "mysql_client" {
# #   name            = "${var.environment}-mysql-client-svc"
# #   cluster         = var.cluster_id
# #   task_definition = aws_ecs_task_definition.mysql_client.arn
# #   desired_count   = 1
# #   launch_type     = "FARGATE"

# #   network_configuration {
# #     subnets          = var.private_subnet_ids
# #     security_groups  = [var.ecs_sg_id]
# #     assign_public_ip = false
# #   }

# #   force_new_deployment = true
# # }

# ############################################
# # IAM Roles
# ############################################

# # ECS Task Execution Role
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "${var.environment}-ecs-task-exec-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # Attach policies for ECS Exec + logging
# resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }


# resource "aws_iam_role_policy_attachment" "ecs_ssm_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# ############################################
# # CloudWatch Logs
# ############################################

# resource "aws_cloudwatch_log_group" "mysql_client" {
#   name              = "/ecs/${var.environment}/mysql-client"
#   retention_in_days = 7
#   tags              = { Name = "${var.environment}-mysql-client-logs" }
# }

# ############################################
# # ECS Task Definition
# ############################################

# # Bỏ đoạn resource "aws_iam_role" ecs_task_execution_role

# resource "aws_ecs_task_definition" "mysql_client" {
#   family                   = "${var.environment}-mysql-client"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = var.task_exec_role_arn   # ✅ dùng biến input
#   task_role_arn            = var.task_exec_role_arn

#   container_definitions = jsonencode([{
#     name  = "mysql-client"
#     image = "mysql:8.0"
#     command = ["tail", "-f", "/dev/null"]
#     environment = [
#       { name = "MYSQL_HOST", value = var.db_address },
#       { name = "MYSQL_USER", value = var.db_username },
#       { name = "MYSQL_PASSWORD", value = var.db_password },
#       { name = "MYSQL_DATABASE", value = var.db_name }
#     ]
#     logConfiguration = {
#       logDriver = "awslogs"
#       options = {
#         awslogs-group         = "/ecs/${var.environment}/mysql-client"
#         awslogs-region        = var.aws_region
#         awslogs-stream-prefix = "ecs"
#       }
#     }
#     linuxParameters = {
#       initProcessEnabled = true
#     }
#   }])
# }


# ############################################
# # ECS Service
# ############################################

# resource "aws_ecs_service" "mysql_client" {
#   name            = "${var.environment}-mysql-client-svc"
#   cluster         = var.cluster_id
#   task_definition = aws_ecs_task_definition.mysql_client.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   enable_execute_command = true   # ✅ Bật ECS Exec

#   network_configuration {
#     subnets          = var.private_subnet_ids
#     security_groups  = [var.ecs_sg_id]
#     assign_public_ip = false
#   }

#   force_new_deployment = true
# }
