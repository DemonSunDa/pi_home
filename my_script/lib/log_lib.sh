#!/bin/bash

# ============================================
# 简易日志函数库
# 版本: 1.0
# ============================================

# 日志级别常量
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3
readonly LOG_LEVEL_FATAL=4

# 日志级别名称
readonly LOG_LEVEL_NAMES=("DEBUG" "INFO" "WARN" "ERROR" "FATAL")

# ANSI颜色代码
readonly COLOR_RESET='\033[0m'
readonly COLOR_BLACK='\033[30m'
readonly COLOR_RED='\033[31m'
readonly COLOR_GREEN='\033[32m'
readonly COLOR_YELLOW='\033[33m'
readonly COLOR_BLUE='\033[34m'
readonly COLOR_MAGENTA='\033[35m'
readonly COLOR_CYAN='\033[36m'
readonly COLOR_WHITE='\033[37m'
readonly COLOR_BOLD='\033[1m'

# 默认配置
LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}     # 默认日志级别
LOG_TO_FILE=${LOG_TO_FILE:-false}           # 是否输出到文件
LOG_FILE=${LOG_FILE:-"${0%.*}.log"}         # 日志文件路径
LOG_COLORED=${LOG_COLORED:-true}            # 是否使用颜色
LOG_TIMESTAMP=${LOG_TIMESTAMP:-true}        # 是否显示时间戳
LOG_SHOW_LEVEL=${LOG_SHOW_LEVEL:-true}      # 是否显示日志级别
LOG_CALLER_INFO=${LOG_CALLER_INFO:-false}   # 是否显示调用者信息

# ============================================
# 内部函数
# ============================================

# 获取当前时间戳
_get_timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# 获取调用者信息
_get_caller_info() {
    if [ "$LOG_CALLER_INFO" = true ]; then
        local depth=${1:-2}
        if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
            echo "${BASH_SOURCE[$depth]}:${FUNCNAME[$depth]:-main}:${BASH_LINENO[$((depth-1))]}"
        else
            echo "line:${BASH_LINENO[$((depth-1))]}"
        fi
    fi
}

# 获取日志级别颜色
_get_level_color() {
    local level=$1
    case $level in
        $LOG_LEVEL_DEBUG) echo "$COLOR_CYAN" ;;
        $LOG_LEVEL_INFO)  echo "$COLOR_GREEN" ;;
        $LOG_LEVEL_WARN)  echo "$COLOR_YELLOW" ;;
        $LOG_LEVEL_ERROR) echo "$COLOR_RED" ;;
        $LOG_LEVEL_FATAL) echo "$COLOR_BOLD$COLOR_MAGENTA" ;;
        *) echo "$COLOR_RESET" ;;
    esac
}

# 写入日志文件
_write_to_file() {
    local message="$1"
    if [ "$LOG_TO_FILE" = true ]; then
        echo "$message" >> "$LOG_FILE"
    fi
}

# 核心日志函数
_log() {
    local level=$1
    local level_name=$2
    shift 2
    local message="$*"
    
    # 检查日志级别
    if [ $level -lt $LOG_LEVEL ]; then
        return 0
    fi
    
    # 构建日志前缀
    local prefix=""
    
    if [ "$LOG_TIMESTAMP" = true ]; then
        prefix="$(_get_timestamp) "
    fi
    
    if [ "$LOG_SHOW_LEVEL" = true ]; then
        prefix="${prefix}[$level_name] "
    fi
    
    if [ "$LOG_CALLER_INFO" = true ]; then
        prefix="${prefix}($(_get_caller_info 3)) "
    fi
    
    local formatted_msg="${prefix}${message}"
    local colored_msg=""
    
    # 添加颜色
    if [ "$LOG_COLORED" = true ] && [ -t 1 ]; then
        local color=$(_get_level_color $level)
        colored_msg="${color}${formatted_msg}${COLOR_RESET}"
    else
        colored_msg="$formatted_msg"
    fi
    
    # 输出到控制台
    if [ $level -ge $LOG_LEVEL_ERROR ]; then
        echo -e "$colored_msg" >&2
    else
        echo -e "$colored_msg"
    fi
    
    # 写入文件（不带颜色）
    _write_to_file "$formatted_msg"
}

# ============================================
# 公共日志函数
# ============================================

# 调试日志
log_debug() {
    _log $LOG_LEVEL_DEBUG "DEBUG" "$@"
}

# 信息日志
log_info() {
    _log $LOG_LEVEL_INFO "INFO" "$@"
}

# 警告日志
log_warn() {
    _log $LOG_LEVEL_WARN "WARN" "$@"
}

# 错误日志
log_error() {
    _log $LOG_LEVEL_ERROR "ERROR" "$@"
}

# 致命错误日志
log_fatal() {
    _log $LOG_LEVEL_FATAL "FATAL" "$@"
    exit 1
}

# 打印分隔线
log_separator() {
    local char=${1:-"="}
    local width=${2:-60}
    local line=$(printf "%${width}s" | tr " " "$char")
    _log $LOG_LEVEL_INFO "INFO" "$line"
}

# 打印标题
log_title() {
    local title="$1"
    local char=${2:-"="}
    local width=${3:-60}
    
    log_separator "$char" "$width"
    _log $LOG_LEVEL_INFO "INFO" "$title"
    log_separator "$char" "$width"
}

# 打印变量
log_var() {
    local var_name="$1"
    local var_value="${!var_name}"
    _log $LOG_LEVEL_DEBUG "DEBUG" "$var_name: $var_value"
}

# 开始任务日志
log_start() {
    local task="$1"
    _log $LOG_LEVEL_INFO "START" "Start: $task"
}

# 结束任务日志
log_end() {
    local task="$1"
    local status=${2:-0}
    if [ $status -eq 0 ]; then
        _log $LOG_LEVEL_INFO "END" "End: $task"
    else
        _log $LOG_LEVEL_ERROR "END" "Failed: $task (退出码: $status)"
    fi
}

# ============================================
# 配置函数
# ============================================

# 设置日志级别
set_log_level() {
    local level_name="$1"
    local level=-1
    
    for i in "${!LOG_LEVEL_NAMES[@]}"; do
        if [ "${LOG_LEVEL_NAMES[$i]}" = "$level_name" ]; then
            level=$i
            break
        fi
    done
    
    if [ $level -ge 0 ]; then
        LOG_LEVEL=$level # Set global log level
        log_info "Log level set to: $level_name ($level)"
    else
        log_error "Invalid log level: $level_name"
        return 1
    fi
}

# 启用/禁用文件日志
set_log_file() {
    local enabled=${1:-true}
    local file_path=${2:-}
    
    LOG_TO_FILE=$enabled
    if [ -n "$file_path" ]; then
        LOG_FILE="$file_path"
    fi
    
    if [ "$LOG_TO_FILE" = true ]; then
        # 创建日志文件目录
        local log_dir=$(dirname "$LOG_FILE")
        mkdir -p "$log_dir"
        
        log_info "File logging enabled: $LOG_FILE"
    else
        log_info "File logging disabled"
    fi
}

# 启用/禁用颜色输出
set_log_color() {
    LOG_COLORED=${1:-true}
    local status=$([ "$LOG_COLORED" = true ] && echo "enabled" || echo "disabled")
    log_info "Colored output ${status}"
}

# 显示当前配置
show_log_config() {
    log_title "Logger Configuration"
    log_var "LOG_LEVEL"
    log_var "LOG_TO_FILE"
    log_var "LOG_FILE"
    log_var "LOG_COLORED"
    log_var "LOG_TIMESTAMP"
    log_var "LOG_SHOW_LEVEL"
    log_var "LOG_CALLER_INFO"
}

# ============================================
# 初始化
# ============================================

# 检查环境
_check_environment() {
    if [ "$LOG_TO_FILE" = true ] && [ ! -w "$(dirname "$LOG_FILE")" ]; then
        echo "Error: Cannot write to log file directory: $(dirname "$LOG_FILE")" >&2
        LOG_TO_FILE=false
    fi
}

# 初始化日志系统
init_logger() {
    _check_environment
    log_info "Logger initialized"
    log_info "Script: $0"
    log_info "PID: $$"
    log_info "User: $(whoami)"
}

# 自动初始化（可选）
# init_logger

# ============================================
# 使用示例（取消注释测试）
# ============================================

# 测试函数
_test_logger() {
    log_title "开始测试日志系统"
    
    set_log_level "DEBUG"
    
    log_debug "这是一个调试信息"
    log_info "这是一个普通信息"
    log_warn "这是一个警告信息"
    log_error "这是一个错误信息"
    
    local test_var="Hello World"
    log_var "test_var"
    
    log_start "测试任务"
    sleep 0.1
    log_end "测试任务" 0
    
    log_separator "-"
    
    show_log_config
}

# 如果直接运行此脚本，则执行测试
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "正在测试日志库..."
    _test_logger
fi
