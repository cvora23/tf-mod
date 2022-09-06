#! /bin/bash

function old_install_nginx
{
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
  sudo mkdir -p /etc/nginx/sites-enabled
  sudo docker run --name mynginx1 -p 80:80 -d nginx
}

function install_nginx
{
  SOFTWARE="nginx"
  echo ""
  echo "INSTALLING NGINX..."
  echo ""
  sudo apt -y install $SOFTWARE
  # Setup configuration file
  sudo mkdir -p /etc/nginx/sites-enabled
  sudo systemctl reload $SOFTWARE
}

#install_nginx