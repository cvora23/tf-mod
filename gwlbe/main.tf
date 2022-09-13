terraform {
  required_version = ">= 1.0"
}

# create the Subnet
resource "aws_subnet" "gwlbe_subnet" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = cidrsubnet(data.terraform_remote_state.vpc.outputs.vpc_cidr_block,8 ,var.gwlbe_netnum)
  map_public_ip_on_launch = local.map_public_ip
  availability_zone       = var.availability_zone
  tags = {
    Name ="${var.cluster_name}_gwlbe_subnet_${var.gwlbe_netnum}"
  }
} # end resource

# Gateway LB Endpoint
resource "aws_vpc_endpoint" "gwlbe" {
  service_name      = var.ubyon_gwlbe_svc_name
  subnet_ids        = [aws_subnet.gwlbe_subnet.id]
  vpc_endpoint_type = local.vpc_endpoint_type
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "${var.cluster_name}_gwlbe"
  }
}

########################################## Internet GW ############################################################
# Create the Route Table for Internet GW
resource "aws_route_table" "igw_rt" {
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  tags  = {
    Name = "${var.cluster_name}_igw_rt"
  }
} # end resource

//# Adding route for Internet GW that routes traffic destined for the secured app servers to the Gateway Load Balancer endpoint
resource "aws_route" "igw_route" {
  route_table_id        = aws_route_table.igw_rt.id
  destination_cidr_block = cidrsubnet(data.terraform_remote_state.vpc.outputs.vpc_cidr_block,8 ,var.webserver_netnum)
  vpc_endpoint_id = aws_vpc_endpoint.gwlbe.id
} # end resource

resource "aws_route_table_association" "igw_rt_assoc" {
  gateway_id     = data.terraform_remote_state.vpc.outputs.igw_id
  route_table_id = aws_route_table.igw_rt.id
}
########################################## Internet GW ############################################################

########################################## GW Load Balancer EndPoint ##################################################
# Create the Route Table for GW Load Balancer EndPoint
resource "aws_route_table" "gwlbe_rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  tags  = {
    Name = "${var.cluster_name}_gwlbe_rt"
  }
} # end resource

//# Adding route for GW Load Balancer EndPt
resource "aws_route" "gwlbe_route" {
  route_table_id        = aws_route_table.gwlbe_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = data.terraform_remote_state.vpc.outputs.igw_id
} # end resource

# Associate the Route Table with the Subnet for GW Load Balancer EndPt
resource "aws_route_table_association" "gwlbe_rt_assoc" {
  subnet_id      = aws_subnet.gwlbe_subnet.id
  route_table_id = aws_route_table.gwlbe_rt.id
} # end resource
########################################## GW Load Balancer EndPoint ##################################################

############################################### Secured Application Servers ##########################################
//# Adding route for Secured Application Servers
resource "aws_route" "app_route" {
  route_table_id        = data.terraform_remote_state.webserver.outputs.app_servers_rt_id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = aws_vpc_endpoint.gwlbe.id
} # end resource
############################################### Secured Application Servers ##########################################

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = var.vpc_local_state_path
  }
}

data "terraform_remote_state" "webserver" {
  backend = "local"

  config = {
    path = var.webserver_local_state_path
  }
}

# Locals
locals {
  map_public_ip = true
  vpc_endpoint_type = "GatewayLoadBalancer"
}