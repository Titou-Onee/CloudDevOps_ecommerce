# End-to-End GitOps CI/CD Pipeline on AWS

Welcome to **Ecommerce_DevSecOps Project**, a comprehensive hands-on student project focused of building an end-to-end CI/CD infrastructure for containerized application with native DevSecOps best practices.

This project leverages :
- **Infra as Code** with **Terraform** for AWS **EKS** infrastructure provisioning and **Ansible** for automated configuration management
- **CI & Gitops** with **GitHub Actions** for continuous integration, and **ArgoCD** for GitOps-based deployment
- **Security and monitoring** with  **OPA Gatekeeper**, **Falco**, **Prometheus**, **Grafana** and **SealedSecret**.

**Community note** : This project was designed as an intensive learning experience, aiming to explore and experiment as many automation and security functionalities as possible. Feel free to fork this project to contribute and enhance its capabilities !


---
# Project Architecture

![ecommerce_architecture](https://github.com/user-attachments/assets/ec77b73f-411f-42a8-a195-d24d5eddc8a1)

---
## Architecture Overview

### 1. Application and Dockerisation
- Existing app from a forked project : [repo forked](https://github.com/fatemehkarimi/ecommerce_store.git)
- DockerFile to create the Docker image

### 2. GitHub Actions
- **Terraform workflow** :
    - On .tf files update -> Terraform init, plan, TfLint, Tfsec, Checkov and Infracost
- **Kubernetes Worflow** :
    - On manifest update -> Checkov scan
- **Main** :
    - On application update -> main workflow calling modules
- **Modules** :
    - **format-lint-code**: black formatting and flake8 linting
    - **security**: Sonarqube scan, trivy fs & manifest scan ; build of the docker image, scan with Trivy image and upload as a signed Artifact
    - **release**: Recover signed image artifact, tag and push to DockerHub
    - **deploy**: Kustomize the kubernetes manifests to trigger ArgoCD

### 3. Kubernetes Manifests
- Use of **Kustomization** file to deploy the app and dynamically update the image tag.
- **Architecture** :
    - Namespace : ecommerce
    - Application_deployment
    - Postgresql_deployment
    - Postgresql_PVC
    - **SealedSecrets** : for DB secrets
- **Service** :
    - Ingress
    - Network policy
- **Security** :
    - Service account
    - Role

### 4. AWS Infrastructure provisioning usign Terraform
- **1 VPC**
- **Private Subnets** :
  - EKS module :
    - scaling nodes
    - iam RBAC
    - network security group
- **Public Subnets** :
     - Ec2 Bastion for cluster administration access via ssh
     - alb for application access
- **Remote state**
    - S3 bucket on AWS

### 5. Configuration Management using Ansible
- **Preparation of the cluster** :
    - Verification of the cluster state
    - Installation of drivers and gp3
- **ArgoCD** : 
    - Installation of the argoCD controller
    - Creation of the app-of-apps

### 6. Applications management using ArgoCD
App of Apps manifest use the GitOps repository to get the application manifest and the values for the configuration

**App of Apps** :
- **SyncWave 0 : Pod Security Standards**
    - PSS configuration for namespaces
- **SyncWave 1 : OPA Gatekeeper**
    - Controller for constraint deployment
- **SyncWave 2 : OPA Gatekeeper Policies application**
    - Constraints templates and constraint deployment
- **SyncWave 3 : Sealed secret Controller**
    - Decrypt kubernetes secrets with private key
- **SyncWave 4 : Falco**
    - Watch cluster and raise security alerts
- **SyncWave 5 : Ecommerce application**
    - Python application deployed with kustomize
- **SyncWave 6 : Prometheus**
    - Monitor cluster and apps
- **SyncWave 7 : Grafana**
    - Display data on dashboards for visualization

---

## Project Structure 

```bash
.
├── .github/workflows/     # GitHub Actions Workflows
├── ansible/               # Ansible inventory playbooks and roles
├── Docker/                # Dockerfile and app source code
├── terraform/             # Terraform modules and scripts
├── kubernetes/            # Kubernetes deployment and service manifests
├── gitOps/                # ArgoCD managed applications manifests and configurations
├── deploy.sh              # Script for Ansible deployment
└── README.md              # Main documentation file
```

## Project iteration
1. App fork and dockerization
- Finding ecommerce app to fork
- Dockerfile of the app
2. Github Action application workflow
- main workflow : code quality, security tests, release on DockerHub
3. terraform public cluster
- Simple public network and eks cluster creation
4. app deployment through kubernetes
- manifests for ecommerce application deployment
5. ansible argocd installation and configuration
- playbook for ArgoCD in the cluster
6. Github Action rework
- updated main with workflow calls, artifacts and cosign
- Added terraform.yml and kubernetes.yml
7. Kubernetes manifests securisation
- Checkov scan recommandations
- Added roles, service accounts and network policies
- Added SealedSecret for k8s secrets
6. ansible security tools installation and configuration
- use of an app-of-apps in argocd using "gitops/"
- Added opa gatekeeper, pss, falco helm charts installation in "gitops/apps"
- configuration of opa constraints, pss namespace policy and falco alerts in "gitops/values"
7. ansible monitoring tools installation and configuration
- updated gitops/ for prometheus and grafana
- Added prometheus and grafana helm charts installation in "gitops/apps"
- configuration of prometheus scrapping and grafana dashboards in "gitops/values"
9. terraform secure cluster with bastion and alb
- Updated modules "eks", "network" for security roles and private subnets 
- added modules "iam", "alb", "bastion"

## prerequises :
- AWS account
- optional : S3 bucket for remote terraform state (encryption, versioning and no public access)
- linux environment or wsl (for ansible playbook)
- Terraform, Ansible, SealedSecret (optional)
- Git secrets (GitActions part): 
    - DOCKERHUB_USERNAME
    - DOCKERHUB_TOKEN
    - SONAR_TOKEN (for sonar scan)
    - INFRACOST_API_KEY (for infracost scan)
    - AWS_KEY (for infracost scan)
    - AWS_SECRET_KEY (for infracost scan)
    - COSIGN_PRIVATE_KEY (for integrity scan of docker image)
    - COSIGN_PASSWORD (for integrity scan of docker image)
    - COSIGN_PUBLIC_KEY (for integrity scan of docker image)

## Fast Run
Clone the repository :
```bash
git clone https://github.com/Titou-Onee/CloudDevOps_ecommerce.git
```

Create the infrastructure :
```bash
cd terraform/infra
terraform init
terraform apply
```

Install ArgoCD and managed apps
```bash
cd ../..
chmod +x deploy.sh
./deploy.sh
```


  
## Author

**Titouann Mauchamp**
Student at UTT / Network & telecommunication - Information Systems Security

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/titouann-mauchamp-a095ba224/)

