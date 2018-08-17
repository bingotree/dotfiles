#!/bin/bash
# BASH comparison operators: http://tldp.org/LDP/abs/html/comparison-ops.html


    # TODO alphabetize by kind
    # domain, curl, nslookup_stuff
    function when_back_up() {
        domain="$1"
        for i in {1..10000}
        do
            d=$(domain_status $domain 1)
            if [ "$d" -lt "500" ]; then
                mail -s "$domain is back up" "$GIT_AUTHOR_EMAIL" <<< "$(date) $d"
                echo $d
                date
                return 0
            else
                echo "still $d"
            fi
        sleep 2
        done
    }
    function when_url_back_up() {
        url="$1"
        for i in {1..10000}
        do
            d=$(curl -s -g -k "$url" -D - -o /dev/null | head -1 | cut -f2 -d' ')
            if [ "$d" -lt "500" ]; then
                mail -s "$url is back up" "$GIT_AUTHOR_EMAIL" <<< "$(date) $d"
                echo $d
                date
                return 0
            else
                echo "still $d"
            fi
        sleep 25
        done
    }

    function domain_status() {
        domain="$1"
        statusCodeOnly="$2"
        real_domain=$(nslookup $domain | grep canonical | cut -f2 -d= | cut -f2 -d' ')

        # Print HTTP status if domain is pingable
        if [ "$statusCodeOnly" ]; then
            ping -c 1 $real_domain > /dev/null && curl -s -g -k "https://$real_domain" -D - -o /dev/null | head -1 | cut -f2 -d' '
        else
            ping -c 1 $real_domain > /dev/null && curl -s -g -k "https://$real_domain" -D - -o /dev/null
        fi
    }

    # misc
    function cleanup {
        for f in  $(find . -type f -iname *\.sw[mop]); do rm -i $f; done
        for f in  $(find . -type f -iname *\.orig); do rm -i $f; done
        for f in  $(find . -type f -iname *\.rej); do rm -i $f; done
    }
    function print_random_line {
        shuf -n 1 "$1"
    }
    function print_unicode_plane {
        for i in {0..255}
        do
            echo -e "$(print_unicode_block $1 $i)"
        done
    }
    function print_unicode_range {
        start=$(hex_to_int $1)
        stop=$(hex_to_int $2)
        for i in $(seq $start $stop)
        do
            printf  "u$(int_to_hex $i)\t\t\t\\u$(int_to_hex $i)\n"
        done
    }
    function print_unicode_block {
        # 256 blocks per plane ... so
        # address of first block = (2^8) * (plane - 1)
        local plane # integer in range 0-16
        local block # integer in range 0-255
        local first_block
        local block_address
        plane="$1"
        block="$2"
        let first_block=$(( 256*plane ))
        let block_address=$(( first_block+block ))
        for i in {0..255}
        do
            printf  "u$(int_to_hex $block_address)$(int_to_hex $i)\t\t\t\\u$(int_to_hex $block_address)$(int_to_hex $i)\n"
        done
    }
    function hex_to_int {
        printf "%d" "$1"
    }
    function int_to_hex {
        printf "%02x" "$1"
    }
    function int_to_unicode_string {
        hex=$(printf %02x "$1")
        # shellcheck disable=SC2059
        echo "\\u$hex"
    }
    function int_to_unicode {
        hex=$(printf %02x "$1")
        # shellcheck disable=SC2059
        printf "\\u$hex"
    }
    function int_to_ascii {
        local c
        c=$(printf %x "$1")
        # shellcheck disable=SC2059
        printf "\\x$c"
    }
    function ascii_to_int {
        printf "%d" "'$1"
    }
    function cutc {
        echo "$1" | awk '{$1=""; print $0 }'
    }
    # function bzip
    # alias for zipping files that is more intuitive (to me)
    # Simple syntax: bzip <filenames_or_glob> -t destination
    # Dependency: gnu getopt (so order of args don't matter)
    function bzip {
        local DESTINATION=''
        local FILES=''
        local VERBOSE=false
        while [ "$1" ]; do
            echo "arg: $1"
            if [ "$1" = '-o' ]; then
                DESTINATION="$2"
                shift 2
            elif [ "$1" = '-v' ]; then
                VERBOSE=true
                shift
            else
                FILES="$FILES $1"
                shift
            fi
        done
        if [ $VERBOSE ]; then
           echo "zip -R $DESTINATION $FILES"
        fi
        zip -R $DESTINATION $FILES
    }

    function phpl {
        php -l -ddisplay_errors=1 "$@"
    }
    # mv files and create intermediate directories if needed
    function mvp ()
    {
        for last; do true; done
            if [[ ! -e $last ]]; then
                mkdir -p $last
            fi
            mv $@
    }
    # Swap two files.
    function swap()         
    {
        local TMPFILE=tmp.$$
        mv "$1" $TMPFILE
        mv "$2" "$1"
        mv $TMPFILE "$2"
    }


    # GIT Functions
    # Dependencies: colordiff, patch
    export GIT_STASH=$HOME/.gitstash.patch

    function gitfm() {
        git show -c 'commit=$0 && branch=${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2'
    }
    # Remove untracked files with interactive prompt
    function gitrmu() {
        rm -i $(git status --porcelain | grep '^??' | cut -f2 -d' ' | xargs)
    }

    function gitlast() {
        git log --name-status --oneline HEAD^..HEAD
    }
    function gitstaged() {
        git diff --name-only --cached
    }
    # List files in the current directory by the time they were added to the git repo.
    function gitls() {
        for f
        do
            [[ -e $f ]] || break
            derp=$(git log  --format='%ai' "$f"  | tail -1)
            [[ -z "$derp" ]] || echo "$f $derp"
        done
    }
    function gitlst() {
        gitls "$@" | sort -t' ' -k2,4
    }

    # Checkout a branch from remote.
    function gitco() {
        if [ -z $1 ]
        then
            echo 'Usage: gitco <branch> ';
        else
            echo "git checkout -b $1 origin/$1"
            git checkout -b $1 origin/$1
        fi
    }
    # Checkout a feature branch from remote.
    function gitcof() {
        if [ -z $1 ]
        then
            echo 'Usage: gitco <feature-branch> ';
        else
            echo "git checkout -b feature/$1 origin/feature/$1"
            git checkout -b feature/$1 origin/feature/$1
        fi
    }
    function gitfresh() {
        if [ -z $1 ]
        then
            echo 'Usage: gitfresh <branch> ';
        else
            echo -n "Delete $1 and check out a new copy, are you sure? (y/n): "
            read ans
            if [ "$ans" != "y" ]; then 
                echo 'Aborting.'
                return
            fi
            git branch -D $1 
            git checkout -b $1 origin/$1
        fi
    }
    function gitsteamroll() {
        if [ -z $1 ]
        then
            echo 'Usage: gitsteamroll <branch> ';
        else
            echo -n "Delete $1 and fork a new $1 off the current branch, are you sure? (y/n): "
            read ans
            if [ "$ans" != "y" ]; then 
                echo 'Aborting.'
                return
            fi
            git branch -D $1 
            git checkout -b $1
        fi
    }

    # colorized, patchable diff.
    # Use --no-prefix to get the patch -p0 friendly output.
    function gitd () { git diff $@ | colordiff; }
    function gitdl () { git diff $@ | colordiff | less -R; }
    
    # Returns modified diff files
    function gitmod () { 
        git status --porcelain | grep -r '^\s*M' | cut -f 3 -d' '
    }

    # revert shortcut, prompts for file deletion, then updates.
    function gitrevert () { 
        echo -n "Run 'git checkout -- $@', are you sure? (y/n): "
        read ans
        if [ "$ans" != "y" ]; then 
            echo 'Aborting.'
            return
        fi
        git checkout -- $@
    }

    function gitstash () { 
        # TODO add an output file.
        # If no file arguments, stash all modified files.
        local count=$#;
        local modifiedFiles=$@;
        if [ -z "$1" ]; then
            local skip=0;
            let count=0;
            for file in $(git status -uno --porcelain | cut -f1,3 -d' '); do
                echo $file;
                if [ "$skip" -eq 1 ]; then
                    let skip=0
                elif [ "${file:0,0}" = "M" ]; then
                    let skip=1
                else
                    modifiedFiles[$count]=$file
                    let count=$count+1

                fi
            done;
        fi
        if [ "$count" -eq "0" ]; then
            echo "No files to stash !"
            return 1;
        fi

        gitd ${modifiedFiles[@]} > $GIT_STASH; echo -e "\n\nGIT STASH\n\n"; cat $GIT_STASH; gitrevert ${modifiedFiles[@]};
    }  
    function gitunstash () { patch -p1 < $GIT_STASH; }
    #    not set up --> function gitlastdiff() { cvs diff -u -r $(cvs log $1 | grep ^revision | head -n 2 | tail -n 1 | cut -c 10-) -r $(cvs log $1 | grep ^revision | head -n 1 | cut -c 10-) $1 | colordiff; }

    alias gitr=gitrevert
    alias gits=gitstash
    alias gitu=gitunstash
    alias gitc=gitcompare
#    alias gitld=cvslastdiff

    #Decode url encodings, either a file or a string.
    function url_decode() { 
        if [ -f $1 ];  then
            cat $1 | sed -e 's/+/ /g' | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e ; 
        else
            echo $1 | sed -e 's/+/ /g' | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e ; 
        fi
    }

    # Dependencies: perl with MHTML library.
    function htmlentity_decode() { 
        if [ -z "$2" ]; then
            cat $2 | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'
        else
            echo "$2" | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'
        fi
    }

    # Find a function.
    function ffunc() {
        if [ -z "$2" ]; then
            grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(\|\s*def\s*$1\s*" .;
        else
            grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(\|\s*def\s*$1\s*" $2;
        fi
    }
    # Find a js function
    function fjsfunc() {
        rgrep "$1\s*=\s*function\s*(" .;
    }
    # Find a class.
    function fclass() {
        if [ -z "$2" ]; then
            grepr "[cC]lass\s*$1" .;
        else
            grepr "[cC]lass\s*$1" $2;
        fi
    }

    # Kill a job with a given number.
    # You can also just use kill %<number>.
    function killjob () {
        output='Job(s) killed: ';
        jobs_killed='';
        for var in "$@"
        do
            if [ "$var" -gt "0" ]
            then
                if kill %$var 
                then
                    fg $var > /dev/null
                    jobs_killed="$jobs_killed $var";
                    output="$output $var";
                fi
            else
                echo "$var is not an integer."
            fi
            sleep 1
            echo $output
        done
    }
    alias kj=killjob

    # Combine all files in a directory into a single file (does not modify original files)
    function combine_all {
        if [ -z $1 ]
        then
            echo 'Usage: combine_all [path] <result_file_name>';
        else
            if [ ! -z $2 ]
            then
                DEST=$2;
                PATHNAME=$1;
            else
                DEST=$1
                PATHNAME=.
            fi
            for file in $( ls -1 $PATHNAME); 
            do
                echo $file
                if [ ! -d $file ]
                then
                    cat $file >> $DEST; 
                fi
            done
            echo "Success: file $DEST created."
        fi
    }

    # TODO remove, this is basically xargs
    function oneline {
        for i in "$@"; do
            echo -n "$i "
        done
        echo
    }
    function vsgrep {
       vim -O $(oneline $(grep -lrs --exclude="*.svn*\|^\.\/temp\|^\.\/data\|^\.\/\.git" "$@" . | grep -v "^Binary file\|*\.swp$"))
    }

    function vsgitlast {
        vim -O $(git log --name-only --oneline HEAD^..HEAD | awk 'NR > 1 { print }' | xargs)
    }
    function vsgitm {
        vim -O $(oneline $(git status --porcelain | grep '^ M' | cut -d' ' -f3))
    }
    function vsgitstaged {
        vim -O $(gitstaged)
    }
    
    function whocount {
        local NAME;
        for i in $(who | cut -f1 -d' ' | sort | uniq); do NAME=$i; echo " $NAME $(who | cut -f1 -d' '| sort | grep "$NAME" | wc -w)"; done;
    }
    function psucount {
        local NAME;
        for i in $(ps au | cut -f1 -d' ' | sort | uniq); do NAME=$i; echo " $NAME $(ps au | cut -f1 -d' '| sort | grep "$NAME" | wc -w)"; done;
    }
    function error_gen {
        awfije;
    }
    # DOCKER functions
    function dockerbash() {
        if [ -z $1 ]
        then
            echo 'Usage: dockerbash [containerID|containerName] ';
        else
            docker exec -i -t "$1" /bin/bash    
        fi
    }
    function dockerkillall() {
        docker ps | awk '{print $1}' | awk 'FNR > 1 {print}' | xargs docker kill
    }
    # GREP
    function grept() {
        grepf "$@" | xargs ls -lt | less
    }
