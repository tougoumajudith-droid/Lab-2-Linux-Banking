# Disk usage report script

#!/usr/bin/bash

files=("/data/finance" "/data/systemconfig" "/data/audit-logs")

for file in "${files[@]}"; do
    usage=$(du -sh "$file" | cut -f1)
    percent=$(df "$file" | tail -1 | awk '{print $5}' | tr -d '%')

    echo "Checking $file - size: $usage, disk usage: $percent%"

    if [ "$percent" -lt 30 ]; then
        echo "The remaining disk space is optimal"
    elif [ "$percent" -eq 30 ]; then
        echo "Warning! The disk space is almost full"
    else
        echo "The disk is out of space, action is required to support operational resilience"
    fi
done
