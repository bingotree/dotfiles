balias_grep_exclude_pattern='--exclude-dir={\.git,\.svn,\.data,\.temp} --exclude=tags'

ls --color &> /dev/null
if [ $? ]; then
    alias la='ls -laFG'
    alias ll='ls -lFG'
    alias ls='ls -FG'
else
    alias la='ls -laF --color=auto'
    alias ll='ls -lF --color=auto'
    alias ls='ls -F --color=auto'
fi
alias a="tmux attach"
alias e="echo"
alias lt="ls -lt"
alias mr="ls -1t | head -1"
alias rc="source ~/.bashrc"
alias grepr="grep --color=always -rsn $balias_grep_exclude_pattern"
alias grepri="grep --color=always -rsin $balias_grep_exclude_pattern"
alias grepn="grep -n $balias_grep_exclude_pattern"
alias grepf="grep -lrs $balias_grep_exclude_pattern"
alias svnm='svn status | grep "^M"'
alias svns='svn status | grep "^[^?]"'
alias md='mkdir'
alias balias="cat ~/.bashrc.d/aliases.bash; source ~/.bashrc.d/aliases.bash"
alias baliasedit="vi ~/.bashrc.d/aliases.bash"
alias bfunc="cat ~/.bashrc.d/functions.bash; source ~/.bashrc.d/functions.bash"
alias bfuncedit="vi ~/.bashrc.d/functions.bash"
alias bps="ps -aux | grep $(whoami)"
alias sd="DS=`pwd`"
alias sdd="DSS=`pwd`"
alias ds="cd $DS"
alias dss="cd $DSS"
alias vlci="vlc -I ncurses"
alias pathedit="vi ~/.bash_profile"
alias errlog="tail -f $PHP_LOG"
alias swp='find . -name *.swp'
alias diff='diff -u'
alias vs='vi -O'
alias sp='vi -o'
alias ff='find . -type f -name'
alias ffi='find . -type f -iname'
alias fd='find . -type d -name'
alias fdi='find . -type d -iname'
alias gitb='git branch -a'
alias gitbr="git for-each-ref --sort=-committerdate refs/heads/ | head -10 | awk '{print $3}' | cut -d/ -f 3"
alias gitt='git status -uno'
alias gitlogg='git log --name-status'
alias gitzip="bzip $(oneline $(git status --porcelain | grep -v 'git\.stash' | awk '/^.../ { print $2, $3 }' )) -o git.stash.$(date -I).zip "
alias tmux='tmux -2u'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias www="cd $WWW"
alias filesize="du -sh" #disk usage
alias npm-exec='PATH=$(npm bin):$PATH'

# Docker.
alias dockervm='docker-machine ls'
alias dockerimages='docker images'
alias dockercontainers='docker ps'
alias dockerls='docker ps'
alias dockerstart='docker run -d'
alias dockerlogs='docker logs'
alias dockerstop='docker stop'
alias dockerbuild='docker build .'
alias dockercompose='docker-compose up'
alias dockerexec='docker exec -i -t ' # /bin/bash'
