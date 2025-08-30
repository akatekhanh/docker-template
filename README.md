# N8N with Nginx Proxy Manager

This setup provides a Docker Compose configuration for running N8N alongside your existing nginx-proxy-manager.

## Quick Start

1. Copy the environment file and update the values:
   ```bash
   cp .env.n8n.example .env.n8n
   # Edit .env.n8n with your settings
   ```

2. Start N8N:
   ```bash
   docker-compose -f docker-compose.n8n.yml up -d
   ```

3. Configure nginx-proxy-manager:
   - Access nginx-proxy-manager admin at http://localhost:81
   - Add a new proxy host:
     - Domain: Set to your N8N_HOST value (e.g., n8n.localhost or your actual domain)
     - Scheme: http
     - Forward Hostname/IP: n8n
     - Forward Port: 5678
     - Enable WebSocket support

## Directory Structure

- `./n8n_data/` - N8N configuration and workflow data
- `./n8n_db_data/` - PostgreSQL database files for N8N

## Networks

- Uses existing `proxy-network` from nginx-proxy-manager
- Creates new `n8n-network` for internal N8N services

## Environment Variables

- `N8N_HOST`: The domain name for N8N (default: n8n.localhost)
- `GENERIC_TIMEZONE`: Timezone for N8N (default: America/New_York)
- `TZ`: System timezone (default: America/New_York)
- `POSTGRES_PASSWORD`: Database password for N8N PostgreSQL

## Access

After setup, access N8N at your configured domain (or http://n8n.localhost if using local development).