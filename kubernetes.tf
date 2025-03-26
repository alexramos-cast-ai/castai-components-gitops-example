# Create ArgoCD AppProject
# resource ""

# # Create a secret in the castai-agent namespace

# resource "kubernetes_namespace" "castai-agent" {
#   metadata {
#     name = "castai-agent"
#   }
# }

# resource "kubernetes_secret" "castai-cluster-secret" {
#   metadata {
#     name      = "castai-cluster-id"
#     namespace = "castai-agent"
#   }

#   data = {
#     "CLUSTER_ID" = castai_eks_clusterid.cluster_id.id
#     "API_KEY"    = castai_eks_cluster.my_castai_cluster.cluster_token
#   }
  
# }