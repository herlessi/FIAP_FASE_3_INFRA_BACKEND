data "aws_iam_user" "principal_user" {
  user_name = "herlessi"
}

data "aws_eks_cluster" "cluster" {
  name = "eks-techchallenge-fiap-fase3-2153"
}

data "aws_eks_cluster_auth" "auth" {
  name = "eks-techchallenge-fiap-fase3-2153"
}