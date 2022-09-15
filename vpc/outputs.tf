output "vpc_id" {
  value       = aws_vpc.svc_vpc.id
  description = "The ID of the VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet GW"
}

output "igw_rt_id" {
  value       = aws_route_table.igw_rt.id
  description = "The ID of the Internet GW Route Table"
}

output "vpc_security_group_id" {
  value       = aws_security_group.sg.id
  description = "The ID of the Security Group attached to the VPC"
}

output "vpc_cidr_block" {
  value       = local.vpc_cidr_block
  description = "VPC CIDR Block"
}