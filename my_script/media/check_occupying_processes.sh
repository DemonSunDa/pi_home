#!/bin/bash

. ${MYSCRIPTLIB}/log_lib.sh

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
if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    log_fatal "Usage: $0 <mount_path> [<log_file>]"
    exit 1
fi

mount_path="$1"

##########################################
# Main Logic
##########################################
# 方法1: 使用 lsof 检查挂载点
processes=$(lsof +f -- "$mount_path" 2>/dev/null | grep -v "COMMAND" || true)

# 方法2: 使用 fuser 检查
if command -v fuser &> /dev/null; then
    fuser_processes=$(fuser -m "$mount_path" 2>/dev/null || true)
fi

if [[ -n "$processes" ]] || [[ -n "$fuser_processes" ]]; then
    log_info "Ocuppying processes found for $mount_path:"
    
    if [[ -n "$processes" ]]; then
        echo "$processes" | head -20
    fi
    
    if [[ -n "$fuser_processes" ]]; then
        log_info "Ocuppying processes found by fuser: $fuser_processes"
    fi

    exit 0  # 有占用进程
else
    log_info "No occupying processes for $mount_path."
    exit 1  # 无占用进程
fi
