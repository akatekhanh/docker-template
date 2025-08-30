terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Networks
resource "docker_network" "main" {
  name       = var.network_name
  driver     = "bridge"
  attachable = true

  ipam_config {
    subnet  = var.network_subnet
    gateway = var.network_gateway
  }

  labels {
    label = "env"
    value = var.environment
  }
}

resource "docker_network" "internal" {
  name       = "${var.network_name}-internal"
  driver     = "bridge"
  internal   = true
  attachable = true

  labels {
    label = "env"
    value = var.environment
  }
}

# Volumes
resource "docker_volume" "app_data" {
  name = "${var.project_name}-app-data"

  labels {
    label = "env"
    value = var.environment
  }
}

resource "docker_volume" "database_data" {
  name = "${var.project_name}-db-data"

  labels {
    label = "env"
    value = var.environment
  }
}

resource "docker_volume" "cache_data" {
  name = "${var.project_name}-cache-data"

  labels {
    label = "env"
    value = var.environment
  }
}

resource "docker_volume" "logs_data" {
  name = "${var.project_name}-logs-data"

  labels {
    label = "env"
    value = var.environment
  }
}

# Volume containers for data management
resource "docker_container" "volume_backup" {
  name  = "${var.project_name}-volume-backup"
  image = "alpine:latest"
  
  volumes {
    volume_name    = docker_volume.app_data.name
    container_path = "/data/app"
  }
  
  volumes {
    volume_name    = docker_volume.database_data.name
    container_path = "/data/db"
  }
  
  volumes {
    volume_name    = docker_volume.cache_data.name
    container_path = "/data/cache"
  }
  
  volumes {
    volume_name    = docker_volume.logs_data.name
    container_path = "/data/logs"
  }

  command = ["tail", "-f", "/dev/null"]
  
  networks_advanced {
    name = docker_network.internal.name
  }

  restart = "unless-stopped"
}

# Health check container
resource "docker_container" "health_check" {
  name  = "${var.project_name}-health-check"
  image = "curlimages/curl:latest"
  
  networks_advanced {
    name = docker_network.main.name
  }

  command = ["sleep", "infinity"]
  restart = "unless-stopped"
}