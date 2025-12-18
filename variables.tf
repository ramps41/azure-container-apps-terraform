variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_name_prefix" {
  description = "Prefix for resource naming"
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
