#!/bin/bash
# deploy-bootstrap.sh - Bootstrap GitOps complet avec ArgoCD
# Usage: ./deploy-bootstrap.sh

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Banner
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Bootstrap GitOps Stack avec ArgoCD                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    local missing=()
    
    if ! command -v kubectl &> /dev/null; then
        missing+=("kubectl")
    fi
    
    if ! command -v ansible-playbook &> /dev/null; then
        missing+=("ansible-playbook")
    fi
    
    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Outils manquants: ${missing[*]}"
        exit 1
    fi
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Impossible de se connecter au cluster Kubernetes"
        exit 1
    fi
    
    log_success "Prérequis OK"
}

# Installation des dépendances Ansible
install_ansible_deps() {
    log_info "Installation des collections Ansible..."
    cd ansible
    ansible-galaxy collection install -r requirements.yml --force
    cd ..
    log_success "Collections installées"
}

# Vérifier que le repo Git est configuré
check_git_config() {
    log_info "Vérification de la configuration Git..."
    
    if [ ! -d ".git" ]; then
        log_error "Ce répertoire n'est pas un repository Git"
        log_info "Initialisez un repository avec: git init"
        exit 1
    fi
    
    REMOTE_URL=$(git config --get remote.origin.url || echo "")
    if [ -z "$REMOTE_URL" ]; then
        log_warning "Aucun remote Git configuré"
        log_info "Configurez le remote avec: git remote add origin <URL>"
        read -p "Continuer quand même? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_success "Repository Git: $REMOTE_URL"
    fi
}

# Bootstrap GitOps
bootstrap_gitops() {
    log_info "Bootstrap GitOps avec Ansible..."
    cd ansible
    ansible-playbook playbooks/argocd_bootstrap.yml
    cd ..
    log_success "Bootstrap terminé"
}

# Surveiller le déploiement
watch_deployment() {
    log_info "Surveillance des déploiements ArgoCD..."
    echo ""
    
    sleep 10
    
    echo "=== Applications ArgoCD ==="
    kubectl get applications -n argocd 2>/dev/null || echo "En cours de création..."
    
    echo ""
    echo "=== Namespaces créés ==="
    kubectl get namespaces | grep -E '(ecommerce|monitoring|falco|gatekeeper)' || echo "En cours de création..."
    
    echo ""
    log_info "Pour suivre en temps réel:"
    echo ""
    echo "  Terminal 1 - Applications ArgoCD:"
    echo "    watch kubectl get applications -n argocd"
    echo ""
    echo "  Terminal 2 - Pods Monitoring:"
    echo "    watch kubectl get pods -n monitoring"
    echo ""
    echo "  Terminal 3 - Pods Sécurité:"
    echo "    watch kubectl get pods -n falco -n gatekeeper-system"
    echo ""
    echo "  Terminal 4 - Application E-commerce:"
    echo "    watch kubectl get pods -n ecommerce-app"
}

# Afficher les informations d'accès
show_access_info() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  Informations d'accès                                      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    # ArgoCD
    echo "📦 ArgoCD"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  URL: https://localhost:8080"
    echo "  Username: admin"
    echo "  Password: (voir ansible/inventory/group_vars/all.yml)"
    echo ""
    
    # Grafana (sera disponible après déploiement)
    echo "📊 Grafana (disponible dans ~10 minutes)"
    echo "  kubectl port-forward svc/grafana -n monitoring 3000:80"
    echo "  URL: http://localhost:3000"
    echo "  Username: admin"
    echo "  Password: (voir monitoring/grafana/values.yaml)"
    echo ""
    
    # Prometheus
    echo "📈 Prometheus (disponible dans ~10 minutes)"
    echo "  kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"
    echo "  URL: http://localhost:9090"
    echo ""
}

# Fonction principale
main() {
    check_prerequisites
    check_git_config
    install_ansible_deps
    bootstrap_gitops
    watch_deployment
    show_access_info
    
    echo ""
    log_success "Bootstrap GitOps terminé!"
    echo ""
    echo "⏱️  Les applications seront déployées automatiquement par ArgoCD"
    echo "📊 Temps estimé pour le déploiement complet: 10-15 minutes"
    echo ""
    echo "Pour accéder à ArgoCD et voir la progression:"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  https://localhost:8080"
}

main "$@"#!/bin/bash
# deploy-bootstrap.sh - Bootstrap GitOps complet avec ArgoCD
# Usage: ./deploy-bootstrap.sh

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Banner
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Bootstrap GitOps Stack avec ArgoCD                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    local missing=()
    
    if ! command -v kubectl &> /dev/null; then
        missing+=("kubectl")
    fi
    
    if ! command -v ansible-playbook &> /dev/null; then
        missing+=("ansible-playbook")
    fi
    
    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Outils manquants: ${missing[*]}"
        exit 1
    fi
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Impossible de se connecter au cluster Kubernetes"
        exit 1
    fi
    
    log_success "Prérequis OK"
}

# Installation des dépendances Ansible
install_ansible_deps() {
    log_info "Installation des collections Ansible..."
    cd ansible
    ansible-galaxy collection install -r requirements.yml --force
    cd ..
    log_success "Collections installées"
}

# Vérifier que le repo Git est configuré
check_git_config() {
    log_info "Vérification de la configuration Git..."
    
    if [ ! -d ".git" ]; then
        log_error "Ce répertoire n'est pas un repository Git"
        log_info "Initialisez un repository avec: git init"
        exit 1
    fi
    
    REMOTE_URL=$(git config --get remote.origin.url || echo "")
    if [ -z "$REMOTE_URL" ]; then
        log_warning "Aucun remote Git configuré"
        log_info "Configurez le remote avec: git remote add origin <URL>"
        read -p "Continuer quand même? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_success "Repository Git: $REMOTE_URL"
    fi
}

# Bootstrap GitOps
bootstrap_gitops() {
    log_info "Bootstrap GitOps avec Ansible..."
    cd ansible
    ansible-playbook playbooks/argocd_bootstrap.yml
    cd ..
    log_success "Bootstrap terminé"
}

# Surveiller le déploiement
watch_deployment() {
    log_info "Surveillance des déploiements ArgoCD..."
    echo ""
    
    sleep 10
    
    echo "=== Applications ArgoCD ==="
    kubectl get applications -n argocd 2>/dev/null || echo "En cours de création..."
    
    echo ""
    echo "=== Namespaces créés ==="
    kubectl get namespaces | grep -E '(ecommerce|monitoring|falco|gatekeeper)' || echo "En cours de création..."
    
    echo ""
    log_info "Pour suivre en temps réel:"
    echo ""
    echo "  Terminal 1 - Applications ArgoCD:"
    echo "    watch kubectl get applications -n argocd"
    echo ""
    echo "  Terminal 2 - Pods Monitoring:"
    echo "    watch kubectl get pods -n monitoring"
    echo ""
    echo "  Terminal 3 - Pods Sécurité:"
    echo "    watch kubectl get pods -n falco -n gatekeeper-system"
    echo ""
    echo "  Terminal 4 - Application E-commerce:"
    echo "    watch kubectl get pods -n ecommerce-app"
}

# Afficher les informations d'accès
show_access_info() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  Informations d'accès                                      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    # ArgoCD
    echo "📦 ArgoCD"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  URL: https://localhost:8080"
    echo "  Username: admin"
    echo "  Password: (voir ansible/inventory/group_vars/all.yml)"
    echo ""
    
    # Grafana (sera disponible après déploiement)
    echo "📊 Grafana (disponible dans ~10 minutes)"
    echo "  kubectl port-forward svc/grafana -n monitoring 3000:80"
    echo "  URL: http://localhost:3000"
    echo "  Username: admin"
    echo "  Password: (voir monitoring/grafana/values.yaml)"
    echo ""
    
    # Prometheus
    echo "📈 Prometheus (disponible dans ~10 minutes)"
    echo "  kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"
    echo "  URL: http://localhost:9090"
    echo ""
}

# Fonction principale
main() {
    check_prerequisites
    check_git_config
    install_ansible_deps
    bootstrap_gitops
    watch_deployment
    show_access_info
    
    echo ""
    log_success "Bootstrap GitOps terminé!"
    echo ""
    echo "⏱️  Les applications seront déployées automatiquement par ArgoCD"
    echo "📊 Temps estimé pour le déploiement complet: 10-15 minutes"
    echo ""
    echo "Pour accéder à ArgoCD et voir la progression:"
    echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo "  https://localhost:8080"
}

main "$@"