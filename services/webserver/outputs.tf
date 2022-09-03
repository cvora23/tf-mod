output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The Public IP of the app server"
}