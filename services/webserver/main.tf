terraform {
  required_version = ">= 1.0"
}

resource "aws_instance" "app_server" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.nano"
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
  backend = "s3"

  config = {
    bucket = var.vpc_remote_state_bucket
    key    = var.vpc_remote_state_key
    region = "us-east-2"
  }
}