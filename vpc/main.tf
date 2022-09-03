terraform {
  required_version = ">= 1.0"
}

# create the VPC
resource "aws_vpc" "svc_vpc" {
  cidr_block           = local.vpc_cidr_block
  instance_tenancy     = local.instance_tenancy
  enable_dns_support   = local.dns_support
  enable_dns_hostnames = local.dns_host_names
  tags = {
    Name = "${var.cluster_name}_svc_vpc"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.svc_vpc.id
  tags  = {
    Name = "${var.cluster_name}_igw"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "app_servers_subnet" {
  vpc_id                  = aws_vpc.svc_vpc.id
  cidr_block              = local.app_cidr_block
  map_public_ip_on_launch = local.map_public_ip
  availability_zone       = var.availability_zone
  tags = {
    Name ="${var.cluster_name}_app_servers_subnet"
  }
} # end resource

//# Adding route for Application Servers
resource "aws_route" "app_servers_route" {
  route_table_id = aws_route_table.app_servers_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
} # end resource

# Create the Route Table for Application Servers
resource "aws_route_table" "app_servers_rt" {
  vpc_id = aws_vpc.svc_vpc.id
  tags  = {
    Name = "${var.cluster_name}_app_servers_rt"
  }
} # end resource

# Associate the Route Table with the Subnet for Application Servers
resource "aws_route_table_association" "app_servers_rt_assoc" {
  subnet_id      = aws_subnet.app_servers_subnet.id
  route_table_id = aws_route_table.app_servers_rt.id
} # end resource

resource "aws_security_group" "sg" {
  name = "${var.cluster_name}_sg"
  description = "Allow SSH HTTP inbound connections"
  vpc_id = aws_vpc.svc_vpc.id
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_server_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = var.server_ssh_port
  to_port     = var.server_ssh_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.sg.id

  from_port   = 0
  to_port     = 0
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

# Locals
locals {
  vpc_cidr_block = "10.0.0.0/16"
  app_cidr_block = "10.0.1.0/24"
  instance_tenancy = "default"
  dns_support = true
  dns_host_names = true
  map_public_ip = true
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}
