# Colors
RED="\[\033[01;31m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[01;34m\]"
WHITE="\[\033[00m\]"

function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# User specific environment and startup programs
export PATH=$PATH:$HOME/bin
export PS1="$RED\u@\h$WHITE:$BLUE\w$WHITE($GREEN\$(parse_git_branch)$WHITE) \$ "
export SVN_EDITOR=vim
export CVSEDITOR=vim

# System specific environment variables
if [ -f ~/.bash_system_profile ]; then 
    . ~/.bash_system_profile 
fi

# screen -r -messes with scp

# User specific aliases
if [ -f ~/.bash_aliases ]; then 
    . ~/.bash_aliases 
fi

# System specific aliases
if [ -f ~/.bash_system_aliases ]; then 
    . ~/.bash_system_aliases 
fi

# User specific functions
if [ -f ~/.bash_library ]; then
    . ~/.bash_library
fi

# System specific functions
if [ -f ~/.bash_system_library ]; then
    . ~/.bash_system_library
fi

# System specific splash screen
if [ ${TERM} != "dumb" ]; then
 test -s ~/.bash_splash && . ~/.bash_splash
fi
