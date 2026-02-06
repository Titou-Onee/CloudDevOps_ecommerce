# Main file of the Bastion module
# This bastion create an EC2 instance with a security group that allow connection to the eks cluster
# The bastion configuration include : git, curl, unzip, kubectl, ansible-galaxy, aws cli and a clone of this github repo
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
} 

#Bastion security group
resource "aws_security_group" "bastion" {
  name = "${var.project_name}-bastion-sg"
  vpc_id = var.vpc_id
  description = "Security Group for the EC2 bastion"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_bastion_cidr
    description = "allow ssh connection to the bastion"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all"
  }

  tags = {Name = "${var.project_name}-bastion-sg"}
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.bastion_instance_type
  key_name               = var.bastion_key_name
  associate_public_ip_address = true
  subnet_id              = var.bastion_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile = var.bastion_instance_profile_name

  user_data = <<-EOF
                  #!/bin/bash

                  dnf update -y
                  dnf install -y git python3.11 python3.11-pip

                  python3.11 -m pip install ansible
                  python3.11 -m pip install kubernetes
                  pip3.11 install passlib bcrypt

                  KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
                  curl -LO "https://dl.k8s.io/release/$KUBE_VERSION/bin/linux/amd64/kubectl"
                  chmod +x kubectl
                  sudo mv kubectl /usr/local/bin/

                  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
                  chmod 700 get_helm.sh
                  ./get_helm.sh
                  rm get_helm.sh

                  sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
                  sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
                  systemctl restart sshd

                  mkdir -p /home/ec2-user/repos
                  cd /home/ec2-user/repos
                  git clone https://github.com/Titou-Onee/CloudDevOps_ecommerce.git

                  chown -R ec2-user:ec2-user /home/ec2-user/repos
                  echo 'export PATH=$HOME/.local/bin:/usr/local/bin:$PATH' >> /home/ec2-user/.bashrc
                  
                  dnf clean all

                  EOF
  root_block_device {
    encrypted = true
  }
  tags = {
    Name = "${var.project_name}-ec2-bastion"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }
}