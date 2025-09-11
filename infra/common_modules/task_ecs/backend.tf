resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.environment}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  execution_role_arn       = var.task_exec_role_arn
  container_definitions = jsonencode([{
    name  = "backend"
    image = "${var.backend_image}:${var.backend_image_tag}"
    portMappings = [{ containerPort = 80, protocol = "tcp" }]
    environment = [{
      name  = "ConnectionStrings__Database"
      value = "server=${var.db_address};port=3306;database=${var.db_name};user id=${var.db_username};password=${var.db_password}"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.environment}/backend"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "backend" {
  name            = "${var.environment}-backend-svc"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.backend_desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.backend_tg_arn
    container_name   = "backend"
    container_port   = 80
  }
  force_new_deployment = true
}