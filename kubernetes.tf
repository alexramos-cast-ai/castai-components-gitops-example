# Create ArgoCD AppProject
resource "kubernetes_manifest" "castai_app_project" {
    manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "AppProject"
        "metadata" = {
            "name" = format("%s-%s",var.aws_cluster_name,"project")
            "namespace" = "argocd"
        }
        "Otherfields" = {
            "spec" = {
              "description" = "CASTAI components"
              "sourceRepos" = ["*"]
                "destinations" = [
                    {
                    "server" = "https://kubernetes.default.svc"
                    }
                ]
                }
            }
        }
    }

resource "kubernetes_manifest" "castai_applicationset" {
    manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "ApplicationSet"
        "metadata" = {
            "name" = format("%s-%s",var.aws_cluster_name,"appset")
            "namespace" = "argocd"
        }
        "Otherfields" = {
            "spec" = {
              "generators" = [
                {
                  "git" = {
                    "repoURL" = var.gitops_repo_url
                    "revision" = "HEAD"
                    "directories" = ["deploy"]
                  }
                }
              ]
              "template" = {
                "metadata" = {
                  "name" = "{{path.basename}}"
                }
                "spec" = {
                  "project" = format("%s-%s",var.aws_cluster_name,"project")
                  "source" = {
                    "repoURL" = var.gitops_repo_url
                    "path" = "deploy"
                    "targetRevision" = "HEAD"
                  }
                  "destination" = {
                    "server" = "https://kubernetes.default.svc"
                    "namespace" = "castai-agent"
                  }
                }
              }
            }
        }
    }
}

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