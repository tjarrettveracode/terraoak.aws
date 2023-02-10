resource "aws_lb" "elbv2_sac" {
  name               = "elbv2-sac"
  load_balancer_type = "application"  # Default = application
  drop_invalid_header_fields = true
  desync_mitigation_mode = "monitor"
  internal = true
  
  subnet_mapping {
    subnet_id     = aws_subnet.elbv2_subnet_1.id
  }
  
  subnet_mapping {
  subnet_id     = aws_subnet.elbv2_subnet_2.id
  }

  access_logs {
    bucket = aws_s3_bucket.elbv2_bucket.bucket   # Required
    # SaC Testing - Severity: High - Set enabled to false
    enabled = false
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

resource "aws_subnet" "elbv2_subnet_2" {
  vpc_id     = aws_vpc.ec2_instance_vpc_default.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Main"
  }
}

resource "aws_s3_bucket" "elbv2_bucket" {
  bucket = "elbv2-bucket"
  acl    = "public-read-write"
}