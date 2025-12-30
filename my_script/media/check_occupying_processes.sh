#!/bin/bash

. ${MYSCRIPTLIB}/print_lib.sh

if [ $# -ne 1 ]; then
    print_error "Usage: $0 <mount_path>"
    exit 1
fi

mount_path="$1"

# 方法1: 使用 lsof 检查挂载点
processes=$(lsof +f -- "$mount_path" 2>/dev/null | grep -v "COMMAND" || true)

# 方法2: 使用 fuser 检查
if command -v fuser &> /dev/null; then
    fuser_processes=$(fuser -m "$mount_path" 2>/dev/null || true)
fi

if [[ -n "$processes" ]] || [[ -n "$fuser_processes" ]]; then
    print_info "Ocuppying processes found for $mount_path:"
    
    if [[ -n "$processes" ]]; then
        echo "$processes" | head -20
    fi
    
    if [[ -n "$fuser_processes" ]]; then
        echo "Ocuppying processes found by fuser: $fuser_processes"
    fi

    exit 0  # 有占用进程
else
    print_info "No occupying processes for $mount_path."
    exit 1  # 无占用进程
fi
