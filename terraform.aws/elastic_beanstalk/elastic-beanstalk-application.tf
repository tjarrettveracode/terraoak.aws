resource "aws_elastic_beanstalk_application" "sac_beanstalk_application" {
  name        = "sac-testing-beanstalk-app"

  appversion_lifecycle {
    service_role = "arn:aws:iam::709695003849:role/aws-elasticbeanstalk-service-role"
    max_count = 128
  }
}