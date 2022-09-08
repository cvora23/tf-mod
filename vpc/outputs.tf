output "vpc_id" {
  value       = aws_vpc.svc_vpc.id
  description = "The ID of the VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet GW"
}

output "vpc_security_group_id" {
  value       = aws_security_group.sg.id
  description = "The ID of the Security Group attached to the VPC"
}

output "app_servers_subnet_id" {
  value       = aws_subnet.app_servers_subnet.id
  description = "The ID of the Subnet configured for the app servers"
}