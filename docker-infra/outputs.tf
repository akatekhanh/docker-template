# Network outputs
output "main_network_id" {
  description = "ID of the main Docker network"
  value       = docker_network.main.id
}

output "main_network_name" {
  description = "Name of the main Docker network"
  value       = docker_network.main.name
}

output "main_network_gateway" {
  description = "Gateway IP of the main network"
  value       = docker_network.main.ipam_config[0].gateway
}

output "main_network_subnet" {
  description = "Subnet of the main network"
  value       = docker_network.main.ipam_config[0].subnet
}

output "internal_network_id" {
  description = "ID of the internal Docker network"
  value       = docker_network.internal.id
}

output "internal_network_name" {
  description = "Name of the internal Docker network"
  value       = docker_network.internal.name
}

# Volume outputs
output "app_volume_name" {
  description = "Name of the application data volume"
  value       = docker_volume.app_data.name
}

output "app_volume_id" {
  description = "ID of the application data volume"
  value       = docker_volume.app_data.id
}

output "database_volume_name" {
  description = "Name of the database data volume"
  value       = docker_volume.database_data.name
}

output "database_volume_id" {
  description = "ID of the database data volume"
  value       = docker_volume.database_data.id
}

output "cache_volume_name" {
  description = "Name of the cache data volume"
  value       = docker_volume.cache_data.name
}

output "cache_volume_id" {
  description = "ID of the cache data volume"
  value       = docker_volume.cache_data.id
}

output "logs_volume_name" {
  description = "Name of the logs data volume"
  value       = docker_volume.logs_data.name
}

output "logs_volume_id" {
  description = "ID of the logs data volume"
  value       = docker_volume.logs_data.id
}

# Container outputs
output "volume_backup_container_id" {
  description = "ID of the volume backup container"
  value       = docker_container.volume_backup.id
}

output "volume_backup_container_name" {
  description = "Name of the volume backup container"
  value       = docker_container.volume_backup.name
}

output "health_check_container_id" {
  description = "ID of the health check container"
  value       = docker_container.health_check.id
}

output "health_check_container_name" {
  description = "Name of the health check container"
  value       = docker_container.health_check.name
}

# Aggregate outputs
output "networks" {
  description = "Map of all networks with their details"
  value = {
    main = {
      id      = docker_network.main.id
      name    = docker_network.main.name
      gateway = docker_network.main.ipam_config[0].gateway
      subnet  = docker_network.main.ipam_config[0].subnet
    }
    internal = {
      id   = docker_network.internal.id
      name = docker_network.internal.name
    }
  }
}

output "volumes" {
  description = "Map of all volumes with their details"
  value = {
    app      = { name = docker_volume.app_data.name, id = docker_volume.app_data.id }
    database = { name = docker_volume.database_data.name, id = docker_volume.database_data.id }
    cache    = { name = docker_volume.cache_data.name, id = docker_volume.cache_data.id }
    logs     = { name = docker_volume.logs_data.name, id = docker_volume.logs_data.id }
  }
}

output "infrastructure_info" {
  description = "Complete infrastructure information"
  value = {
    project_name = var.project_name
    environment  = var.environment
    networks     = self.networks
    volumes      = self.volumes
    containers = {
      volume_backup = { id = docker_container.volume_backup.id, name = docker_container.volume_backup.name }
      health_check  = { id = docker_container.health_check.id, name = docker_container.health_check.name }
    }
  }
}