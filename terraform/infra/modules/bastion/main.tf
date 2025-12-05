# Main file of the Bastion module
# This bastion create an EC2 instance with a security group that allow connection to the eks cluster
# The bastion configuration include : git, curl, unzip, kubectl, ansible-galaxy, aws cli and a clone of this github repo
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.allowed_bastion_cidr
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {Name = "${var.project_name}-bastion-sg"}
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.bastion_instance_type
  key_name               = var.bastion_key_name
  associate_public_ip_address = true
  subnet_id              = var.bastion_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile = var.bastion_instance_profile_name

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y

                sudo yum install -y curl unzip git

                KUBE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
                curl -LO "https://dl.k8s.io/release/$KUBE_VERSION/bin/linux/amd64/kubectl"
                curl -LO "https://dl.k8s.io/$KUBE_VERSION/bin/linux/amd64/kubectl.sha256"
                echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
                chmod +x kubectl
                sudo mv kubectl /usr/local/bin/

                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install

                sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
                sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
                sudo systemctl restart sshd

                mkdir -p /home/ec2-user/repos
                cd /home/ec2-user/repos
                
                for i in {1..5}; do
                    git clone https://github.com/Titou-Onee/CloudDevOps_ecommerce.git && break
                    echo "Retrying git clone in 5s..."
                    sleep 5
                done
                chown -R ec2-user:ec2-user /home/ec2-user/repos
                EOF

  tags = {
    Name = "${var.project_name}-bastion"
  }
}