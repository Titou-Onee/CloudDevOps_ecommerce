## prerequises :
- AWS account with IAM and EKS admin rights
- 1 SSH aws key for the bastion named "bastion-key"
- Terraform
- (optional) Git secrets (Github Actions part only): 
    - DOCKERHUB_USERNAME
    - DOCKERHUB_TOKEN
    - SONAR_TOKEN (for sonar scan)
    - INFRACOST_API_KEY (for infracost scan)
    - AWS_KEY (for infracost scan)
    - AWS_SECRET_KEY (for infracost scan)
    - COSIGN_PRIVATE_KEY (for integrity scan of docker image)
    - COSIGN_PASSWORD (for integrity scan of docker image)
    - COSIGN_PUBLIC_KEY (for integrity scan of docker image)

## Fast Run Github Actions
Clone the repository :
```bash
git clone https://github.com/Titou-Onee/CloudDevOps_ecommerce.git
```
add a change to any file
```bash
git add <file>
git commit -m "github actions test"
git push origin master
```


## Fast Run Deploy
Clone the repository :
```bash
git clone https://github.com/Titou-Onee/CloudDevOps_ecommerce.git
```

Create the backend :
```bash
cd CloudDevOps_Ecommerce/terraform/remote_state
aws cloudformation deploy --template-file .\s3_backend.yml --stack-name devsecops --parameter-overrides GitHubRepoName=Titou-Onee/CloudDevOps_ecommerce TerraformStateBucketName=remotestate18569402 --capabilities CAPABILITY_NAMED_IAM
```

Create the infrastructure :
```bash
cd ../infra
terraform init
terraform apply
```

- From the repo with aws ssh key, connect to the Bastion with the "ssh_bastion" output command line
- On the EC2 bastion, update kubeconfig with the "kubectl_config_command" output command line

Install ArgoCD and managed apps
```bash
cd repos/CloudDevOps_ecommerce
chmod +x ./deploy-argo.sh
./deploy-argo.sh
# The ARN is given by the terraform output "ebs_csi_driver_role_arn"
```
Connect to apps :
```bash
kubectl port-forwarding .... # see the output of the playbook
# open a new tab on your local host
ssh -i bastion-key.pem -L .....
# fill the "ssh_tunnel_bastion" output command line to create the tunnel
```

Access the application via browser on https://localhost:< local_port >


!!! please considere manual destroy of the load balancer and the volumes on AWS console !!!

