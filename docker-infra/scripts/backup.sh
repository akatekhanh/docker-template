#!/bin/bash

# Docker Volume Backup Script
set -euo pipefail

# Configuration
PROJECT_NAME="${PROJECT_NAME:-docker-template}"
BACKUP_DIR="${BACKUP_DIR:-/backups}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup a volume
backup_volume() {
    local volume_name=$1
    local backup_file="${BACKUP_DIR}/${volume_name}_${TIMESTAMP}.tar.gz"
    
    log "Starting backup of volume: $volume_name"
    
    if docker volume ls -q | grep -q "^${volume_name}$"; then
        if docker run --rm \
            -v "${volume_name}:/data" \
            -v "${BACKUP_DIR}:/backup" \
            alpine:latest tar -czf "/backup/${volume_name}_${TIMESTAMP}.tar.gz" -C /data .; then
            log "Successfully backed up $volume_name to $backup_file"
            
            # Verify backup
            if [ -f "$backup_file" ]; then
                local size=$(du -h "$backup_file" | cut -f1)
                log "Backup file size: $size"
            else
                error "Backup file not found: $backup_file"
                return 1
            fi
        else
            error "Failed to backup volume: $volume_name"
            return 1
        fi
    else
        warn "Volume not found: $volume_name"
        return 1
    fi
}

# Function to cleanup old backups
cleanup_old_backups() {
    log "Cleaning up backups older than $RETENTION_DAYS days"
    
    find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
    
    local remaining=$(find "$BACKUP_DIR" -name "*.tar.gz" -type f | wc -l)
    log "Cleanup completed. $remaining backup files remaining"
}

# Function to list all project volumes
list_volumes() {
    docker volume ls -q | grep "^${PROJECT_NAME}" || true
}

# Main backup process
main() {
    log "Starting backup process for project: $PROJECT_NAME"
    
    local volumes=$(list_volumes)
    
    if [ -z "$volumes" ]; then
        warn "No volumes found for project: $PROJECT_NAME"
        exit 0
    fi
    
    local backup_count=0
    local error_count=0
    
    while IFS= read -r volume; do
        if backup_volume "$volume"; then
            ((backup_count++))
        else
            ((error_count++))
        fi
    done <<< "$volumes"
    
    log "Backup process completed: $backup_count successful, $error_count failed"
    
    cleanup_old_backups
    
    if [ $error_count -gt 0 ]; then
        exit 1
    fi
}

# Function to restore from backup
restore_volume() {
    local backup_file=$1
    local volume_name=$2
    
    if [ ! -f "$backup_file" ]; then
        error "Backup file not found: $backup_file"
        return 1
    fi
    
    log "Restoring volume $volume_name from $backup_file"
    
    # Create volume if it doesn't exist
    if ! docker volume ls -q | grep -q "^${volume_name}$"; then
        log "Creating volume: $volume_name"
        docker volume create "$volume_name"
    fi
    
    # Restore from backup
    if docker run --rm \
        -v "${volume_name}:/data" \
        -v "$(dirname "$backup_file"):/backup" \
        alpine:latest tar -xzf "/backup/$(basename "$backup_file")" -C /data; then
        log "Successfully restored volume: $volume_name"
    else
        error "Failed to restore volume: $volume_name"
        return 1
    fi
}

# Function to list available backups
list_backups() {
    log "Available backups:"
    if [ -d "$BACKUP_DIR" ]; then
        ls -la "$BACKUP_DIR"/*.tar.gz 2>/dev/null || log "No backups found"
    else
        log "Backup directory does not exist: $BACKUP_DIR"
    fi
}

# Handle command line arguments
case "${1:-backup}" in
    backup)
        main
        ;;
    restore)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 restore <backup_file> <volume_name>"
            exit 1
        fi
        restore_volume "$2" "$3"
        ;;
    list)
        list_backups
        ;;
    cleanup)
        cleanup_old_backups
        ;;
    *)
        echo "Usage: $0 {backup|restore|list|cleanup}"
        echo "  backup  - Backup all project volumes"
        echo "  restore - Restore volume from backup"
        echo "  list    - List available backups"
        echo "  cleanup - Remove old backups"
        exit 1
        ;;
esac