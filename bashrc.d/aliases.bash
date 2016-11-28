ls --color &> /dev/null
if [ $? -eq 0 ]; then
    alias la='ls -laF --color=auto'
    alias ll='ls -lF --color=auto'
    alias ls='ls -F --color=auto'
else
    alias la='ls -laFG'
    alias ll='ls -lFG'
    alias ls='ls -FG'
fi
alias lt="ls -lt"
alias mr="ls -1t | head -1"
alias rc="source ~/.bashrc"
alias grepr='grep --color=always -rs -n --exclude="*.svn*"'
alias grepri='grep -i --color=always -rs -n --exclude="*.svn*"'
alias grepn='grep -n '
alias grepf='grep -lrs --exclude="*.svn*" --exclude="^\.\/temp" --exclude="^\.\/data" --exclude="^\.\/\.git"'
alias svnm='svn status | grep "^M"'
alias svns='svn status | grep "^[^?]"'
alias md='mkdir'
alias balias="cat ~/.bashrc.d/aliases.bash; source ~/.bashrc.d/aliases.bash"
alias baliasedit="vi ~/.bashrc.d/aliases.bash"
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
alias gitt='git status -uno'
alias tmux='tmux -2u'
