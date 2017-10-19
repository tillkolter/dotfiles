# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='\[$(tput setaf 65)\]\u@\[$(tput setaf 245)\]\h:\[$(tput setaf 208)\]\w\[$(tput setaf 1)\]$(parse_git_branch)\[$(tput sgr0)\] $ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i
#'
alias vnv='source venv/bin/activate'
alias oye-front-update='~/.scripts/update-oye-front.sh'
alias oye-server-update='~/.scripts/update-oye-server.sh'

source ~/.autoenv/activate.sh

export LD_LIBRARY_PATH=/usr/lib

