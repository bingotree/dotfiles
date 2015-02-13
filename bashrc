# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# SSH AGENT
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

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
