# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags ={
    Name = "${var.project_name}-vpc"
  }
}

# Main gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-internet-gateway"
  }
}

# Public subnet for alb
resource "aws_subnet" "public"{
    count = length(var.availability_zones)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+length(var.availability_zones)-1)
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet-${count.index}"
        "kubernetes.io/role/elb"                    = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}


# Private subnet for eks cluster
resource "aws_subnet" "private-eks"{
    count = length(var.availability_zones)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+2*length(var.availability_zones)-1)
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.project_name}-private-eks-${count.index + length(var.availability_zones)}"
        "kubernetes.io/role/internal-elb"           = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

# Elastic IP for each NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

# NAT Gateway dans chaque sous-réseau public
resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.internet_gw]
}


# Internet route table for the public subnet
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gw.id
    }

    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

# Association of the public subnet bastion with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# Internet route table for the private subnet
resource "aws_route_table" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Association of the private subnet with the private route table
resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private-eks[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}