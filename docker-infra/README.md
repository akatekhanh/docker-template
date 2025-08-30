# Docker Infrastructure Management

This directory contains the Docker infrastructure configuration for managing networks, volumes, and related resources using both Terraform and Docker Compose.

## Structure

```
docker-infra/
├── main.tf                 # Terraform configuration for networks and volumes
├── variables.tf            # Terraform variables and defaults
├── outputs.tf              # Terraform outputs
├── docker-compose.yml      # Docker Compose for infrastructure services
├── .env.example           # Environment variables template
├── scripts/
│   └── backup.sh          # Volume backup and restore script
├── networks/              # Network configuration files
├── volumes/               # Volume configuration and data
└── README.md              # This documentation
```

## Quick Start

### Using Terraform

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Plan the changes**:

   ```bash
   terraform plan
   ```

3. **Apply the configuration**:

   ```bash
   terraform apply
   ```

### Using Docker Compose

1. **Copy environment file**:

   ```bash
   cp .env.example .env
   ```

2. **Start infrastructure services**:

   ```bash
   docker-compose up -d
   ```

3. **View running services**:

   ```bash
   docker-compose ps
   ```

## Network Configuration

### Networks Created

- **main**: Primary network for application services

  - Driver: bridge
  - Subnet: 172.20.0.0/16 (configurable)
  - Gateway: 172.20.0.1 (configurable)

- **internal**: Internal network for service-to-service communication
  - Driver: bridge
  - Internal: true (no external access)
  - Subnet: 172.21.0.0/16 (configurable)

### Custom Networks

You can add custom networks by extending the configuration in either:

- `main.tf` for Terraform-managed networks
- `docker-compose.yml` for Compose-managed networks

## Volume Management

### Volumes Created

- **app-data**: Application data storage
- **db-data**: Database persistent storage
- **cache-data**: Cache storage (Redis, etc.)
- **logs-data**: Application and service logs

### Volume Features

- **Automatic backups**: Configurable backup schedule
- **Retention policy**: Configurable backup retention
- **Health monitoring**: Volume usage monitoring
- **Restoration**: Easy volume restoration from backups

### Backup and Restore

#### Backup All Volumes

```bash
./scripts/backup.sh backup
```

#### Restore Specific Volume

```bash
./scripts/backup.sh restore /path/to/backup.tar.gz volume-name
```

#### List Available Backups

```bash
./scripts/backup.sh list
```

#### Clean Old Backups

```bash
./scripts/backup.sh cleanup
```

## Environment Variables

### Core Configuration

| Variable          | Description             | Default         |
| ----------------- | ----------------------- | --------------- |
| `PROJECT_NAME`    | Project identifier      | `geeksdata`     |
| `ENVIRONMENT`     | Environment name        | `dev`           |
| `NETWORK_SUBNET`  | Main network subnet     | `172.20.0.0/16` |
| `INTERNAL_SUBNET` | Internal network subnet | `172.21.0.0/16` |

### Backup Configuration

| Variable          | Description               | Default     |
| ----------------- | ------------------------- | ----------- |
| `BACKUP_ENABLED`  | Enable automatic backups  | `true`      |
| `BACKUP_SCHEDULE` | Cron schedule for backups | `0 2 * * *` |
| `RETENTION_DAYS`  | Days to retain backups    | `7`         |
| `TIMEZONE`        | Server timezone           | `UTC`       |

### Logging Configuration

| Variable       | Description            | Default     |
| -------------- | ---------------------- | ----------- |
| `LOG_DRIVER`   | Docker log driver      | `json-file` |
| `LOG_MAX_SIZE` | Maximum log file size  | `10m`       |
| `LOG_MAX_FILE` | Maximum log file count | `3`         |

## Health Checks

### Built-in Health Monitoring

- **Volume space monitoring**: Monitors disk usage every 5 minutes
- **Container health**: Basic container health checks
- **Network connectivity**: Network reachability tests

### Custom Health Checks

Add custom health checks by extending the `health-check` service in `docker-compose.yml`.

## Maintenance

### Regular Tasks

1. **Monitor volume usage**:

   ```bash
   docker volume ls
   docker system df
   ```

2. **Clean up unused resources**:

   ```bash
   docker system prune -a
   ```

3. **Verify backups**:

   ```bash
   ./scripts/backup.sh list
   ```

### Troubleshooting

#### Common Issues

1. **Network conflicts**:

   - Check for existing networks with same subnets
   - Modify subnet ranges in configuration

2. **Volume permission issues**:

   - Ensure proper volume mount permissions
   - Check container user permissions

3. **Backup failures**:
   - Verify backup directory permissions
   - Check available disk space
   - Review backup logs

#### Debug Commands

```bash
# View network details
docker network inspect docker-template-network

# Check volume usage
docker system df

# View container logs
docker-compose logs volume-backup
docker-compose logs health-check

# Check backup status
docker-compose exec volume-backup ls -la /data
```

## Extending the Infrastructure

### Adding New Volumes

1. **Terraform approach**:

   - Add new volume resource in `main.tf`
   - Update `variables.tf` with new configuration options
   - Add outputs for the new volume in `outputs.tf`

2. **Docker Compose approach**:
   - Add new volume definition in `docker-compose.yml`
   - Update services to use the new volume
   - Add environment variables if needed

### Adding New Networks

1. **Terraform approach**:

   - Add new network resource in `main.tf`
   - Update `variables.tf` with network configuration
   - Add outputs for the new network in `outputs.tf`

2. **Docker Compose approach**:
   - Add new network definition in `docker-compose.yml`
   - Configure services to use the new network

## Security Considerations

- **Internal network**: Use for sensitive service communication
- **Volume permissions**: Ensure proper file permissions
- **Backup encryption**: Consider encrypting backups
- **Network isolation**: Separate networks for different security levels
- **Access control**: Limit container capabilities

## Performance Optimization

- **Volume drivers**: Use appropriate volume drivers for your use case
- **Network performance**: Consider using `host` network for high-performance scenarios
- **Resource limits**: Set appropriate resource limits for containers
- **Monitoring**: Implement comprehensive monitoring and alerting

## Support

For issues or questions:

- Check the troubleshooting section
- Review container logs
- Verify environment configuration
- Test backup and restore procedures

