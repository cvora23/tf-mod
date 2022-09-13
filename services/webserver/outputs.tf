output "app_server_public_ip" {
  value = aws_instance.app_server[count.index].public_ip
  description = "The Public IP of the app server"
}

output "app_servers_rt_id" {
  value       = aws_route_table.app_servers_rt.id
  description = "The ID of the Route Table configured for the app servers"
}