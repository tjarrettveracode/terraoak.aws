resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  cluster_name           = aws_eks_cluster.sac_eks_cluster.name
  fargate_profile_name   = "sac-eks-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_cluster_role.arn
  subnet_ids = [aws_subnet.eks_subnet_2.id]

  selector {
    namespace = "example"
  }
}