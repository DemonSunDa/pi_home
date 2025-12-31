#!/bin/bash

. ${MYSCRIPTLIB}/log_lib.sh

##########################################
# Logger Setup
##########################################
if [ -n "$3" ]; then
    LOG_FILE="$3"
    set_log_file true "$LOG_FILE"
else
    set_log_file false ""
fi

set_log_level "INFO"
init_logger

##########################################
# Pre-checks
##########################################
if [ $# -ne 2 ] && [ $# -ne 3 ]; then
    log_fatal "Usage: $0 <device> <mount_path> [<log_file>]"
    exit 1
fi

device="$1"
mount_path="$2"

##########################################
# Main Logic
##########################################
# 首先尝试正常卸载
if udisksctl unmount -b "$device" 2>/dev/null; then
    log_info "Unmounted $device successfully using udisksctl."
    exit 0
fi

# 如果失败，尝试强制卸载
log_warn "Normal unmount failed, attempting forced unmount of $device..."

if sudo umount -f "$mount_path" 2>/dev/null; then
    log_info "Forced unmount successful."
    exit 0
fi

# 最后尝试延迟卸载
if sudo umount -l "$mount_path" 2>/dev/null; then
    log_warn "Lazy unmount successful."
    exit 0
fi
