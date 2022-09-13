terraform {
  required_version = ">= 1.0"
}

# create the Subnet
resource "aws_subnet" "app_servers_subnet" {
  count                   = 1
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = cidrsubnet(data.terraform_remote_state.vpc.outputs.vpc_cidr_block,8 ,(count.index * 2))
  map_public_ip_on_launch = local.map_public_ip
  availability_zone       = var.availability_zone
  tags = {
    Name ="${var.cluster_name}_app_servers_subnet_${count.index * 2}"
  }
} # end resource

# create the EC2 instance
resource "aws_instance" "app_server" {
  ami = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  key_name = "ubyon-terraform-kp"

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [ data.terraform_remote_state.vpc.outputs.vpc_security_group_id ]
  subnet_id = aws_subnet.app_servers_subnet[count.index].id
  associate_public_ip_address = true
  tags = {
    Name = "${var.cluster_name}_app_server"
  }
}

# Create the Route Table for Application Servers
resource "aws_route_table" "app_servers_rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  tags  = {
    Name = "${var.cluster_name}_app_servers_rt"
  }
} # end resource

# Associate the Route Table with the Subnet for Application Servers
resource "aws_route_table_association" "app_servers_rt_assoc" {
  subnet_id      = aws_subnet.app_servers_subnet[count.index].id
  route_table_id = aws_route_table.app_servers_rt.id
} # end resource

//# Adding route for Application Servers
resource "aws_route" "app_servers_route" {
  route_table_id = aws_route_table.app_servers_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = data.terraform_remote_state.vpc.outputs.igw_id
} # end resource

locals {
  map_public_ip = true
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    vpc_security_group_ids  = data.terraform_remote_state.vpc.outputs.vpc_security_group_id
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = var.vpc_local_state_path
  }
}