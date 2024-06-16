resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-my-cluster"
}

resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${var.project_name}-web-app",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "web" {
  name            = "${var.project_name}-web-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets          = aws_subnet.willedy.*.id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_lb_listener.front_end
  ]
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-web-app"
  retention_in_days = 5
}

resource "aws_lb" "ecs_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs.id]
  subnets            = [for subnet in aws_subnet.willedy : subnet.id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.willedy.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}