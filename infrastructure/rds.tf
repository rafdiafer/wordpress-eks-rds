#RDS instance for Wordpress deployment
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.small"
  db_name              = "${var.app_name}db"
  username             = "admin"
  password             = var.dbpassword
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "${var.app_name}db"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "wordpressdb"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "DB Subnet Group"
  }
}