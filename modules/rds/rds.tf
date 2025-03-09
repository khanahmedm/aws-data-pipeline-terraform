resource "aws_db_instance" "financial_db" {
  identifier           = "financial-db-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "16.3"
  instance_class      = "db.t3.micro"
  username           = "postgres"
  password           = data.aws_secretsmanager_secret_version.financialdb_password.secret_string
  publicly_accessible = true
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  backup_retention_period = 7
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = ["subnet-02a93104a988e0353", "subnet-095730436e9136896", "subnet-00146b77ecff26745",
                "subnet-0388108e2cfe2a942", "subnet-0fe04ab7f30b498d4", "subnet-0eb11097b47ed5f2f"]  # Replace with actual subnet IDs

  tags = {
    Name = "RDS PostgreSQL Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name = "rds-security-group"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Restrict access to your application's IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
