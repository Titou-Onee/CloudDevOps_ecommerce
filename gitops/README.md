```bash
gitops
├── app-of-apps                          
│    └── app-of-apps.yml                 # bootstrap app-of-apps manifest
├── apps                                 # apps manifest used by app-of-apps
├── values
│    ├── gatekeeper                      # templates and constraints for OPA gatekeeper
│    ├── pss                             # pod security standard configuration
│    ├── values-prometheus.yml           # values for prometheus scrapping
│    ├── values-grafana.yml              # values for grafana dashboard
│    └── values-falco.yml                # values for falco alerts
├── ansible.cfg                             # global configuration for ansible
├── requirements.yml                        # role dependances
└── README.md                               # ansible documentation file
```
---
app-of-apps : deploy manifests in /apps that use values in /values

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

## Pod-Security-Standard : 
- restricted : ecommerce
- privileged : monitoring / security
- baseline : argocd

## OPA constraints templates/namespace :
- access-role-policy : serviceAccount / global premissions and podDisruptionBudget check
- argocd-application-policy : use of default project / unapproved source
- image-security-policy : use of non-certified registry
- namespace-label-policy : use of label name and component
- pod-security-policy : use of privileged mode / runAsRoot / host network / host PID / host IPC / host path / ReadOnlyFileSystem / AllowPrivilegeEscalation
- ressource-security-policy : use of resource.request / resource.limits
## Falco alerts :
- File created in /etc
- New user added
- K8s secret read
- Shell spawned in container
- Web app spawning shell
- Container reading IMDS
- Change namespace for privilege escalation
## Prometheus scrapping :
- Argocd-metrics / argocd-server-metrics
- ecommerce app
## Grafana dashboard :
- kubernetes
- argocd
- falco