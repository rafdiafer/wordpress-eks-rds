# For the RDS that I need for the Wordpress deployment
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow WordPress EKS cluster to access RDS db"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}