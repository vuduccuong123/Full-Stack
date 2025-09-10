resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_exec" {
  name               = "${var.environment}-ecs-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_role_policy_attachment" "task_exec_policy" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.environment}/backend"
  retention_in_days = 7
  tags              = { Name = "${var.environment}-backend-logs" }
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.environment}/frontend"
  retention_in_days = 7
  tags              = { Name = "${var.environment}-frontend-logs" }
}
# resource "aws_ecs_cluster" "this" {
#   name = var.ecs_cluster_name
# }

# data "aws_iam_policy_document" "ecs_task_assume" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "task_exec" {
#   name               = "${var.environment}-ecs-task-exec-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
# }

# resource "aws_iam_role_policy_attachment" "task_exec_policy" {
#   role       = aws_iam_role.task_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# # Add ECS Exec permissions
# resource "aws_iam_role_policy" "ecs_exec_policy" {
#   name   = "${var.environment}-ecs-exec-policy"
#   role   = aws_iam_role.task_exec.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ssmmessages:CreateControlChannel",
#           "ssmmessages:CreateDataChannel",
#           "ssmmessages:OpenControlChannel",
#           "ssmmessages:OpenDataChannel"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_cloudwatch_log_group" "backend" {
#   name              = "/ecs/${var.environment}/backend"
#   retention_in_days = 7
#   tags              = { Name = "${var.environment}-backend-logs" }
# }

# resource "aws_cloudwatch_log_group" "frontend" {
#   name              = "/ecs/${var.environment}/frontend"
#   retention_in_days = 7
#   tags              = { Name = "${var.environment}-frontend-logs" }
# }