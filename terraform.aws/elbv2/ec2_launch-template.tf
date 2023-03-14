resource "aws_launch_template" "aws_ec2_launch_template_sac_default" {
  name = "ec2-instance-launch-template-sac-default"
  default_version = 1
  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized = true
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"

  tags = {
    "key" = "value"
  }

  metadata_options {
  http_endpoint               = "enabled"
  http_tokens                 = "required"
  http_put_response_hop_limit = 1
  instance_metadata_tags      = "enabled"
  }
}