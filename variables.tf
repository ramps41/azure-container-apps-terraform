variable "deployment_environment" {
  description = "Deployment environment name (dev/prod)"
  type        = string
}

variable "deployment_location" {
  description = "Primary Azure region for the deployment"
  type        = string
}

variable "application_name_prefix" {
  description = "Prefix applied to all application resources"
  type        = string
}

variable "container_image" {
  description = "Container image for the app"
  type        = string
}

variable "container_cpu" {
  description = "CPU cores for the container"
  type        = number
  default     = 0.25
}

variable "container_memory" {
  description = "Memory for the container (e.g. 0.5Gi)"
  type        = string
  default     = "0.5Gi"
}
