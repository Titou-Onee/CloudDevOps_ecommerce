# Github Actions pipelines
---

## Application pipeline : main.tf

Modules used : 
- code-quality.yml
    - checkout / set up python / install pipenv / Cache pipenv / Install dependencies
    - run black / run flake8
- security.yml
    - checkout / restore pipenv
    - run gitleaks / run SonarCloud / run Trivy filescan
    - build Docker image / run Trivy image
    - save docker image /install cosign / sign image with cosign / upload image as artifact
    - Upload reports / set run_ID
- release.yml
    - download the artifact / install cosign / verify image / load docker image
    - login to docker hub / tag and push to docker hub 
- deploy.yml
    - checkout / update image tag in kustomize.yml / commit and push
---

## Argocd apps and ecommerce manifests pipeline : kubernetes.yml
- checkout
- scan of the ecommerce app manifests with checkov
- scan of the Argocd apps manifests with checkov
- upload reports
---

## Terraform pipeline : terraform.yml
- Checkout / configure AWS credentials / setup terraform
- run terraform init/format/validate
- Setup TFlint / run TFlint
- Create reports directory
- Setup Infracost / generate infracost breakdown / generate infracost .txt output
- TFsec scan
- Setup python / install Checkov / run checkov scan
- Upload reports
---
### Git secrets : 
- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN
- SONAR_TOKEN (for sonar scan)
- INFRACOST_API_KEY (for infracost scan)
- AWS_KEY (for infracost scan)
- AWS_SECRET_KEY (for infracost scan)
- COSIGN_PRIVATE_KEY (for integrity scan of docker image)
- COSIGN_PASSWORD (for integrity scan of docker image)
- COSIGN_PUBLIC_KEY (for integrity scan of docker image)