#!/bin/bash


set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR/ansible"

# Vérification des prérequis
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Vérifier kubectl
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl is required but not installed."
        exit 1
    fi
    
    # Vérifier ansible
    if ! command -v ansible-playbook &> /dev/null; then
        log_error "ansible-playbook is required but not installed."
        exit 1
    fi
    
    # Vérifier la connexion au cluster
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster. Check your kubeconfig."
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Installation des dépendances Ansible
install_ansible_deps() {
    log_info "Installing Ansible dependencies..."
    cd "$ANSIBLE_DIR"
    
    # Installer les collections Ansible
    ansible-galaxy collection install -r requirements.yml --force
    
    log_success "Ansible dependencies installed"
}

# Déploiement avec Ansible
deploy_with_ansible() {
    
    cd "$ANSIBLE_DIR"
    
    log_info "Running Ansible playbook"
    
    ansible-playbook \
        -i inventory/hosts.yml \
        playbooks/site.yml \
        -v
        
    if [ $? -eq 0 ]; then
        log_success "Deployment completed successfully"
    else
        log_error "Deployment failed"
        exit 1
    fi
}

# Affichage du statut
show_status() {
    log_info "Checking deployment status..."
    
    echo ""
    echo "=== ArgoCD Status ==="
    kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server 2>/dev/null || echo "ArgoCD not deployed"
    
    echo ""
    echo "=== Prometheus Status ==="
    kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus 2>/dev/null || echo "Prometheus not deployed"
    
    echo ""
    echo "=== Grafana Status ==="
    kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana 2>/dev/null || echo "Grafana not deployed"
    
    echo ""
    echo "=== Services ==="
    kubectl get svc -n argocd argocd-server 2>/dev/null || true
    kubectl get svc -n monitoring grafana 2>/dev/null || true
    kubectl get svc -n monitoring kube-prometheus-stack-prometheus 2>/dev/null || true
    
    echo ""
    echo "=== Ingresses ==="
    kubectl get ingress --all-namespaces 2>/dev/null || true
}

# Fonction pour obtenir les informations d'accès
get_access_info() {
    log_info "Getting access information..."
    
    echo ""
    echo "=== ArgoCD Access ==="
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d 2>/dev/null || echo "N/A")
    ARGOCD_SERVER=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "N/A")
    
    echo "URL: https://$ARGOCD_SERVER"
    echo "Username: admin"
    echo "Password: $ARGOCD_PASSWORD"
    
    echo ""
    echo "=== Grafana Access ==="
    GRAFANA_PASSWORD=$(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" 2>/dev/null | base64 -d 2>/dev/null || echo "N/A")
    GRAFANA_SERVER=$(kubectl get svc -n monitoring grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "N/A")
    
    echo "URL: http://$GRAFANA_SERVER"
    echo "Username: admin"
    echo "Password: $GRAFANA_PASSWORD"
    
    echo ""
    echo "Port-forward commands (if LoadBalancer not available):"
    echo "ArgoCD:    kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "Grafana:   kubectl port-forward svc/grafana -n monitoring 3000:80"
    echo "Prometheus: kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"
}

# Fonction principale
main() {
    check_prerequisites
    install_ansible_deps
    deploy_with_ansible "all"
    show_status
    get_access_info
}

# Vérifier qu'un argument est fourni
if [ $# -eq 0 ]; then
    log_error "No arguments provided"
    show_help
    exit 1
fi

main "$1"