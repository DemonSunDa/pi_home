#!/bin/bash

export MYLOGS="/home/demonpi/logs"
export MYSCRIPT="/home/demonpi/my_script"
export MYSCRIPTLIB="${MYSCRIPT}/lib"
export MYSCRIPTLOG="${MYSCRIPT}/log"

UPS_NAME="tgbox850"
MEDIA_PATH="/media/demonpi"

${MYSCRIPT}/ups/ups_checker.sh "$UPS_NAME" "$MEDIA_PATH"
