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
