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
#"user_id": "e1f2449130bb11ed88747ee35cb25f4c"
#"cusomter_id": "e059d56d30bb11ed88747ee35cb25f4c"
#"app_id": "abfae00330cd11ed88747ee35cb25f4c"
#"fqdn": "app-93b06fe8-dde0-432e-a701-30746673fd95.maple.demo.ubyon.io"