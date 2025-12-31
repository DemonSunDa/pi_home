#!/bin/bash

export MYLOGS="/home/demonpi/logs"
export MYSCRIPT="/home/demonpi/my_script"
export MYSCRIPTCFG="${MYSCRIPT}/config"
export MYSCRIPTLIB="${MYSCRIPT}/lib"
export MYSCRIPTLOG="${MYSCRIPT}/log"
export MYSCRIPTTMP="${MYSCRIPT}/tmp"

# 激活 Conda 环境
source /home/demonpi/miniforge3/etc/profile.d/conda.sh
conda activate exp

UPS_NAME="tgbox850"
MEDIA_PATH="/media/demonpi"

${MYSCRIPT}/ups/ups_checker.sh "$UPS_NAME" "$MEDIA_PATH"
