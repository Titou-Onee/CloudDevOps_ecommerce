```bash
ansible
├── inventory
│    ├── hosts.yml                          # variables for hosts
│    └── group_vars                         # variables for the argocd_bootstrap playbook
├── playbooks
│    └── argocd_bootstrap.yml               # main playbook calling the roles
├── roles
│    ├── prepare-cluster                    # role for cluster preparation
│    ├── prepare-argocd-projects            # role for argocd projects creation
│    └── argocd                             # role for argocd installation and app-of-apps deployment
├── ansible.cfg                             # global configuration for ansible
├── requirements.yml                        # role dependances
└── README.md                               # ansible documentation file
```
---
# Main playbook : argocd_bootstrap.yml

**calling roles** : 
- prepare-cluster
- prepare-argocd-projects
- argocd

## Prepare-cluster : 
- Verify cluster connection / Print nodes
- Verify CSI EBS driver / define variable / add helm repo for CSI EBS / install CSI EBS drive
- Verify StorageClass gp3 / Create gp3 StorageClass
- Verify final state of the cluster / print the resume

## Prepare-argocd-projects :
- Create manifests for projects creation :
    - ecommerce-project
    - security-project
    - monitoring-project
    - system-project
- Apply manifest

## Argocd : 
- Add Argocd Helm repository
- Create ArgoCD and monitoring namespaces
- Create Redis secret
- Install ArgoCD with Helm
- Call prepare-argocd-projects role
- Create repositories secrets
- Wait for Argocd server
- Create app-of-apps
- Wait for the app-of-apps deployment