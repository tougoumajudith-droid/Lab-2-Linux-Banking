#!/bin/bash
# The script performs a database backup 

backup_dir="/data/db_backups"
today=$(date +%Y-%m-%d)
sudo -u postgres pg_dump bank_db > "$backup_dir/bank_db_backup_$today.sql"
if [ $? -eq 0 ]; then
    echo "Database backup completed successfully: $backup_dir/bank_db_backup_$today.sql"
else
    echo "ERROR: Database backup failed"
fi
