#!/bin/bash

# =============================================================================
# Synchronizer for media library
# use rsync
# =============================================================================

. ${MYSCRIPTLIB}/color_lib.sh
. ${MYSCRIPTLIB}/print_lib.sh

BASE_CMD="${MYSCRIPT}/media/dir_sync.sh"
MNT_POINT="/media/demonpi"
SHARE1="${MNT_POINT}/Share4T"
SHARE2="${MNT_POINT}/StorageS4T0"
STORAGE="/home/demonpi/Storage"
PIEXT="${MNT_POINT}/PiExtStorage"
BACKUP1="${MNT_POINT}/TM20T1"
BACKUP2="${MNT_POINT}/TM20T2"

if [ -z "$1" ]; then
    print_error "Usage: media_sync {c|i} {1|2|3|a(all)} [t]"
    exit 1
fi

if [ -n "$3" ]; then
    testmode="t"
else
    testmode=""
fi

if [ "$1" == "c" ]; then
    case "$2" in
        "1")
            ${BASE_CMD} ${BACKUP1}/Videos/MoviesA/01Share/ ${SHARE1}/MoviesC/ ${testmode}
            ;;
        "2")
            ${BASE_CMD} ${BACKUP1}/Videos/MoviesA/02Share/ ${SHARE2}/MoviesC/ ${testmode}
            ;;
        "3")
            ${BASE_CMD} ${BACKUP1}/Videos/SeriesA/ ${STORAGE}/Videos/SeriesP/ ${testmode}n ${STORAGE}/Videos/include_pattern.txt
            ;;
        "a"|"all")
            yes | ${BASE_CMD} ${BACKUP1}/Videos/MoviesA/01Share/ ${SHARE1}/MoviesC/ ${testmode} \
            && yes | ${BASE_CMD} ${BACKUP1}/Videos/MoviesA/02Share/ ${SHARE2}/MoviesC/ ${testmode} \
            && yes | ${BASE_CMD} ${BACKUP1}/Videos/SeriesA/ ${STORAGE}/Videos/SeriesP/ ${testmode}n ${STORAGE}/Videos/include_pattern.txt
            ;;
        *)
            print_error "Usage: media_sync {c|a} {1|2|a(all)} [t]"
            ;;
    esac
elif [ "$1" == "i" ]; then
    case "$2" in
        "1")
            ${BASE_CMD} ${PIEXT}/MoviesT1/ ${BACKUP1}/Videos/MoviesA/01Share i${testmode}
            ;;
        "2")
            ${BASE_CMD} ${PIEXT}/MoviesT2/ ${BACKUP1}/Videos/MoviesA/02Share i${testmode}
            ;;
        "3")
            ${BASE_CMD} ${PIEXT}/SeriesT/ ${BACKUP1}/Videos/SeriesA/ i${testmode}
            ;;
        "a"|"all")
            yes | ${BASE_CMD} ${PIEXT}/MoviesT1/ ${BACKUP1}/Videos/MoviesA/01Share i${testmode} \
            && yes | ${BASE_CMD} ${PIEXT}/MoviesT2/ ${BACKUP1}/Videos/MoviesA/02Share i${testmode} \
            && yes | ${BASE_CMD} ${PIEXT}/SeriesT/ ${BACKUP1}/Videos/SeriesA/ i${testmode}
            ;;
        *)
            print_error "Usage: media_sync {c|i} {1|2|3|a(all)} [t]"
            ;;
    esac
else
    print_error "Usage: media_sync {c|i} {1|2|3|a(all)} [t]"
fi
