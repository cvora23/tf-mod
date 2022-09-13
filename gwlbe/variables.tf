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

variable "webserver_local_state_path" {
  description = "The path for the webserver's local state"
  type        = string
}

variable "ubyon_gwlbe_svc_name" {
  description = "Ubyon GW Load Balancer Endpoint Service Name"
  type        = string
}

variable "gwlbe_netnum" {
  description = "GWLBE netnum for cidrsubnet"
  type        = number
}

variable "webserver_netnum" {
  description = "EC2 Instances netnum for cidrsubnet"
  type        = number
}
