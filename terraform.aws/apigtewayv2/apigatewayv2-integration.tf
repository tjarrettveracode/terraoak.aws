resource "aws_apigatewayv2_integration" "sac_apigwv2_integration" {
  api_id           = aws_apigatewayv2_api.sac_apigwv2_api.id
  integration_type = "HTTP_PROXY"
  integration_method = "PATCH"
  connection_type = "INTERNET"
  integration_uri = aws_lb_listener.elbv2_listener.arn
}

resource "aws_vpc" "apigwv2_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "apigwv2-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.apigwv2_vpc.id

  tags = {
    Name = "main"
  }
}
resource "aws_subnet" "apigwv2_subnet" {
  vpc_id     = aws_vpc.apigwv2_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2c"

  map_public_ip_on_launch = true
  tags = {
    Name = "apigwv2_subnet"
  }
}
resource "aws_subnet" "apigwv2_subnet_2" {
  vpc_id     = aws_vpc.apigwv2_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "apigwv2_security_group" {
  name        = "apigwv2-security-group"
  vpc_id      = aws_vpc.apigwv2_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["173.0.0.0/32"]
  }

  tags = {
    Name = "apigwv2_sec_group"
  }
}