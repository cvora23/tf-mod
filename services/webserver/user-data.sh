#!/bin/bash

# Install scripts for docker nginx container
# Reference: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

# Adds the GPG key for the official Docker repository to the system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to APT sources
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the packages
sudo apt-get update

# Making sure installing Docker from Repo instead of default Ubuntu 16.04 repo
sudo apt-cache policy docker-ce

# Install Docker Community Edition
sudo apt-get install -y docker-ce

# Pull the lastest Nginx image
sudo docker pull nginx:latest

# Run the nginx container on port 80
sudo docker run -d -p 80:80 --name nginx nginx


#cat > index.html <<EOF
#<h1>Hello, World</h1>
#<p>VPC Security Group ID: ${vpc_security_group_ids}</p>
#<p>App Server Subnet ID: ${subnet_id}</p>
#EOF
#
#nohup busybox httpd -f -p ${server_port} &