# N8N Application with Nginx

This directory contains the Docker configuration for running N8N (a workflow automation tool) with Nginx as a reverse proxy.

## Files Overview

- `docker-compose.yml` - Main Docker Compose file for N8N service
- `docker-compose.n8n.yml` - Extended configuration for N8N with additional services
- `.env.n8n.example` - Example environment variables for N8N configuration

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.n8n.example .env.n8n
   ```

2. Edit `.env.n8n` with your specific configuration values

3. Start the services:
   ```bash
   docker-compose up -d
   ```

## Services

- **N8N**: Workflow automation platform running on port 5678
- **Nginx**: Reverse proxy server (if configured)

## Configuration

Environment variables can be configured in the `.env.n8n` file. Key variables include:
- Database connection settings
- N8N basic authentication
- Webhook URLs
- Execution settings

## Access

Once running, N8N will be accessible at:
- Direct: http://localhost:5678
- Via Nginx: http://localhost (if Nginx is configured on port 80)