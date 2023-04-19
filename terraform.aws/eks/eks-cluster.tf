resource "aws_eks_cluster" "sac_eks_cluster" {
  name     = "sac-testing-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_security_group.id]
    subnet_ids = [aws_subnet.eks_subnet_1.id, aws_subnet.eks_subnet_2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-demo-node"
  }
}

resource "aws_subnet" "eks_subnet_1" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2c"

  map_public_ip_on_launch = true
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "eks_subnet_2" {
  depends_on = [
    aws_vpc.eks_vpc,
    aws_subnet.eks_subnet_1
  ]

  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "eks_gateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-demo"
  }
}

resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_gateway.id
  }
}

resource "aws_route_table_association" "eks_route_table_association" {
  count = 2

  subnet_id      = aws_subnet.eks_subnet_1.id
  route_table_id = aws_route_table.eks_route_table.id
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "sac-testing-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["eks.amazonaws.com",
                    "eks-fargate-pods.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_security_group" "eks_security_group" {
  name        = "eks-cluster-security-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["173.0.0.0/32"]
  }
}

resource "aws_kms_key" "eks_kms_key" {
  description              = "KMS key to encrypt/decrypt"
  deletion_window_in_days  = 10
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  is_enabled               = true
}