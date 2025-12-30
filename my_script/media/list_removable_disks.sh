#!/bin/bash

. ${MYSCRIPTLIB}/print_lib.sh

if [ $# -ne 1 ]; then
    print_error "Usage: $0 <mount_path>"
    exit 1
fi

mount_path="$1"

mounted_removable=$(mount | grep -E "/dev/sd[a-z][1-9]|/dev/nvme[0-9]+n[0-9]+p[1-9]" | grep "$mount_path" | awk '{print $1, "->", $3}' || true)

if [[ -z "$mounted_removable" ]]; then
    echo "No removable disks are currently mounted."
    exit 1
else
    echo "$mounted_removable"
    exit 0
fi
