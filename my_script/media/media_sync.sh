#!/bin/bash

# =============================================================================
# Synchronizer for media library
# use rsync
# =============================================================================

BASE_CMD="${MYSCRIPT}/media/dir_sync.sh"

if [ -z "$1" ]; then
    print_error "Usage: media_sync {1|2|a(all)} [t]"
    return 1
fi

if [ -n "$2" ]; then
    testmode="t"
else
    testmode=""
fi

case "$1" in
    "1")
        ${BASE_CMD} /media/demonpi/DavidsBook/Videos/MoviesA/01Share /media/demonpi/Share4T/MoviesC ${testmode}
        ;;
    "2")
        ${BASE_CMD} /media/demonpi/DavidsBook/Videos/MoviesA/02Share /media/demonpi/StorageS4T0/MoviesC ${testmode}
        ;;
    "a"|"all")
        yes | ${BASE_CMD} /media/demonpi/DavidsBook/Videos/MoviesA/01Share /media/demonpi/Share4T/MoviesC ${testmode} \
        && yes | ${BASE_CMD} /media/demonpi/DavidsBook/Videos/MoviesA/02Share /media/demonpi/StorageS4T0/MoviesC ${testmode}
        ;;
    *)
        print_error "Usage: media_sync {1|2|a(all)} [t]"
        ;;
esac
