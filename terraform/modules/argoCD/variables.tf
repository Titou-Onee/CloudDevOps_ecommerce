variable "github_repo_url" {}
variable "argocd_service_type" {
    default = "NodePort"
}
variable "argocd_domain" {
    default = "argocd.local"
}