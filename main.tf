provider "aws" {
  region = "us-east-1" 
}

resource "aws_ecs_cluster" "cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "hello-world"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = "256" 
  memory                   = "512"

  execution_role_arn       = aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      "name": "hello-world",
      "image": "maheshwaranandhm/devops-task-pearl:latest", 
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true
    }
  ])
}

resource "aws_iam_role" "execution_role" {
  name = "ecsRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = "vpc-08f7304b4971c95bb"  

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "load_balancer" {
  name               = "my-load-balancer"  
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-04b097eb12527d115", "subnet-04bf335b636d37fdd"] 
  enable_deletion_protection = false
  
  tags = {
    Name = "my-load-balancer" 
  }
}

resource "aws_ecs_service" "service" {
  name            = "my-service"  
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2  
  launch_type     = "FARGATE"

  network_configuration {
    subnets            = ["subnet-04b097eb12527d115", "subnet-04bf335b636d37fdd"] 
    security_groups  = [aws_security_group.ecs_service_sg.id]  
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "hello-world"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"  
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-08f7304b4971c95bb" 
  target_type="ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

output "alb_dns_name" {
  value = aws_lb.load_balancer.dns_name
}