#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import datetime

now = datetime.datetime.now()

os.system("python3 $MYSCRIPT/ups_hat_e/bat_mon.py -c 1 > $MYSCRIPTLOG/battery_status_full.txt")


with open(f"{os.getenv("MYSCRIPTLOG", ".")}/battery_status.log", "r") as fi:
    for line in fi:
        if line.startswith(">>>"):
            power_status = line.strip()

if (power_status[4] == "I") or (power_status[4] == "D") or (now.hour == 14):
    os.system("python3 $MYSCRIPT/email/mail_sys_info.py > $MYSCRIPTLOG/mail_sys_info.log")
