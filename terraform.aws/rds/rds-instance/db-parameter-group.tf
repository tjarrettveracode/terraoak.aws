resource "aws_db_parameter_group" "sac_rds_parameter_group" {
  name   = "sac-rds-param-group"
  family = "mysql5.6"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}