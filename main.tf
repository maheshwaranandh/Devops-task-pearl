# main.tf

provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # Adjust the CIDR block as needed
}

# Create a subnet
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24" # Adjust the CIDR block as needed
  availability_zone = "us-east-1a" # Adjust the availability zone as needed
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "my-cluster" # Change this to your desired cluster name
}

# Create a task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "hello-world"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = "256" # Adjust CPU and memory as needed
  memory                   = "512"

  execution_role_arn       = aws_iam_role.execution_role.arn

  container_definitions = <<DEFINITION
  [
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
  ]
  DEFINITION
}

# Create an IAM role for ECS task execution
resource "aws_iam_role" "execution_role" {
  name = "ecsRole"
  assume_role_policy = <<EOF
{
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
}
EOF
}

# Attach the execution role policy
resource "aws_iam_role_policy_attachment" "execution_attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Output ECS cluster and task definition ARNs
output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}
