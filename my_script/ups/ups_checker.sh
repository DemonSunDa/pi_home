#!/bin/bash

. ${MYSCRIPTLIB}/log_lib.sh

if [ -z "$1" ]; then
    UPS_NAME="tgbox850" # default UPS name
else
    UPS_NAME="$1"
fi

##########################################
# Logger Setup
##########################################
LOG_FILE="${MYLOGS}/ups_${UPS_NAME}/ups_${UPS_NAME}_$(date +%Y-%m-%d).log"
mkdir -p "${MYLOGS}/ups_${UPS_NAME}"

set_log_level "INFO"
set_log_file true "$LOG_FILE"
init_logger

##########################################
# Pre-checks
##########################################
# Check if upsc command is available
if ! command -v upsc &> /dev/null; then
    log_fatal "upsc command not found. Please install nut package."
    exit 1
fi

# Check if UPS is connected
if ! upsc $UPS_NAME ups.status &> /dev/null; then
    log_fatal "Could not connect to UPS '$UPS_NAME'. Please check the UPS name and connection."
    exit 1
fi

##########################################
# Main Logic
##########################################
log_title "UPS Status Check for '$UPS_NAME'"

STATUS=$(upsc $UPS_NAME ups.status 2>/dev/null)
BATTERY=$(upsc $UPS_NAME battery.charge 2>/dev/null)
RUNTIME=$(upsc $UPS_NAME battery.runtime 2>/dev/null)
LOAD=$(upsc $UPS_NAME ups.load 2>/dev/null)

if [[ "$STATUS" == *"OB"* ]]; then # On Battery
    log_warn "UPS is on battery power!"
    # previously on AC
    if cat ${MYSCRIPTTMP}/ups_status.tmp 2>/dev/null | grep -q "A"; then
        log_info "Send warning email now."
        python3 ${MYSCRIPT}/email/auto_carrier.py -f
    fi
    echo "B" > ${MYSCRIPTTMP}/ups_status.tmp # mark as on Battery

    # critical level, initiate unmount and shutdown
    if [ $RUNTIME -lt 360 ] || [ $BATTERY -lt 20 ]; then
        log_warn "Battery running low!" | wall
        python3 ${MYSCRIPT}/email/auto_carrier.py -f
        log_warn "Unmounting media drives..." | wall
        ${MYSCRIPT}/media/unmount_all.sh
        # sudo shutdown -h +1 "System will shut down in 1 minute" | wall
    elif [ $RUNTIME -lt 720 ]; then
        log_warn "Battery runtime less than 10 minutes" | wall
        log_warn "Please save your work and prepare for shutdown" | wall
    fi
else # On AC power
    log_info "UPS is on AC power."
    echo "A" > ${MYSCRIPTTMP}/ups_status.tmp # mark as on AC
fi

if [ $LOAD -gt 80 ]; then
    log_warn "UPS load is over 80%"
fi
