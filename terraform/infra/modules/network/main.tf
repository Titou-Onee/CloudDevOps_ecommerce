# Defination of the network for the EKS cluster
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags ={
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-internet"
  }
}

resource "aws_subnet" "public"{
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zone[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-subnet-${count.index +1}"
    }
}

# Internet route table for nodes
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gw.id
    }

    tags = {
        Name = "${var.project_name}-public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    count = length(var.public_subnet_cidrs) 
}

# Access list for the nodes
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  egress {
    protocol = "-1"
    rule_no = "110"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    action = "allow"
  }

  ingress {
    protocol = "-1"
    rule_no = "110"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    action = "allow"
  }

  tags = {
    Name = "${var.project_name}-network-acl"
  }
}