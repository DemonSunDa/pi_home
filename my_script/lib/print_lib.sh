#!/bin/bash

# =============================================================================
# Colorful printing
# =============================================================================

. ${MYSCRIPTLIB}/color_lib.sh

print_info() {
    echo -e "${L_FNBLUE}[INFO]${L_NC} $1"
}

print_success() {
    echo -e "${L_FNGREEN}[SUCCESS]${L_NC} $1"
}

print_warning() {
    echo -e "${L_FNYELLOW}[WARNING]${L_NC} $1"
}

print_error() {
    echo -e "${L_FNRED}[ERROR]${L_NC} $1"
}
