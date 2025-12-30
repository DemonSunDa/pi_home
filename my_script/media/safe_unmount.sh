#!/bin/bash

. ${MYSCRIPTLIB}/print_lib.sh

if [ $# -ne 2 ]; then
    print_error "Usage: $0 <device> <mount_path>"
    exit 1
fi

device="$1"
mount_path="$2"

# 首先尝试正常卸载
if udisksctl unmount -b "$device" 2>/dev/null; then
    print_info "Unmounted $device successfully using udisksctl."
    exit 0
fi

# 如果失败，尝试强制卸载
print_warning "Normal unmount failed, attempting forced unmount of $device..."

if sudo umount -f "$mount_path" 2>/dev/null; then
    print_info "Forced unmount successful."
    exit 0
fi

# 最后尝试延迟卸载
if sudo umount -l "$mount_path" 2>/dev/null; then
    print_warning "Lazy unmount successful."
    exit 0
fi
