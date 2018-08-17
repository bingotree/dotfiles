# System specific environment variables
if [ -f ~/.bash_system_profile ]; then 
    . ~/.bash_system_profile 
fi

# Foreground Colors
export BLACK="\033[0;30m"
export DGRAY="\033[1;30m"

export BLUE="\033[0;34m"
export LBLUE="\033[1;34m"

export GREEN="33[0;32m"
export LGREEN="\033[1;32m"

export CYAN="\033[0;36m"
export LCYAN="\033[1;36m"

export RED="\033[0;31m"
export LRED="\033[1;31m"

export PURPLE="\033[0;35m"
export LPURPLE="\033[1;35m"

export BROWN="\033[0;33m"
export YELLOW="\033[1;33m"

export LGRAY="\033[0;37m"
export WHITE="\033[1;37m"


# User specific environment variables
export PATH="$PATH:$HOME/bin:$HOME/bin/global-bin:$HOME/.bashrc.d/functions.bash/:usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:$(npm bin)"

# Prompt
type $HOME/bin/global-bin/parse_git_branch &> /dev/null
if [ $? -eq "0" ]; then
    export PS1="$BLUE\u$WHITE[\$($HOME/bin/global-bin/parse_git_icon)$WHITE]$YELLOW☀ $LBLUE\h$WHITE:$LGREEN\w$DGRAY<$PURPLE\$($HOME/bin/global-bin/parse_git_branch)$DGRAY>$RED∫ $WHITE"
else
    export PS1="$BLUE\u$YELLOW☀ $LBLUE\h$WHITE:$LBLUE\w$RED► $WHITE"
fi

export SVN_EDITOR=vim
export CVSEDITOR=vim
export VISUAL=vim
export EDITOR="$VISUAL"
export WWW="$HOME/www/sites"

if [ -f ~/.ssh/saveagent ]; then
    . ~/.ssh/saveagent
fi

# Source bashrc
if [ -f ~/.bashrc ]; then 
    . ~/.bashrc
fi
