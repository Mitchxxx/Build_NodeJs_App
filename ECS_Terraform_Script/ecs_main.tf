# Define the provider AWS

provider "aws" {
  region = "eu-west-1"
}


# Create an ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "mitchxx-ecs-cluster"
}

# Create task Definition

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family-test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<EOF
  [
    {
        "name": "my-container",
        "image": "748527796092.dkr.ecr.eu-west-1.amazonaws.com/netflix-react:latest",
        "portMappings": [ 
            {
                "containerPort":80,
                "hostPort": 80
            }
        ]
    }
  ]
  EOF
}

# Create an ECS service to run the task on the cluster
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-285f284e"]
    security_groups  = ["sg-0edb5c78c5a331088"]
    assign_public_ip = true
  }
}

# Create IAM role tor ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role-jan"
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

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles       = aws_iam_role.ecs_task_execution_role.name
  name = "ecs_task_execution_policy_attachment"
}