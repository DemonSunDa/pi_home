#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import datetime
import argparse

parser = argparse.ArgumentParser(description="Auto carrier script")
parser.add_argument("-f", "--force", action="store_true", help="Force send email")
args = parser.parse_args()

now = datetime.datetime.now()

os.system("python3 $MYSCRIPT/bat_hat_e/bat_mon.py -c 1 > $MYSCRIPTLOG/battery_status_full.txt")

with open(f"{os.getenv("MYSCRIPTTMP", ".")}/battery_status.tmp", "r") as fi: # written by bat_mon.py
    for line in fi:
        if line.startswith(">>>"):
            power_status = line.strip()

if (power_status[4] == "I") or (power_status[4] == "D") or (now.hour == 14) or (args.force):
    os.system("python3 $MYSCRIPT/email/mail_sys_info.py > $MYSCRIPTLOG/mail_sys_info.log")
