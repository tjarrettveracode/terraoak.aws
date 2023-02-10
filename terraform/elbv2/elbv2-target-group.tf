resource "aws_lb_target_group" "elbv2_target_group" {
  name     = "elbv2-target-group-sac"
  target_type = "instance"    # Default -> instance
  vpc_id   = aws_vpc.ec2_instance_vpc_default.id
  port     = 80

  protocol = "HTTP"

  health_check {
    enabled = true
    protocol = "HTTP"
  }

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}