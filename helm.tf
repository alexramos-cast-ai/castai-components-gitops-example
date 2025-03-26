# Deploy argocd helm chart
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.8.14"
  # values = [
  #   file("argocd-values.yaml"),
  # ]
}