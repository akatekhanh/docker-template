# n8n Application Setup

## Architecture Overview

This n8n deployment uses a two-container architecture with Traefik as a reverse proxy:

### Components
- **Traefik**: Reverse proxy and SSL certificate management
  - Handles HTTPS termination and SSL certificate generation via Let's Encrypt
  - Routes traffic to n8n service based on subdomain
  - Provides security headers and redirects HTTP to HTTPS

- **n8n**: Workflow automation platform
  - Runs on port 5678 internally
  - Accessible via HTTPS on configured subdomain
  - Stores data in external Docker volume `n8n_data_2`

### Network Architecture
```
Internet ’ Traefik (:443) ’ n8n (:5678)
                “
            Let's Encrypt
                “
            SSL Certificates
```

### Security Features
- Automatic HTTPS redirect from HTTP to HTTPS
- Security headers (HSTS, XSS protection, content type sniffing prevention)
- SSL certificate auto-renewal via Let's Encrypt
- Container restart policies for high availability

## Prerequisites

- Docker and Docker Compose installed
- External Docker volumes created: `traefik_data` and `n8n_data_2`
- Domain name configured with DNS pointing to your server
- Environment variables configured (see below)

## Environment Variables

Create a `.env` file in the same directory as `docker-compose.yml`:

```bash
# Required
SUBDOMAIN=n8n
DOMAIN_NAME=yourdomain.com
SSL_EMAIL=your-email@domain.com
GENERIC_TIMEZONE=America/New_York

# Optional - customize as needed
```

## Quick Start

1. **Create external volumes** (first time only):
   ```bash
   docker volume create traefik_data
   docker volume create n8n_data_2
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

3. **Start the services**:
   ```bash
   docker-compose up -d
   ```

4. **Access n8n**:
   - Open `https://n8n.yourdomain.com` (replace with your subdomain and domain)
   - Complete the initial setup wizard

## Management Commands

```bash
# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Restart services
docker-compose restart

# Update n8n image
docker-compose pull n8n
docker-compose up -d n8n

# Backup data
docker run --rm -v n8n_data_2:/data -v $(pwd):/backup alpine tar czf /backup/n8n-backup.tar.gz /data
```

## Troubleshooting

### Common Issues

1. **SSL Certificate Issues**:
   - Ensure DNS is properly configured
   - Check firewall allows ports 80 and 443
   - Verify email address in SSL_EMAIL is valid

2. **Service Not Starting**:
   - Check logs: `docker-compose logs`
   - Verify external volumes exist: `docker volume ls`

3. **Port Conflicts**:
   - Ensure ports 80 and 443 are not in use by other services
   - Modify port mappings in docker-compose.yml if needed

### Health Checks

```bash
# Check service status
docker-compose ps

# Check if n8n is responding
curl -I https://n8n.yourdomain.com

# Check SSL certificate
curl -vI https://n8n.yourdomain.com 2>&1 | grep -i "SSL certificate"
```