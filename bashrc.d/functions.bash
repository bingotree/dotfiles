#!/bin/bash

 # BASH comparison operators: http://tldp.org/LDP/abs/html/comparison-ops.html

    function phpl {
        php -l -ddisplay_errors=1 "$@"
    }
    function parse_git_branch {
      ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
      echo "${ref#refs/heads/}"
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

    # CVS Functions
    # Also check out cvstags in ~/bin for listing tags.
    # Dependencies: colordiff, patch
    export CVS_STASH=$HOME/.cvsstash.patch

    # colorized, patchable diff.
    function cvsd () { cvs diff -u $@ | colordiff; }
    function cvsdl () { cvs diff -u $@ | colordiff | less -R; }

    # revert shortcut, prompts for file deletion, then updates.
    function cvsrevert () { rm -i $@ | cvs update $@; }

    # Get patchable, colorized diff output between two revisions. 
    function cvscompare () {  
        if [ $# -lt 3 ]; then
            echo "Usage: cvscompare <tag1> <tag2> <files or path>";
            echo "Use cvstags -l to list all available tags.";
            return 1;
        fi
        rev1=$1; 
        rev2=$2; 
        shift 2; 
        cvs diff -N -c -u -r $rev1 -r $rev2 $@ | colordiff; 
    }

    function cvsstash () { cvsd $@ > $CVS_STASH; echo -e "\n\nCVS STASH\n\n"; cat $CVS_STASH; cvsrevert $@;}
    function cvsunstash () { patch -p0 < $CVS_STASH; }
    function cvslastdiff() { cvs diff -u -r $(cvs log $1 | grep ^revision | head -n 2 | tail -n 1 | cut -c 10-) -r $(cvs log $1 | grep ^revision | head -n 1 | cut -c 10-) $1 | colordiff; }


    alias cvsr=cvsrevert
    alias cvss=cvsstash
    alias cvsu=cvsunstash
    alias cvsc=cvscompare
    alias cvsld=cvslastdiff

    # GIT Functions
    # Dependencies: colordiff, patch
    export GIT_STASH=$HOME/.gitstash.patch

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
            grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(" .;
        else
            grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(" $2;
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
    # Dependencies: is_int
    function killjob () {
        output='Job(s) killed: ';
        jobs_killed='';
        for var in "$@"
        do
            if [ $(is_int $var) -eq "1" ]
            then
                if  kill %$var 
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

    function oneline {
        for i in $@; do
            echo -n "$i "
        done
        echo
    }
    function vsgrep {
       vim -O $(oneline $(grep -lrs --exclude="*.svn*\|^\.\/temp\|^\.\/data\|^\.\/\.git" "$@" . | grep -v "^Binary file\|*\.swp$"))
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
