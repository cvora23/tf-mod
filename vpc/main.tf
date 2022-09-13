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


resource "aws_security_group" "sg" {
  name = "${var.cluster_name}_sg"
  description = "Allow SSH HTTP inbound connections"
  vpc_id = aws_vpc.svc_vpc.id
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = var.server_http_port
  to_port     = var.server_http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_server_https_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.sg.id

  from_port   = var.server_https_port
  to_port     = var.server_https_port
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
  protocol    = "-1"
  cidr_blocks = local.all_ips
}
locals {
  vpc_cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  dns_support = true
  dns_host_names = true
  map_public_ip = true
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

