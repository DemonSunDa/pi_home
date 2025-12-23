#!/bin/bash

# =============================================================================
# Synchronizer for media library
# use rsync
# Arguments:
#   $1: source directory
#   $2: destination directory
#   $3: (optional) mode string
#       'i' - incremental mode (do not delete files in destination that are not in source)
#       't' - test mode (dry run, do not perform actual sync)
#       If no mode is provided, default is to delete files in destination that are not in source and log the operation.
# =============================================================================

. ${MYSCRIPTLIB}/color_lib.sh
. ${MYSCRIPTLIB}/print_lib.sh

SRC_DIR=$1
DEST_DIR=$2
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

if [[ ! -d "${SRC_DIR}" ]]; then
    print_error "Source path ${SRC_DIR} does not exist!" >&2
    exit 1
fi

if [[ ! -d "${DEST_DIR}" ]]; then
    print_error "Destination path ${DEST_DIR} does not exist!" >&2
    exit 1
fi

RSYNC_CMD="rsync -avh -P --progress"

if [ $# -eq 2 ]; then
    RSYNC_CMD="${RSYNC_CMD} --delete-before"
else
    if [[ ! "$3" =~ "i" ]]; then # increamental mode
        RSYNC_CMD="${RSYNC_CMD} --delete-before"
    fi
    if [[ "$3" =~ "t" ]]; then # test mode
        RSYNC_CMD="${RSYNC_CMD} --dry-run"
    else # log otherwise
        RSYNC_CMD="${RSYNC_CMD} --log-file=${MYLOGS}/dir_sync/dir_sync_${TIMESTAMP}.log"
    fi
    if [[ "$3" =~ "n" ]]; then # include from filelist only mode
        RSYNC_CMD="${RSYNC_CMD} --include-from=$4"
    fi
fi

RSYNC_CMD="${RSYNC_CMD} --exclude-from='${MYSCRIPTCFG}/dir_sync_exclude.txt'"
FULL_CMD="$RSYNC_CMD $SRC_DIR $DEST_DIR"

echo "================================================================================"
echo "Sync start: ${TIMESTAMP}"
echo -e "Running command: ${L_BOLD}${L_FNBLUE}$RSYNC_CMD${L_NC}"
echo -e "Source path: ${L_UL}${L_FNBLUE}$SRC_DIR${L_NC}"
echo -e "Destination path: ${L_UL}${L_FNBLUE}$DEST_DIR${L_NC}"
echo "================================================================================"

if read -t 10 -p "Sync ${SRC_DIR} to ${DEST_DIR}? [y/n]" choice; then
    echo
else
    echo
    print_error "Timeout!"
    exit 1
fi

if [ "${choice}" != "y" ]; then
    exit 1
fi

if ! eval ${RSYNC_CMD} "${SRC_DIR}/" "${DEST_DIR}/"; then
    print_warning "Sync may be incomplete!" >&2
    BACKUP_SUCCESS=false
else
    print_success "SYNC DONE!"
    BACKUP_SUCCESS=true
fi

# print_info "Start MD5 checking..."
# yes | ${MYSCRIPTLIB}/md5_gen.sh ${SRC_DIR} ${SRC_DIR}/../src_md5.txt
# print_info "MD5 of source generated"
# yes | ${MYSCRIPTLIB}/md5_gen.sh ${DEST_DIR} ${DEST_DIR}/../dest_md5.txt
# print_info "MD5 of destination generated"

# diff ${SRC_DIR}/../src_md5.txt ${DEST_DIR}/../dest_md5.txt
