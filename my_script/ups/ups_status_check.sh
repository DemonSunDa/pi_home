#!/bin/bash

if [ -z "$1" ]; then
    UPSNAME="tgbox850"
else
    UPSNAME="$1"
fi

if ! command -v upsc &> /dev/null; then
    echo "upsc command not found. Please install nut package."
    exit 1
fi

if ! upsc $UPSNAME ups.status &> /dev/null; then
    echo "Could not connect to UPS '$UPSNAME'. Please check the UPS name and connection."
    exit 1
fi

STATUS=$(upsc $UPSNAME ups.status 2>/dev/null)
BATTERY=$(upsc $UPSNAME battery.charge 2>/dev/null)
RUNTIME=$(upsc $UPSNAME battery.runtime 2>/dev/null)
LOAD=$(upsc $UPSNAME ups.load 2>/dev/null)

echo "Status: $STATUS"
echo "Battery Charge: $BATTERY%"
echo "Remaining Time: $(($RUNTIME/60)) minutes"
echo "Current Load: $LOAD%"
