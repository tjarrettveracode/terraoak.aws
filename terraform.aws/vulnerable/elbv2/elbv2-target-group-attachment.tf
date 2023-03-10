resource "aws_lb_target_group_attachment" "elbv2_target_group_attachment" {
  target_group_arn = aws_lb_target_group.elbv2_target_group.arn   
  target_id        = aws_instance.aws_ec2_instance_sac_default.id   
}