# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone to use for all the cluster resources"
  type        = string
}

variable "vpc_local_state_path" {
  description = "The path for the vpc's local state"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "instance_netnum" {
  description = "EC2 Instances netnum for cidrsubnet"
  type        = number
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}