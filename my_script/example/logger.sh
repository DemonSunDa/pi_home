#!/bin/bash

# 加载日志库
. ${MYSCRIPTLIB}/log_lib.sh

# 配置日志
set_log_level "DEBUG"
set_log_file true "${MYLOGS}/logger_example.log"
LOG_CALLER_INFO=true

# 初始化
init_logger

# 使用示例
log_title "应用程序启动"

log_info "开始处理数据..."

# 模拟数据处理
for i in {1..3}; do
    log_start "处理文件 $i"
    sleep 0.5
    
    if [ $i -eq 2 ]; then
        log_warn "文件 $i 有一些小问题"
    fi
    
    log_end "处理文件 $i" 0
done

# 错误处理示例
check_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        log_error "文件不存在: $file"
        return 1
    fi
    log_debug "文件检查通过: $file"
    return 0
}

log_info "检查必要文件..."
check_file "/etc/passwd"
check_file "/nonexistent/file"

# 致命错误
if [ $? -ne 0 ]; then
    log_fatal "关键文件缺失，程序退出"
fi

log_info "程序执行完成"
