# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone to use for all the cluster resources"
  type        = string
}

variable "server_http_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "server_https_port" {
  description = "The port the server will use for HTTPS requests"
  type        = number
  default     = 443
}

variable "server_ssh_port" {
  description = "The port the server will use for ssh debugging"
  type        = number
  default     = 22
}