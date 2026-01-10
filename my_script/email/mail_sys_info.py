#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import smtplib
import subprocess
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import os

# 配置信息
SMTP_SERVER = "smtp.qq.com"  # 替换为你的SMTP服务器
SMTP_PORT = 587
EMAIL_FROM = "1079891602@qq.com"
EMAIL_TO = "demonsd98@outlook.com"
EMAIL_PASSWORD = "xocfstwlqdoifijh"  # 或使用应用专用密码

def get_system_info():
    """获取系统信息"""
    try:
        # 获取主机名
        hostname = subprocess.check_output(['hostname']).decode().strip()

        # 获取系统负载
        uptime = subprocess.check_output(['uptime']).decode().strip()

        # 获取磁盘使用情况
        disk_usage = subprocess.check_output(['df', '-h']).decode()

        # 获取内存使用情况
        memory_info = subprocess.check_output(['free', '-h']).decode()

        # 获取供电状态
        with open(f"{os.getenv('MYSCRIPTLOG', '.')}/battery_status_full.txt", "r") as fi:
            power_status = "".join(fi.readlines())

        # 获取UPS状态
        ups_status = subprocess.check_output(['/bin/bash', f"{os.getenv('MYSCRIPT', '.')}/ups/ups_status_check.sh"]).decode()

        return hostname, uptime, disk_usage, memory_info, power_status, ups_status
    except Exception as e:
        return "Unknown", f"Error: {str(e)}", "Failed to gather system info", "Failed to gather system info"

def compose_email():
    """撰写邮件内容"""
    hostname, uptime, disk_usage, memory_info, power_status, ups_status = get_system_info()

    subject = f"DEMONPI System Monitoring Report - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
#     body = f"""
# System Monitoring Report

# {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
# Host: {hostname}
# Up Time: {uptime}

# Disk Usage:
# {disk_usage}

# Memory Info:
# {memory_info}

# Power Status：
# {power_status}

# UPS Status:
# {ups_status}

# This is an automated message from DEMONPI.
# """

    body = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">
                <table width="750" cellpadding="20" cellspacing="0">
                    <tr>
                        <td>
                            <h1 style="color: #333;">System Monitoring Report</h1>
                            <p>{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
                            <p>Host: {hostname}</p>
                            <p>Up Time: {uptime}</p>
                            <h2 style="color: #555;">Disk Usage:</h2>
                            <pre style="background-color: #f4f4f4; padding: 10px; border: 1px solid #ddd;">{disk_usage}</pre>
                            <h2 style="color: #555;">Memory Info:</h2>
                            <pre style="background-color: #f4f4f4; padding: 10px; border: 1px solid #ddd;">{memory_info}</pre>
                            <h2 style="color: #555;">Power Status：</h2>
                            <pre style="background-color: #f4f4f4; padding: 10px; border: 1px solid #ddd;">{power_status}</pre>
                            <h2 style="color: #555;">UPS Status:</h2>
                            <pre style="background-color: #f4f4f4; padding: 10px; border: 1px solid #ddd;">{ups_status}</pre>
                            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                            <p style="font-size: 12px; color: #999;">Automated message from DEMONPI.</p>
                            <p></p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
"""
    
    with open(f"{os.getenv('MYSCRIPTTMP', '.')}/system_monitoring_report.html", "w") as fi:
        fi.write(body)

    return subject, body

def send_email():
    """发送邮件"""
    # 创建邮件内容
    subject, body = compose_email()

    # 创建邮件对象
    msg = MIMEMultipart()
    msg['From'] = EMAIL_FROM
    msg['To'] = EMAIL_TO
    msg['Subject'] = subject

    # 添加邮件正文
    msg.attach(MIMEText(body, 'html', 'utf-8'))

    try:
        # 连接SMTP服务器并发送
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()  # 启用安全连接
        server.login(EMAIL_FROM, EMAIL_PASSWORD)
        server.send_message(msg)
        server.quit()
        print(f"Mail Successfully Sent: {datetime.now()}")
    except Exception as e:
        print(f"Failed to Send Mail: {str(e)}")

if __name__ == "__main__":
    send_email()
