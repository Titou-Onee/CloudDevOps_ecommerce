```bash
terraform
├── README.md                              # Main terraform documentation
├── remote_state
│   ├── s3_backend.yml                     # CloudFormation template for S3 backend
└── infra
    ├── modules                            # Terraform modules
        ├── bastion                        # Bastion deployment and security group
        ├── eks                            # EKS cluster deployment and security group + bastion entry + openid connect for ebs_csi driver installation
        ├── iam                            # Role definition for each component
        └── network                        # Network definition
    ├── main.tf                            # Main tf file calling modules
    ├── outputs.tf                         # Outputs of the main file
    ├── variables.tf                       # Variables
    ├── terraform.tfvars                   # tfvars for personnalisation of variables
    ├── providers.tf                       # providers and backend definition
    └── bastion-key.pem                    # Bastion ssh connection key (for learning purpose, this key is not used anymore)
```

## AWS infrastructure

- 1 VPC
- 1 private network for EKS
- 1 public network for the EC2 bastion and ingress deployment
- Iam, security group for security