resource "aws_rds_cluster" "default" {
  cluster_identifier      = var.identifier
  engine                  = "postgres"
  engine_version          = "14.2"
  availability_zones      = ["us-east-2a", "us-east-2b"]
  # DEMO - severity change based on business impact/data sensitivity Moderate -> Critical
  storage_encrypted   = false
  database_name           = var.db_name
  master_username         = var.username
  master_password         = var.password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.default.id]

  # SaC Testing - Severity: Moderate - Set exports to undefined
  #enabled_cloudwatch_logs_exports = []

 
  # SaC Testing - Severity: High - Set kms_key_id to ""
  #kms_key_id = ""
  apply_immediately   = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_cluster_parameter_group.id
  deletion_protection     = true
  # SaC Testing - Severity: High - Set iam_database_authentication_enabled to false
  iam_database_authentication_enabled = true
  skip_final_snapshot    = true
  final_snapshot_identifier = "DELETE"

  tags = {
    Environment = "dev"
    Name   = "rds_cluster"
  }

}

# SaC Testing - Severity: Critical - Delete the aws_rds_cluster_role_association resource_type
#resource "aws_rds_cluster_role_association" "example" {
#   db_cluster_identifier = aws_rds_cluster.default.id
#   feature_name          = "S3_INTEGRATION"
#   role_arn              = aws_iam_role.rds_s3_role.arn
#}

resource "aws_db_proxy" "rds_db_proxy" {
  name                   = "db-proxy"
  # SaC Testing - Severity: Moderate - Set debug_logging to false
  debug_logging          = true
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  # SaC Testing - Severity: High - Set require_tls to false
  require_tls            = true
  role_arn               = aws_iam_role.db_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.default.id]
  vpc_subnet_ids         = [aws_subnet.subnet_1[0].id,aws_subnet.subnet_1[1].id]

  auth {
    auth_scheme = "SECRETS"
    description = "example"
    # SaC Testing - Severity: High - Set iam_auth to "Required" & secret_arn to ""
    iam_auth    = "REQUIRED"
    secret_arn  = aws_secretsmanager_secret.rds_secrets.arn
  }

  tags = {
    Name = "rds_db_proxy"
    Env  = "dev"
  }
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.rds_db_proxy.name
  connection_pool_config {
    connection_borrow_timeout    = 300
    init_query                   = ""
    max_connections_percent      = 90
    max_idle_connections_percent = 50
    session_pinning_filters      = []
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = [aws_subnet.subnet_1[0].id,aws_subnet.subnet_1[1].id]
}

resource "aws_db_event_subscription" "default" {
  name      = "rds-event-sub"
  sns_topic = aws_sns_topic.default.arn
  # source_type = "db-cluster"
  source_ids  = [aws_rds_cluster.default.id]
  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
}

