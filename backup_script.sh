#!/bin/bash

# Backup directory
BACKUP_DIR="/usr/local/backup"
DB_BACKUP_DIR="$BACKUP_DIR/db_pingcrm"
LARAVEL_BACKUP_DIR="$BACKUP_DIR/laravel_pingcrm"

# Create backup directories if they don't exist
mkdir -p "$DB_BACKUP_DIR"
mkdir -p "$LARAVEL_BACKUP_DIR"

# Backup database
backup_database() {
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    BACKUP_FILE="$DB_BACKUP_DIR/db_pingcrm_$TIMESTAMP.tar.gz"

    # Dump database from container (example: MySQL)
    docker exec <mysql> mysqldump -u ${DB_USERNAME} -p ${DB_PASSWORD} ${DB_DATABASE} > /tmp/db_dump.sql

    # Compress the dump file into tar.gz
    tar -czf "$BACKUP_FILE" -C /tmp db_dump.sql

    # Remove the temporary dump file
    rm -f /tmp/db_dump.sql

    # Delete old backups (keep only the latest 5 backups)
    ls -t "$DB_BACKUP_DIR"/*.tar.gz | tail -n +6 | xargs rm -f
}

# Backup Laravel files
backup_laravel() {
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    BACKUP_FILE="$LARAVEL_BACKUP_DIR/laravel_backup_$TIMESTAMP.zip"

    # Compress the Laravel directory (example: /var/www/html)
    zip -r "$BACKUP_FILE" /var/www/html/pingcrm-dock

    # Delete old backups (keep only the latest 3 backups)
    ls -t "$LARAVEL_BACKUP_DIR"/*.zip | tail -n +4 | xargs rm -f
}

# Run backup functions
backup_database
backup_laravel

echo "Backup completed at $(date)"