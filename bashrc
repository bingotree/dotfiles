# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#	. /etc/bashrc
#fi

# SSH AGENT
SSH_ENV="$HOME/.ssh/environment"

# Load any supplementary scripts
for config in "$HOME"/.bashrc.d/*.bash ; do
    source "$config"
done

# Turn off flow control in order to use forward searching in readline
stty -ixon
