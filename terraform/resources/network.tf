//Grab the Default VPC and its subnets
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.vpc.id
}
