# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

## Aqua
#PS1='\[\e[0;38;5;82m\]$ \[\e[0;38;5;45m\]\u \[\e[0;38;5;45m\](\[\e[0;38;5;39m\]\W\[\e[0;38;5;45m\]) \[\e[0;1;38;5;45m\]>\[\e[0m\]'
## Green
#PS1='\[\e[0;2;38;5;46m\]$ \[\e[0;2;38;5;46m\]\u \[\e[0;2;38;5;47m\](\[\e[0;1;38;5;46m\]\W\[\e[0;2;38;5;47m\]) \[\e[0;1;38;5;46m\]>\[\e[0m\]'
## Yellow blinking
#PS1='\[\e[0;2;5;38;5;226m\]$ \[\e[0;2;5;38;5;226m\]\u \[\e[0;2;5;38;5;214m\](\[\e[0;1;5;38;5;226m\]\W\[\e[0;2;5;38;5;214m\]) \[\e[0;1;5;38;5;226m\]>\[\e[0m\]'
## Block
#PS1='\[\e[0;4;53m\]\u\[\e[0;2;4;53m\]@\[\e[0;1;4;53m\]\w\[\e[0;1;4;53m\]>\[\e[0m\]'
## Red root
# PS1='\[\e[0;2;38;5;160m\]# \[\e[0;1;38;5;160m\]\u \[\e[0;1;38;5;160m\]~\[\e[0m\]'
## Server
#PS1='\[\e[0;2m\]$ \[\e[0m\]\u\[\e[0m\]@\[\e[0m\]$(ip route get 1.1.1.1 | awk -F"src " '"'"'NR==1{split($2,a," ");print a[1]}'"'"') \[\e[0m\](\[\e[0m\]\u\[\e[0m\]) \[\e[0;1m\]>\[\e[0m\]'
## Emoji
#PS1='\[\e[0m\]💰 \[\e[0m\]😀@💻 \[\e[0m\]➡️ \[\e[0m\]'
## Simple
#PS1='\[\e[0;2m\]\$ \[\e[0m\]\u\[\e[0;2m\]@\[\e[0m\]\h \[\e[0m\](\[\e[0m\]\W\[\e[0m\]) \[\e[0;1m\]~ \[\e[0m\]'
## Italic block
#PS1=' \[\e[0;2;3m\][ \[\e[0;2;3m\]\u \[\e[0;2;3m\]@ \[\e[0;1;3m\]\w \[\e[0;2;3m\]] \[\e[0m\]'
## Colors
#PS1='\[\e[0;2;38;5;226m\]\$ \[\e[0;1;38;5;154m\]\u \[\e[0;2;38;5;157m\]in \[\e[0;1;38;5;208m\]\W \[\e[0;38;5;43m\]> \[\e[0m\]'
## Mini
#PS1='\[\e[0;2m\]\$ \[\e[0;1m\]\w \[\e[0;1m\]> \[\e[0m\]'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################################################################
# PS1 with fancy_ps1.sh
################################################################
source ~/Documents/bashrc_script/fancy_ps1.sh
## Bash provides an environment variable called PROMPT_COMMAND.
## The contents of this variable are executed as a regular Bash command
## just before Bash displays a prompt.
## We want it to call our own command to truncate PWD and store it in NEW_PWD
PROMPT_COMMAND=bash_prompt_command

## Call bash_promnt only once, then unset it (not needed any more)
## It will set $PS1 with colors and relative to $NEW_PWD,
## which gets updated by $PROMT_COMMAND on behalf of the terminal
bash_prompt
# unset bash_prompt

################################################################
# DEMONPI SETTING
################################################################
export PATH=$PATH:/home/demonpi/.local/bin
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# Use Vi as defualt editor
export VISUAL=vi
export EDITOR="$VISUAL"
export SUDO_EDITOR="$VISUAL"

export MYSCRIPT="${HOME}/my_script"
export MYSCRIPTLIB="${MYSCRIPT}/lib"

alias sc="source ~/.bashrc"

alias svi="sudoedit"
alias smart0="sudo nvme smart-log /dev/nvme0n1"
alias media_sync="${MYSCRIPT}/dir_sync.sh /media/demonpi/DavidsBook/Videos/MoviesA/copied /media/demonpi/Share4T/MoviesC"

################################################################
# DEMONPI FUNCTION
################################################################
. ${MYSCRIPTLIB}/color_lib.sh
. ${MYSCRIPTLIB}/print_lib.sh

. ${MYSCRIPTLIB}/my_func_lib.sh

# Proxy with Clash-Verge
my_clash_verge_proxy="http://127.0.0.1:7897"

function set_proxy {
    export https_proxy=${my_clash_verge_proxy}
    export http_proxy=${my_clash_verge_proxy}

    echo "[Service]" > ~/proxy.conf
    echo "Environment=\"HTTP_PROXY=$my_clash_verge_proxy\"" >> ~/proxy.conf
    echo "Environment=\"HTTPS_PROXY=$my_clash_verge_proxy\"" >> ~/proxy.conf

    if [ ! -f "/etc/systemd/system/docker.service.d/proxy.conf" ];then
        update_docker_proxy=true
    elif ! $(cmp ~/proxy.conf /etc/systemd/system/docker.service.d/proxy.conf); then
        update_docker_proxy=true
    else
        update_docker_proxy=false
    fi

    if ${update_docker_proxy}; then
        sudo mv ~/proxy.conf /etc/systemd/system/docker.service.d/proxy.conf
        echo -e "${L_FNRED}RESTARTING DOCKER FOR PROXY${L_NC}"
        sudo systemctl daemon-reload
        sudo systemctl restart docker
    else
        rm ~/proxy.conf
    fi
}

function unset_proxy {
    unset https_proxy http_proxy
    sudo rm /etc/systemd/system/docker.service.d/proxy.conf
    echo -e "${L_FNRED}RESTARTING DOCKER${L_NC}"
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

################################################################
# DEMONPI STARTUP
################################################################
neofetch
set_proxy

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/demonpi/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/demonpi/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/demonpi/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/demonpi/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


################################################################
# Prompt theme with oh-my-posh
################################################################
case "$TERM" in
    xterm-color|*-256color) eval "$(oh-my-posh init bash  --config '~/Documents/omp_theme/mytheme.omp.json')";;
esac
