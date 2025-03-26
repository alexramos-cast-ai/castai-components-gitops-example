data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "existing_cluster" {
  name = var.aws_cluster_name # Replace with the actual name of your EKS cluster
}