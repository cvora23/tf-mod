#! /bin/bash

sudo apt update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository --yes "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt-get install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo docker pull nginx:latest
sudo docker run --name mynginx1 -p 80:80 -d nginx

#cat > index.html <<EOF
#<h1>Hello, World</h1>
#<p>VPC Security Group ID: ${vpc_security_group_ids}</p>
#<p>App Server Subnet ID: ${subnet_id}</p>
#EOF
#
#nohup busybox httpd -f -p ${server_port} &