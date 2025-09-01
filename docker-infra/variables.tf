variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "docker-template"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "network_name" {
  description = "Name of the main Docker network"
  type        = string
  default     = "docker-template-network"
}

variable "network_subnet" {
  description = "Subnet for the main network"
  type        = string
  default     = "172.27.0.0/16"
}

variable "network_gateway" {
  description = "Gateway IP for the main network"
  type        = string
  default     = "172.27.0.1"
}

variable "internal_network_subnet" {
  description = "Subnet for the internal network"
  type        = string
  default     = "172.28.0.0/16"
}

variable "internal_network_gateway" {
  description = "Gateway IP for the internal network"
  type        = string
  default     = "172.28.0.1"
}

variable "volume_driver" {
  description = "Docker volume driver to use"
  type        = string
  default     = "local"
}

variable "backup_enabled" {
  description = "Enable volume backup functionality"
  type        = bool
  default     = true
}

variable "backup_schedule" {
  description = "Cron schedule for automated backups"
  type        = string
  default     = "0 2 * * *"
}

variable "retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "timezone" {
  description = "Timezone for scheduling operations"
  type        = string
  default     = "UTC"
}

variable "log_driver" {
  description = "Docker log driver to use"
  type        = string
  default     = "json-file"
}

variable "log_max_size" {
  description = "Maximum log file size"
  type        = string
  default     = "10m"
}

variable "log_max_file" {
  description = "Maximum number of log files to retain"
  type        = number
  default     = 3
}

variable "log_options" {
  description = "Log driver options"
  type        = map(string)
  default = {
    "max-size" = "10m"
    "max-file" = "3"
  }
}

variable "labels" {
  description = "Additional labels to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "restart_policy" {
  description = "Docker container restart policy"
  type        = string
  default     = "unless-stopped"
  validation {
    condition     = contains(["no", "always", "unless-stopped", "on-failure"], var.restart_policy)
    error_message = "Restart policy must be one of: no, always, unless-stopped, on-failure."
  }
}

variable "container_restart_policy" {
  description = "Restart policy for containers"
  type        = string
  default     = "unless-stopped"
  validation {
    condition     = contains(["no", "always", "unless-stopped", "on-failure"], var.container_restart_policy)
    error_message = "Restart policy must be one of: no, always, unless-stopped, on-failure."
  }
}

variable "health_check_interval" {
  description = "Interval for health checks in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health checks in seconds"
  type        = number
  default     = 10
}

variable "health_check_retries" {
  description = "Number of retries for health checks"
  type        = number
  default     = 3
}