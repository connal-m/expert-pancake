/*
 * IAM role assumed by the ECS service that allows it to execute ECS tasks. This policy is required to allow
 * the ECS cluster to function properly.
 */
resource "aws_iam_role" "expert_pancake_task_execution_role" {
  name = "ecs-expert-pancake-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json
}

resource "aws_iam_role_policy_attachment" "maya_task_execution_role_policy" {
  role = aws_iam_role.expert_pancake_task_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
