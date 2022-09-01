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
  default = "ubyon_demo"
}

variable "availability_zone" {
  description = "The availability zone to use for all the cluster resources"
  type        = string
  default = "us-east-2a"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}