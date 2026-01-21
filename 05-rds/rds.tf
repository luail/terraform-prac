resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = local.public_subnets

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.db_identifier}-sg"
  description = "rds-sg"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = [var.my_ip_cidr]
    security_groups = [data.terraform_remote_state.eks.outputs.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.db_identifier}-param"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
}

resource "aws_db_instance" "this" {
  identifier = var.db_identifier

  engine         = "mysql"
  engine_version = var.engine_version
  port           = 3306

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  parameter_group_name = aws_db_parameter_group.this.name

  publicly_accessible = var.publicly_accessible

  deletion_protection     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = var.db_identifier
    Env  = "dev"
  }
}
