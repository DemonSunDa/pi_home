#!/bin/bash

# =============================================================================
# Generate MD5 for all files in target path, sort and save to file
# Usage: ./md5sum_script.sh [target_path] [output_file]
# =============================================================================

. ${MYSCRIPTLIB}/print_lib.sh

TARGET_DIR="${1:-.}" # target_path, default to current path
OUTPUT_FILE="${2:-md5sum.txt}" # output_file, default to md5sum.txt

check_directory() {
    if [[ ! -d "${TARGET_DIR}" ]]; then
        print_error "Illegal target_path: ${TARGET_DIR}"
        exit 1
    fi
}

check_permissions() {
    if [[ ! -r "${TARGET_DIR}" ]]; then
        print_error "Illegal permission: ${TARGET_DIR}"
        exit 1
    fi
}

check_md5sum() {
    if ! command -v md5sum &> /dev/null; then
        print_error "md5sum not found:"
        echo "  Ubuntu/Debian: sudo apt-get install coreutils"
        echo "  CentOS/RHEL: sudo yum install coreutils"
        exit 1
    fi
}

generate_md5sums() {
    local dir="$1"
    local output="$2"
    
    print_info "Scan: ${dir}"
    print_info "Output: ${output}"
    print_info "Start generating MD5 checksum..."
    
    find "${dir}" -type f -exec md5sum {} + | sort -k2 > "${output}"
    
    local file_count=$(wc -l < "${output}")
    
    print_info "Generated for $file_count in total."
}

verify_output() {
    local output_file="$1"
    
    if [[ ! -f "${output_file}" ]]; then
        print_error "Failed to output: ${output_file}"
        exit 1
    fi
    
    if [[ ! -s "${output_file}" ]]; then
        print_warning "Empty output, check if target_path contains any file"
    else
        print_success "MD5 checksum file generated: ${output_file}"
        print_info "Preview:"
        head -n 5 "${output_file}"
    fi
}

main() {

    echo "================================================================================"
    echo "MD5 checksum generate start: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================================================"
    
    check_directory
    check_permissions
    
    if [[ -f "${OUTPUT_FILE}" ]]; then
        print_warning "Output file exists: ${OUTPUT_FILE}"
        read -p "Overwrite? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cancelled"
            exit 0
        fi
    fi

    check_md5sum
    generate_md5sums "${TARGET_DIR}" "${OUTPUT_FILE}"
    verify_output "${OUTPUT_FILE}"
}

show_usage() {
    echo "Usage: $0 [target_path] [output_file]"
    echo "  target_path: default to current path"
    echo "  output_file: default to md5sum.txt"
    echo ""
    echo "Example:"
    echo "  $0 /home/user/documents my_md5.txt"
    echo "  $0 /path/to/folder"
    echo "  $0"
}

# main
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

main "$@"
