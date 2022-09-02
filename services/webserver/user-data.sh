#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>VPC Security Group ID: ${vpc_security_group_ids}</p>
<p>App Server Subnet ID: ${subnet_id}</p>
EOF

nohup busybox httpd -f -p ${server_port} &
