# ALB Security Group: traffic to the ECS cluster can only come from this security group.
resource "aws_security_group" "lb" {
  name        = "expert-pancake-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    //Don't do this unless your are sure you wanna be hacked :p
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the Load Balancer
resource "aws_security_group" "ecs_tasks" {
  name        = "expert-pancake-ecs-tasks-security-group"
  description = "allow inbound access from the Load Balancer only"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.lb.id]
  }
  //Need to be able to reach out to get docker images etc
  egress {
   protocol    = "-1"
   from_port   = 0
   to_port     = 0
   cidr_blocks = ["0.0.0.0/0"]
 }
}
