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
alias lt="ls -lt"
alias mr="ls -1t | head -1"
alias unfunc="unset -f"
alias grepr="grep --color=always -Ersn $BGREP_EXCLUDE"
alias grepri="grep --color=always -Ersin $BGREP_EXCLUDE"
alias grepf="grep -Elrs $BGREP_EXCLUDE"
alias md='mkdir'
alias rc="source ~/.bashrc"
alias baliasedit="vs $BALIAS_FILES"
alias bfuncedit="vs $BFUNC_FILES"
alias benvedit="vs $BENV_FILES"
alias vlci="vlc -I ncurses"
alias pathedit="vi ~/.bash_profile"
alias errlog="tail -f $SYSTEM_ERROR_LOG"
alias swp='find . -name *.swp'
alias diff='diff -u'
alias vs='vi -O'
alias sp='vi -o'
alias ff='find . -type f -name'
alias ffi='find . -type f -iname'
alias fd='find . -type d -name'
alias fdi='find . -type d -iname'

alias tmux='tmux -2u'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias www="cd $WWW"
alias filesize="du -sh" #disk usage
alias npm-exec='PATH=$(npm bin):$PATH'
alias se="source $SSH_ENV"

# Git
alias git-='git checkout -'
alias gitb='git branch -a'
alias gitbr="git for-each-ref --sort=-committerdate refs/heads/ | head -10 | awk '{print $3}' | cut -d/ -f 3"
alias gitt='git status -uno'
alias gitd='git diff --no-prefix'
alias gitlogg='git log --name-status'

# yarn
alias yarnlist="( ls -l node_modules; ls -l node_modules/@* ) | grep ^l"

# cURL
alias mobile_curl='curl -v -A "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3"'
alias curl_agent='curl -v -A'

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
