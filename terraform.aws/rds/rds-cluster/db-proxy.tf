resource "aws_db_proxy" "sac_rds_db_proxy" {
  name                   = "sac-rds-db-proxy"
  role_arn               = aws_iam_role.db_proxy_role.arn
  vpc_subnet_ids         = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]
  engine_family          = "MYSQL"
  debug_logging          = true
  require_tls            = false

  auth {
    secret_arn  = aws_secretsmanager_secret.sac_secrets_manager.arn
    iam_auth    = "DISABLED"
  }
}