resource "aws_ecs_cluster" "main" {
  name = "expert-pancake"
}

data "template_file" "expert_pancake_app" {
  template = file("${path.module}/expert_pancake_container_definitions.json.tpl")

  vars = {
    app_image  = "${aws_ecr_repository.expert_pancake.repository_url}:${var.docker_image}",
    app_port   = var.app_port
    aws_region = "us-west-2"
    log_group  = aws_cloudwatch_log_group.expert_pancake.name
    log_stream = aws_cloudwatch_log_stream.expert_pancake.name
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "expert-pancake-app-task"
  task_role_arn            = aws_iam_role.expert_pancake_task_execution_role.arn
  execution_role_arn       = aws_iam_role.expert_pancake_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # possible values listed here https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  memory                   = "512"
  container_definitions    = data.template_file.expert_pancake_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = "expert-pancake"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.subnets.ids
    //Need to pull image due to running in default VPC (very bad)
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "expert-pancake-app"
    container_port   = var.app_port
  }
}
