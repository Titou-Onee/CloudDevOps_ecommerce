#!/bin/bash

# deploy.sh - Déploiement complet ArgoCD + Prometheus + Grafana

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier les prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    if ! command -v kubectl &> /dev/null; then
        log_error "kubectl n'est pas installé"
        exit 1
    fi
    
    if ! command -v ansible-playbook &> /dev/null; then
        log_error "ansible-playbook n'est pas installé"
        exit 1
    fi
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Impossible de se connecter au cluster Kubernetes"
        exit 1
    fi

    log_success "Tous les prérequis sont OK"
}

# Installer les collections Ansible
install_ansible_deps() {
    log_info "Installation des collections Ansible..."
    cd ansible
    ansible-galaxy collection install -r requirements.yml --force
    cd ..
    log_success "Collections installées"
}

# Déploiement complet
deploy_all() {
    log_info "Déploiement complet (ArgoCD + Monitoring)..."
    cd ansible
    ansible-playbook playbooks/argo-prom-graf.yml
    cd ..
    log_success "Déploiement terminé"
}

# Accès aux services
show_access_info() {
    echo ""
    echo "ArgoCD -> https://localhost:8080"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo ""
    echo "Grafana -> http://localhost:3000"
    echo "  kubectl port-forward svc/grafana -n monitoring 3000:80"
    echo ""
    echo "Prometheus -> http://localhost:9090"
    echo "  kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"
}

# Exécution
check_prerequisites
install_ansible_deps
deploy_all
show_access_info
