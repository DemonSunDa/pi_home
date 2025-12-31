#!/bin/bash

export MYLOGS="/home/demonpi/logs"
export MYSCRIPT="/home/demonpi/my_script"
export MYSCRIPTLIB="${MYSCRIPT}/lib"
export MYSCRIPTLOG="${MYSCRIPT}/log"

# 激活 Conda 环境
source /home/demonpi/miniforge3/etc/profile.d/conda.sh
conda activate exp

# 执行 Python 脚本
python3 /home/demonpi/my_script/email/auto_carrier.py
