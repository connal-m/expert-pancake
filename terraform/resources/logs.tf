//Nice simple logging for free with AWS
resource "aws_cloudwatch_log_group" "expert_pancake" {
  name = "expert-pancake-log-group"
}

resource "aws_cloudwatch_log_stream" "expert_pancake" {
  name           = "expert-pancake"
  log_group_name = aws_cloudwatch_log_group.expert_pancake.name
}
