resource "aws_db_instance" "default" {
  depends_on              = [aws_security_group.default]
  identifier              = var.identifier
  allocated_storage       = 10
  engine                  = "postgres"
  engine_version          = "14.2"
  # DEMO - severity change based on business impact Low -> High
  multi_az = false
  # DEMO - severity change based on business impact/data sensitivity Moderate -> Critical
  storage_encrypted = false
  monitoring_interval = 10
  instance_class          = var.instance_class
  name                    = var.db_name
  username                = var.username
  password                = var.password
  vpc_security_group_ids  = [aws_security_group.default.id]
  db_subnet_group_name    = aws_db_subnet_group.default.id
  parameter_group_name    = aws_db_parameter_group.parameter_group.id
  availability_zone       = "us-east-2a"
  backup_retention_period = 5
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  publicly_accessible     = false
  kms_key_id = ""
  apply_immediately       = true
  max_allocated_storage   = 20
  deletion_protection     = false
  iam_database_authentication_enabled = true
  skip_final_snapshot    = true
  final_snapshot_identifier = "DELETE"
  tags = {
    Environment = "dev"
    Name   = "rds_cluster"
  }
}

resource "aws_db_proxy" "db_proxy" {
  name                   = "db-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.db_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.default.id]
  vpc_subnet_ids         = [aws_subnet.subnet_1[0].id,aws_subnet.subnet_1[1].id]

  auth {
    auth_scheme = "SECRETS"
    description = "example"
  }

  tags = {
    Name = "db_proxy"
    Env  = "dev"
  }
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.db_proxy.name
  connection_pool_config {
    connection_borrow_timeout    = 300
    init_query                   = ""
    max_connections_percent      = 90
    max_idle_connections_percent = 50
    session_pinning_filters      = []
  }
}

