resource "aws_secretsmanager_secret" "sac_secrets_manager_insecure" {
  name                    = "sac-testing-secrets-manager-insecure"
  description             = "Default config2"

  # DEMO - violation based on data sensitivity
  #kms_key_id = aws_kms_key.sac_kms_key.id
  recovery_window_in_days = 10 

  tags = {
    Env = "dev"
  }
}

resource "aws_secretsmanager_secret_policy" "sac_secrets_manager_policy" {
  secret_arn = aws_secretsmanager_secret.sac_secrets_manager_insecure.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAnotherAWSAccountToReadTheSecret",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_kms_key" "sac_kms_key" {
  description             = "This key is used to encrypt dynamoDB objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
  enabled = true
  key_usage = "ENCRYPT_DECRYPT"

  tags = {
    Name        = "kms-key-1"
  }
}