#!/bin/bash

L_NC='\e[0m'
L_FNBLACK='\e[30m'
L_FNRED='\e[31m'
L_FNGREEN='\e[32m'
L_FNYELLOW='\e[33m'
L_FNBLUE='\e[34m'
L_FNMAGENTA='\e[35m'
L_FNCYAN='\e[36m'
L_FNWHITE='\e[37m'
L_FLBLACK='\e[90m'
L_FLRED='\e[91m'
L_FLGREEN='\e[92m'
L_FLYELLOW='\e[93m'
L_FLBLUE='\e[94m'
L_FLMAGENTA='\e[95m'
L_FLCYAN='\e[96m'
L_FLWHITE='\e[97m'

L_BNBLACK='\e[40m'
L_BNRED='\e[41m'
L_BNGREEN='\e[42m'
L_BNYELLOW='\e[43m'
L_BNBLUE='\e[44m'
L_BNMAGENTA='\e[45m'
L_BNCYAN='\e[46m'
L_BNWHITE='\e[47m'
L_BLBLACK='\e[100m'
L_BLRED='\e[101m'
L_BLGREEN='\e[102m'
L_BLYELLOW='\e[103m'
L_BLBLUE='\e[104m'
L_BLMAGENTA='\e[105m'
L_BLCYAN='\e[106m'
L_BLWHITE='\e[107m'

L_BOLD='\e[1m'
L_DIM='\e[2m'
L_ITALIC='\e[3m'
L_UL='\e[4m'
L_BLINK='\e[5m'
L_REVERSE='\e[7m'
L_HIDE='\e[8m'
L_DELETE='\e[9m'

c256_palatte() {
    for i in {0..255}; do
        printf "\e[48;5;%sm%3d\033[0m " "$i" "$i"
        if (( (i + 1) % 16 == 0 )); then
            echo
        fi
    done

    echo "Format with '\e[48;5;{code}m'"
}
