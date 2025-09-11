resource "aws_cloudwatch_log_group" "db_init" {
  name              = "/ecs/${var.environment}/db-init"
  retention_in_days = 7
  tags              = { Name = "${var.environment}-db-init-logs" }
}

resource "aws_ecs_task_definition" "db_init" {
  family                   = "${var.environment}-db-init"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_exec_role_arn
  container_definitions = jsonencode([{
    name  = "db-init"
    image = "mysql:8.0"
    command = [
      "mysql",
      "-h${var.db_address}",
      "-u${var.db_username}",
      "-p${var.db_password}",
      "${var.db_name}",
      "-e",
      "CREATE TABLE IF NOT EXISTS Product (id INTEGER NOT NULL AUTO_INCREMENT, name VARCHAR(50), price DECIMAL(12,2), PRIMARY KEY (id)); INSERT IGNORE INTO Product (name, price) VALUES ('Mobile', 100), ('Tablet', 200), ('Labtop', 300.00), ('Desktop', 400), ('Server', 500);"
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.environment}/db-init"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "null_resource" "run_db_init" {
  depends_on = [var.rds_depends_on, aws_cloudwatch_log_group.db_init]
  provisioner "local-exec" {
    command = <<EOT
      aws ecs run-task \
        --cluster ${var.cluster_id} \
        --task-definition ${aws_ecs_task_definition.db_init.arn} \
        --launch-type FARGATE \
        --network-configuration "awsvpcConfiguration={subnets=[${join(",", var.private_subnet_ids)}],securityGroups=[${var.ecs_sg_id}],assignPublicIp=DISABLED}" \
        --region ${var.aws_region}
    EOT
  }
}