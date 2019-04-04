# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#	. /etc/bashrc
#fi

# SSH AGENT
export SSH_ENV="$HOME/.ssh/environment"
export BENV_FILES="$HOME/.bashrc.d/environment.bash $HOME/.bashrc.d/_system_environment.bash"
export BALIAS_FILES="$HOME/.bashrc.d/aliases.bash $HOME/.bashrc.d/_system_aliases.bash"
export BFUNC_FILES="$HOME/.bashrc.d/functions.bash $HOME/.bashrc.d/_system_functions.bash"
# TODO figure out how to get this in functions.
export BGREP_EXCLUDE='--exclude-dir={\.npm,\.git,\.svn,\.data,\.temp,node_modules} --exclude={tags,*\.pyc}'

# Order matters:
# - Environment vars
# - Functions
# - Aliases last
for f in $BENV_FILES; do if [ -f "$f" ]; then source $f; fi done
for f in $BFUNC_FILES; do if [ -f "$f" ]; then source $f; fi done
for f in $BALIAS_FILES; do if [ -f "$f" ]; then source $f; fi done

# Turn off flow control in order to use forward searching in readline
stty -ixon
