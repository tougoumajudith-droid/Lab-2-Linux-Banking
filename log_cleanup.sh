#!/bin/bash

# This script verifies some important logs of  the regional bank , the compression of them and redirection of the compressed files to a centralized archive file .
# The target : auditd and PostgreSQL  

archive_dir="/data/bank_archives"
today=$(date +%Y-%m-%d)

# Bloc 1 : for PostgreSQL's logs 

find /var/lib/postgresql/18/main/log/ -name "*.log" -mtime +30 -exec gzip {} \;
sudo mv /var/lib/postgresql/18/main/log/*.gz "$archive_dir"/
if [ $? -eq 0 ]; then
    echo "echo PostgreSQL logs older than 30 days have been compressed and moved  to archive_dir"
else
    echo "Something went wrong"
fi

# Bloc 2 : for auditd's logs 

cp /var/log/audit/audit.log /var/log/audit/audit-"$today".log
sudo truncate -s 0 /var/log/audit/audit.log
gzip /var/log/audit/audit-"$today".log
sudo mv /var/log/audit/audit-"$today".log.gz "$archive_dir"/

echo "auditd log has been archived as $archive_dir/audit-$today.log.gz and audit.log has been reset"


find "$archive_dir" -name "*.gz" -mtime +30 -exec echo "Old archive found, review before deleting: {}" \;
