```bash
kubernetes
├── namespace.yml                           # ecommerce namespace
├── service-accounts.yml                    # service account for ecommerce and postgres
├── network_policy.yml                      # Network policy
├── ecommerce_role.yml                      # Role creation for ecommerce
├── ecommerce_deployment.yml                # Deployment for ecommerce app
├── postgres_deployment.yml                 # Deployment for postgresql DB
├── postgres_pvc.yml                        # PVC creation for postgres DB
├── sealed_secrets.yml                      # K8s secrets crypted
├── kustomization.yml                       # kustomize file for global deployment
└── README.md                               # kubernetes documentation file
```
(not-secure-secret exists for a learning purpose)

2 types of pods : 
- ecommerce-app using validated image on DockerHub
- postgresql database using bitnami/postgresql image


