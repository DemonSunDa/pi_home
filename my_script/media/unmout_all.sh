#!/bin/bash

# =============================================================================
# Unmount all removable media safely
# relying on other scripts to handle processes and unmounting
# including:
#   list_removable_disks.sh
#   check_occupying_processes.sh
#   force_kill_processes.sh
#   safe_unmount.sh
# =============================================================================

. ${MYSCRIPTLIB}/print_lib.sh

MNT_PATH="/media/demonpi"

print_info "Starting unmounting process..."

# stop samba services to avoid file locks
sudo systemctl stop smbd nmbd

${MYSCRIPT}/media/list_removable_disks.sh "$MNT_PATH" | while read -r line; do
    device=$(echo "$line" | awk '{print $1}')
    mount_point=$(echo "$line" | awk '{print $3}')

    print_info "Processing device: $device mounted on $mount_point"
    if ${MYSCRIPT}/media/check_occupying_processes.sh "$mount_point"; then
        print_warning "Occupying processes detected. Attempting to force kill..."
        ${MYSCRIPT}/media/force_kill_processes.sh "$mount_point"
    fi

    print_info "Attempting to unmount $device from $mount_point..."
    ${MYSCRIPT}/media/safe_unmount.sh "$device" "$mount_point"
done

# start samba services again
sudo systemctl start smbd nmbd
