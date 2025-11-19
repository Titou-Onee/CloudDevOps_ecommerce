#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }


# Ansible installation
install_ansible_deps() {
    log_info "Installation of Ansible's collections..."
    cd ansible
    ansible-galaxy collection install -r requirements.yml --force
    cd ..
    log_success "Collections installed"
}


# Bootstrap GitOps
bootstrap_gitops() {
    log_info "Bootstrap GitOps with Ansible..."
    cd ansible
    ansible-playbook playbooks/argocd_bootstrap.yml
    cd ..
    log_success "Bootstrap finished"
}


# Access informations
show_access_info() {

    echo " ArgoCD"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  URL: https://localhost:8080"
    echo "  Username: admin"
    echo "  Password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo"
    echo ""
    
    echo " Grafana "
    echo "  kubectl port-forward svc/grafana -n monitoring 3000:80"
    echo "  URL: http://localhost:3000"
    echo ""
    
    echo "📈 Prometheus"
    echo "  kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"
    echo "  URL: http://localhost:9090"
    echo ""
}

# Main function
main() {
    install_ansible_deps
    bootstrap_gitops
    show_access_info
    
    echo ""
    log_success "Bootstrap GitOps finished!"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  https://localhost:8080"
}

main "$@"