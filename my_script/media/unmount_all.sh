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

. ${MYSCRIPTLIB}/log_lib.sh

if [ -z "$1" ]; then
    MNT_PATH="/media" # default mount path
else
    MNT_PATH="$1"
fi

##########################################
# Logger Setup
##########################################
if [ -n "$2" ]; then
    LOG_FILE="$2"
    set_log_file true "$LOG_FILE"
else
    set_log_file false ""
fi

set_log_level "INFO"
init_logger

##########################################
# Pre-checks
##########################################
if ! command -v ansifilter &> /dev/null; then
    log_fatal "ansifilter command not found. Please install ansifilter package."
    exit 1
fi

##########################################
# Main Logic
##########################################
log_start "Starting unmounting process..."

# stop samba services to avoid file locks
sudo systemctl stop smbd nmbd

${MYSCRIPT}/media/list_removable_disks.sh "$MNT_PATH" | while read -r line; do
# echo "/dev/sdb1 -> /media/demonpi/PiExtStorage" | while read -r line; do
    device=$(echo "$line" | awk '{print $1}')
    mount_point=$(echo "$line" | awk '{print $3}')

    log_info "Processing device: $device mounted on $mount_point"
    if ${MYSCRIPT}/media/check_occupying_processes.sh "$mount_point" "$LOG_FILE"; then
        log_warn "Occupying processes detected. Attempting to force kill..."
        ${MYSCRIPT}/media/force_kill_processes.sh "$mount_point"
        echo ""
    fi

    log_info "Attempting to unmount $device from $mount_point..."
    ${MYSCRIPT}/media/safe_unmount.sh "$device" "$mount_point" "$LOG_FILE"
done

# start samba services again
sudo systemctl start smbd nmbd

log_end "Unmounting process completed." 0
