#!/bin/bash

# =============================================================================
# Synchronizer for media library
# use rsync
# =============================================================================

SRC_DIR="/media/demonpi/DavidsBook/Videos/MoviesA/cop"
DEST_DIR="/media/demonpi/Share4T/MoviesC"

if [[ ! -d "$SRC_DIR" ]]; then
    echo -e "\e[1;31mERROR: Source path ${SRC_DIR} does not exist!\e[0m" >&2
    exit 1
fi

if [[ ! -d "$DEST_DIR" ]]; then
    echo -e "\e[1;31mERROR: Destination path ${DEST_DIR} does not exist!\e[0m" >&2
    exit 1
fi


if [ $# -eq 0 ]; then
    RSYNC_CMD="rsync -avh -P --progress --delete"
else
    RSYNC_CMD="rsync -avh -P --progress --dry-run --delete"
fi

FULL_CMD="$RSYNC_CMD $SRC_DIR $DEST_DIR"

echo "================================================================================"
echo "Sync start: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "Running command: \e[1;34m$RSYNC_CMD\e[0m"
echo -e "Source path: \e[4;34m$SRC_DIR\e[0m"
echo -e "Destination path: \e[4;34m$DEST_DIR\e[0m"
echo "================================================================================"

if ! eval ${RSYNC_CMD} "${SRC_DIR}/" "${DEST_DIR}/"; then
    echo -e "\e[1;33mWARNING: Sync may be incomplete!\e[0m" >&2
    BACKUP_SUCCESS=false
else
    echo -e "\e[1;32mSYNC DONE!\e[0m"
    BACKUP_SUCCESS=true
fi
