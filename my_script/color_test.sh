#!/bin/bash

# 打印所有颜色的脚本

# 定义颜色变量
RESET='\033[0m'
BOLD='\033[1m'

# 函数：打印分隔线
print_separator() {
    echo -e "\n${BOLD}$1${RESET}"
    echo "=========================================="
}

# 函数：基本16色
print_basic_colors() {
    print_separator "基本16色 - 前景色"
    
    echo -e "默认: \033[39m示例文本\033[0m"
    for code in {30..37}; do
        echo -en "\033[${code}m  ${code}  \033[0m"
    done
    echo
    
    for code in {90..97}; do
        echo -en "\033[${code}m  ${code}  \033[0m"
    done
    echo
    
    print_separator "基本16色 - 背景色"
    
    echo -e "默认: \033[49m示例文本\033[0m"
    for code in {40..47}; do
        echo -en "\033[${code}m  ${code}  \033[0m"
    done
    echo
    
    for code in {100..107}; do
        echo -en "\033[${code}m  ${code}  \033[0m"
    done
    echo
    
    print_separator "文本属性"
    attributes=(
        "0:重置" "1:粗体" "2:暗淡" "3:斜体" 
        "4:下划线" "5:闪烁" "7:反显" "8:隐藏" "9:删除线"
    )
    
    for attr in "${attributes[@]}"; do
        code=${attr%%:*}
        desc=${attr#*:}
        if [[ $code -eq 5 ]]; then # 闪烁可能不受支持
            echo -en "\033[${code}m${desc}\033[0m "
        else
            echo -en "\033[${code}m${desc}\033[0m "
        fi
    done
    echo
}

# 函数：256色
print_256_colors() {
    print_separator "256色 - 前景色"
    
    echo "系统颜色 (0-15):"
    for code in {0..15}; do
        if [ $code -lt 10 ]; then
            echo -en "\033[48;5;${code}m  \033[0m\033[38;5;${code}m  ${code}  \033[0m"
        else
            echo -en "\033[48;5;${code}m  \033[0m\033[38;5;${code}m ${code}  \033[0m"
        fi
        if [ $(( (code + 1) % 8 )) -eq 0 ]; then
            echo
        fi
    done
    echo
    
    echo "216色立方 (16-231):"
    for code in {16..231}; do
        echo -en "\033[38;5;${code}m#\033[0m"
        if [ $(( (code - 15) % 36 )) -eq 0 ]; then
            echo
        fi
        if [ $(( (code - 15) % 6 )) -eq 0 ] && [ $(( (code - 15) % 36 )) -ne 0 ]; then
            echo -n " "
        fi
    done
    echo -e "\n"
    
    echo "灰度色 (232-255):"
    for code in {232..255}; do
        echo -en "\033[38;5;${code}m#\033[0m"
    done
    echo -e "\n"
    
    print_separator "256色 - 背景色示例"
    for code in {0..15}; do
        echo -en "\033[48;5;${code}m  ${code}  \033[0m"
        if [ $(( (code + 1) % 8 )) -eq 0 ]; then
            echo
        fi
    done
}

# 函数：真彩色测试
print_truecolor_test() {
    print_separator "真彩色 (RGB) 测试"
    
    echo "彩虹渐变:"
    for i in {0..79}; do
        r=$((255 - i * 255 / 80))
        g=$((i * 510 / 80))
        b=$((i * 255 / 80))
        
        if [ $g -gt 255 ]; then
            g=$((510 - g))
        fi
        
        echo -en "\033[48;2;${r};${g};${b}m \033[0m"
    done
    echo -e "\n"
    
    echo "红色渐变:"
    for i in {0..39}; do
        r=$((i * 255 / 39))
        echo -en "\033[48;2;${r};0;0m \033[0m"
    done
    echo -e "\n"
    
    echo "绿色渐变:"
    for i in {0..39}; do
        g=$((i * 255 / 39))
        echo -en "\033[48;2;0;${g};0m \033[0m"
    done
    echo -e "\n"
    
    echo "蓝色渐变:"
    for i in {0..39}; do
        b=$((i * 255 / 39))
        echo -en "\033[48;2;0;0;${b}m \033[0m"
    done
    echo
}

# 函数：颜色组合示例
print_color_combinations() {
    print_separator "颜色组合示例"
    
    # 前景色和背景色组合
    fg_colors=(31 32 33 34 35 36 91 92 93 94 95 96)
    bg_colors=(40 41 42 43 44 45 100 101 102 103 104 105)
    
    echo "前景色/背景色组合:"
    for fg in "${fg_colors[@]}"; do
        for bg in "${bg_colors[@]}"; do
            if [ $fg -ne $((bg + 60)) ] && [ $fg -ne $((bg - 10)) ]; then
                echo -en "\033[${fg};${bg}m TEST \033[0m"
            else
                echo -en "\033[${fg};${bg};1m TEST \033[0m" # 相同色系加粗
            fi
        done
        echo
    done
}

# 主函数
main() {
    echo -e "${BOLD}Bash 颜色测试脚本${RESET}"
    echo "终端类型: $TERM"
    echo "支持颜色数: $(tput colors)"
    
    print_basic_colors
    print_256_colors
    print_truecolor_test
    print_color_combinations
    
    print_separator "测试完成"
    echo -e "提示: ${BOLD}某些效果可能因终端而异${RESET}"
    echo -e "      闪烁、斜体等功能可能不被所有终端支持"
}

# 执行主函数
main