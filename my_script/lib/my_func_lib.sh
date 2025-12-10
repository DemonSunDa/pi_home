#!/bin/bash

# Show IP
function myip {
    echo "Internal IP: $(hostname -I | awk '{print $1}')"
    echo "External IP: $(curl -s ifconfig.me)"
}

# Connection test
function pingg {
    ping -c 5 8.8.8.8
}

function pingc {
    curl -I https://google.com
}

# Make backup
function backup {
    if [ -z "$1" ]; then
        echo "Usage: backup <filename>"
        return 1
    fi
    cp "$1" "$1.bak"
    echo "Backup created: $1.bak"
}

# Extract
function extract {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    
    case "$1" in
        *.tar.gz)  tar -xzf "$1" ;;
        *.tar.bz2) tar -xjf "$1" ;;
        *.tar.xz)  tar -xJf "$1" ;;
        *.tar)     tar -xf "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.zip)     unzip "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.7z)      7z x "$1" ;;
        *)         echo "Unknown archive format: $1" ;;
    esac
}

# Clor palatte
function color_palatte {
    for x in {0..8}; do 
        for i in {30..37}; do 
            for a in {40..47}; do 
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
            done
            echo
        done
    done
    echo ""
}

# Helper to check yt-dlp installation
function check_yt_dlp {
    if ! command -v yt-dlp >/dev/null 2>&1; then
        echo "yt-dlp is not installed. Please install it first."
        return 1
    fi
    return 0
}

# yt-dlp
function ytd_aud {
    if [ -z "$1" ]; then
        echo "Usage: ytd_aud <url>"
        return 1
    fi

    check_yt_dlp || return 1

    if [ -n "$https_proxy" ]; then
        echo "Using proxy: $https_proxy"
        yt-dlp --proxy http://127.0.0.1:7897 \
            --no-check-certificate \
            --output "%(title)s.%(ext)s" \
            --embed-thumbnail \
            --add-metadata \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality 320K \
            "$1"
    else 
        echo "No proxy set. Proceeding without proxy."
        yt-dlp --no-check-certificate \
            --output "%(title)s.%(ext)s" \
            --embed-thumbnail \
            --add-metadata \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality 320K \
            "$1"
    fi

    echo "[Done]"
}

function ytd_vid {
    if [ -z "$1" ]; then
        echo "Usage: ytd_aud <url>"
        return 1
    fi

    check_yt_dlp || return 1

    if [ -n "$https_proxy" ]; then
        echo "Using proxy: $https_proxy"
        yt-dlp --proxy http://127.0.0.1:7897 \
            --no-check-certificate \
            --output "%(title)s.%(ext)s" \
            --embed-thumbnail \
            --add-metadata \
            --merge-output-format mp4 \
            "$1"
    else 
        echo "No proxy set. Proceeding without proxy."
        yt-dlp --no-check-certificate \
            --output "%(title)s.%(ext)s" \
            --embed-thumbnail \
            --add-metadata \
            --merge-output-format mp4 \
            "$1"
    fi

    echo "[Done]"
}
