resource "aws_lb" "elbv2_gateway_sac" {
  name               = "elbv2-sac"
  load_balancer_type = "gateway"
  internal = false    # Must be false for gateway
  drop_invalid_header_fields = false
  desync_mitigation_mode = "defensive"
  
  tags = {
    key = "value"
  }

  # DEMO - violation based on business impact Low -> High
  subnets = [aws_subnet.elbv2_subnet_1.id]

  access_logs {
    bucket = aws_s3_bucket.elbv2_bucket.bucket   # Required
    enabled = true
  }
}

resource "aws_subnet" "elbv2_subnet_1" {
  vpc_id     = aws_vpc.ec2_instance_vpc_default.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Main"
  }
}

resource "aws_s3_bucket" "elbv2_bucket" {
  bucket = "elbv2-bucket"
  acl    = "public-read-write"
}

resource "aws_vpc" "ec2_instance_vpc_default" {
  cidr_block = "10.0.0.0/16" 
}

resource "aws_security_group" "ec2_instance_security_group_default" {
  name                   = "ec2-instance-security-group-default"
  description            = "Allow TLS inbound traffic"
  vpc_id                 = aws_vpc.ec2_instance_vpc_default.id
  revoke_rules_on_delete = false

  ingress {
    # All options # Must be configured
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    # All options # Must be configured
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}