
# # Create a secret in the castai-agent namespace

resource "kubernetes_namespace" "castai-agent" {
  metadata {
    name = "castai-agent"
  }
}

# Create ArgoCD AppProject
resource "kubernetes_manifest" "castai_app_project" {
    manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "AppProject"
    "metadata" = {
      "name" = format("%s-%s",var.aws_cluster_name,"project")
      "namespace" = "argocd"
    }
    "spec" = {
      "description" = "CASTAI components"
      "sourceRepos" = ["*"]
      "destinations" = [
        {
        "server" = "*"
        "namespace" = "*"
        }
        ]
      "clusterResourceWhitelist" = [
        {
        "group" = "*"
        "kind" = "*"
        }
        ]
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
    "spec" = {
      "generators" = [
        {
        "git" = {
          "repoURL" = var.gitops_repo_url
          "revision" = "HEAD"
          "directories" = [
            {
              "path" = "deploy/*"
            }
          ]
          }
        }
        ]
      "template" = {
        "metadata" = {
          "name" = format("%s-%s-{{path.basename}}",var.aws_cluster_name,"castai")
          }
        "spec" = {
          "project" = format("%s-%s",var.aws_cluster_name,"project")
          "source" = {
            "repoURL" = var.gitops_repo_url
            "path" = "{{path}}"
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


resource "kubernetes_secret" "castai-cluster-secret" {
  metadata {
    name      = "castai-cluster-secret"
    namespace = "castai-agent"
  }

  data = {
    "CLUSTER_ID" = castai_eks_clusterid.cluster_id.id
    "API_KEY"    = castai_eks_cluster.my_castai_cluster.cluster_token
  }
  
}