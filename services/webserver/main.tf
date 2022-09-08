terraform {
  required_version = ">= 1.0"
}

resource "aws_instance" "app_server" {
  ami = "ami-02f3416038bdb17fb"
  instance_type = "t2.micro"
  key_name = "cvora_access_key"

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [ data.terraform_remote_state.vpc.outputs.vpc_security_group_id ]
  subnet_id = data.terraform_remote_state.vpc.outputs.app_servers_subnet_id
  associate_public_ip_address = true
  tags = {
    Name = "${var.cluster_name}_app_server"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    vpc_security_group_ids  = data.terraform_remote_state.vpc.outputs.vpc_security_group_id
    subnet_id     = data.terraform_remote_state.vpc.outputs.app_servers_subnet_id
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = var.vpc_local_state_file_path
  }
}