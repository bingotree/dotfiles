# System specific environment variables
if [ -f ~/.bash_system_profile ]; then 
    . ~/.bash_system_profile 
fi

# Foreground Colors
BLACK="\[\033[0;30m\]"
DGRAY="\[\033[1;30m\]"

BLUE="\[\033[0;34m\]"
LBLUE="\[\033[1;34m\]"

GREEN="\[\033[0;32m\]"
LGREEN="\[\033[1;32m\]"

CYAN="\[\033[0;36m\]"
LCYAN="\[\033[1;36m\]"

RED="\[\033[0;31m\]"
LRED="\[\033[1;31m\]"

PURPLE="\[\033[0;35\]"
LPURPLE="\[\033[1;35\]"

BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"

LGRAY="\[\033[0;37m\]"
WHITE="\[\033[1;37m\]"


# User specific environment variables
export PATH=$PATH:$HOME/bin:$HOME/bin/global-bin:$HOME/.bashrc.d/functions.bash

export PS1="$RED\u@\h$WHITE:$LBLUE\w$DGRAY<$YELLOW\$(parse_git_branch)$DGRAY>$WHITE$ "
export SVN_EDITOR=vim
export CVSEDITOR=vim
export VISUAL=vim
export EDITOR="$VISUAL"
export WWW="$HOME/www/sites"

# Source bashrc
if [ -f ~/.bashrc ]; then 
    . ~/.bashrc
fi
