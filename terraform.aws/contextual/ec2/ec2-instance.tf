resource "aws_instance" "aws_ec2_instance_sac_default" {
  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.ec2_instance_subnet_default.id   # Required

  launch_template {
    id = aws_launch_template.aws_ec2_launch_template_sac_default.id
  }

  associate_public_ip_address = false

  # DEMO - violation based on business impact Low -> High
  #availability_zone = "us-east-2b"

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  monitoring = true
  security_groups = [aws_security_group.ec2_instance_security_group_default.id]
  vpc_security_group_ids = [aws_security_group.ec2_instance_security_group_default.id]

  tags = {
    "key" = "value"
  }

  ebs_block_device {
    delete_on_termination = false
    device_name = "/dev/sdf"  # Required
    encrypted = true

    # SaC Testing - Severity: High - Set ebs_block_device.kms_key_id to ""
    #kms_key_id = ""
    
    volume_size = 5

    tags = {
      "key" = "value"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_subnet" "ec2_instance_subnet_default" {
  vpc_id     = aws_vpc.ec2_instance_vpc_default.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
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