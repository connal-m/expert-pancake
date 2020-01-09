//This is super not cool with hardedcoded unencrypted passwords.
//Should use AWS Secrets Manager or similar!
//Public Access is also a no no, but I needed it for the ansible set up for some reason
resource "aws_db_instance" "expert_pancake" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "expertPancake"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
}
