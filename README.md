# End-to-End GitOps CI/CD Pipeline on AWS

A comprehensive end-to-end CI/CD infrastructure for containerized application. This project leverages **Terraform** for AWS EKS infrastructure provisioning, **Ansible** for automated configuration management, **GitHub Actions** for continuos integration, and **ArgoCD** for GitOps-based deployment to **Kubernetes** cluster.*

---
# Project Architecture
Add Gif
---
## Architecture Overview

### 1. AWS Infrastructure (Terraform provisioned)
- **Amazon EKS (Elastic Kubernetes Service)** : 
    - cluster with a node group
    - 2 worker nodes
- **Network** :
    - VPC
    - nodes services
- **IAM** :
    - RBAC roles for cluster composants
    - Permissions to automatic installation of ebs csi drivers by ansible
- **S3** : 
    - Remote backend for Terraform state management
---

### 2. Configuration Management using Ansible
- **ArgoCD** : 
    - Installation and configuration
    - creation of the ecommerce application on the cluster
- **Prometheus** : 
    - Installation and configuration on the cluster
    - Creation of alerts on argocd state
- **Grafana** :
    - Installation and configuration with Prometheus
    - Creation and importation of dashboards for full cluster data overview
---

### 3. Kubernetes Environment
- **EKS Cluster**: 
    - namespace isolation
    - Worker for frontEnd
    - Worker for Backend
    - Volume for Database


### 4. ArgoCD
- **GitOps Management of the application**
    - Automatic rollout of the application version
    - Automatic Heal and prune


## 5 GitHub Actions
- **4 workflows** :
    - **format-lint-code**: black formatting and flake8 linting
    - **security**: Sonarqube, trivy fs and trivy image scan + reporting
    - **release**: build and push of the image on DockerHub
    - **deploy**: Kustomize the kubernetes manifests to trigger ArgoCD

## Project Structure 

```bash
.
├── .github/workflows/     # GitHub Actions Workflows
├── Ansible/               # Ansible inventory playbooks and roles
├── Docker/                # Dockerfile and app source code
├── Terraform/             # Terraform modules and scripts
├── Kubernetes/            # Kubernetes deployment and service manifests
└── README.md              # Main documentation file
```

## Author

**Titouann Mauchamp**
Student at UTT ;)

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/titouann-mauchamp-a095ba224/)

