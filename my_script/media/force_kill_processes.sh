#!/bin/bash

. ${MYSCRIPTLIB}/print_lib.sh

if [ $# -ne 1 ]; then
    print_error "Usage: $0 <mount_path>"
    exit 1
fi

mount_path="$1"

# 使用 fuser 强制结束进程
if command -v fuser &> /dev/null; then
    fuser -k -m "$mount_path" 2>/dev/null && {
        sleep 2
        exit 0
    }
fi

# 使用 pkill 结束相关进程
if pgrep -f "$mount_path" > /dev/null 2>&1; then
    pkill -f "$mount_path" 2>/dev/null || true
    sleep 2
fi

# 最后尝试使用 killall
basename_mp=$(basename "$mount_path")
if pgrep -f "$basename_mp" > /dev/null 2>&1; then
    pkill -f "$basename_mp" 2>/dev/null || true
    sleep 2
fi

# 再次检查是否还有进程
if lsof +f -- "$mount_path" > /dev/null 2>&1; then
    print_error "Failed to kill all processes for $mount_path."
    exit 1
fi
