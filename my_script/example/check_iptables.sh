#!/bin/bash
echo "=== iptables 状态检查 ==="
echo "1. 服务状态:"
sudo systemctl is-active iptables 2>/dev/null || echo "服务未运行或使用其他防火墙"

echo -e "\n2. 各链默认策略:"
sudo iptables -L | grep "Chain"

echo -e "\n3. INPUT 链规则数量:"
sudo iptables -L INPUT --line-numbers | wc -l

echo -e "\n4. 当前规则概要:"
sudo iptables -L -n
