#!/bin/bash
# BASH comparison operators: http://tldp.org/LDP/abs/html/comparison-ops.html

# Format
# - loosely grouped by categories
# - functions starting with '_' are typically oneshot functions
#     that have no use other than within other functions
#     in essence, you would rarely if ever call them from the command line

# SEARCHING - Find and GREP
# FIND
# Find a function.
function ffunc {
    if [ -z "$2" ]; then
        grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(\|\s*def\s*$1\s*" .;
    else
        grepr "$1[ \"']*[:=]\s*function\|function\s*&\?\s*$1\s*(\|\s*def\s*$1\s*" $2;
    fi
}

# Find a js function
function fjsfunc {
    rgrep "$1\s*=\s*function\s*(" .;
}

# Find a class.
function fclass {
    if [ -z "$2" ]; then
        grepr "[cC]lass\s*$1" .;
    else
        grepr "[cC]lass\s*$1" $2;
    fi
}
# GREP
# based on time - latest
function grept {
    grepf "$@" | xargs ls -lt | less
}


# MATH helpers
function roll_die {
    local n_sides=$1
    echo $(($RANDOM % $n_sides + 1))
}

function to_percent {
   local num=$1
   bc <<< "scale = 2; ($num*100)/1"
}

# Difference between numbers
function abs_diff {
    local num1=$1
    local num2=$2
    bc <<< "scale = 4; $num1 - $num2"
}

function rel_diff {
    local num1=$1
    local num2=$2
    bc <<< "scale = 4; $num1/$num2"
}

function rel_change {
    local num1=$1
    local num2=$2
    bc <<< "scale = 4; $(abs_diff $num1 $num2)/$num2"
}

function num_diff {
    local num1=$1
    local num2=$2

    ad_1=$(abs_diff $num1 $num2)
    rd_1=$(to_percent $(rel_diff $num1 $num2))
    rc_1=$(to_percent $(rel_change $num1 $num2))

    ad_2=$(abs_diff $num2 $num1)
    rd_2=$(to_percent $(rel_diff $num2 $num1))
    rc_2=$(to_percent $(rel_change $num2 $num1))
    echo "$num1 - $num2 = $ad_1"
    echo "$num2 - $num1 = $ad_2"
    echo "$num1 / $num2 = $rd_1%"
    echo "$num2 / $num1 = $rd_2%"
    echo "($num1 - $num2) / $num2 = $rc_1%, $num1 <increases/decreases> $num2 by $rc_1%"
    echo "($num2 - $num1) / $num1 = $rc_2%, $num2 <increases/decreases> $num1 by $rc_2%"
}

# BASH utilities - making scripting and piping easier
# TODO remove this and dependencies, this is basically xargs
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
function oneline {
    for i in "$@"; do
        echo -n "$i "
    done
    echo
}

function error_gen {
    awfije;
}

# `skip_head 2 <filename>` skips the first two lines of <filename>
# `skip_tail 2 <filename>` skips the last two lines of a file
function head_skip {
    N="$1"
    file="$2"
    tail -n +$N "$file"
}

function tail_skip {
    N="$1"
    file="$2"
    head -n -$N "$file"
}

# lines prints a range of lines, starting from start params
# start - the first line to print
# n_lines - the total number of lines to print
# `lines 3 5 <filename>` print 5 lines from <filename> starting at line 3
function lines {
    start="$1"
    let n_lines="$2"
    file="$3"
    skip_head $start $file  | head -$n_lines
}


# PROCESSES, JOBS and USERS
function whocount {
    local NAME;
    for i in $(who | cut -f1 -d' ' | sort | uniq); do NAME=$i; echo " $NAME $(who | cut -f1 -d' '| sort | grep "$NAME" | wc -w)"; done;
}

function psucount {
    local NAME;
    for i in $(ps au | cut -f1 -d' ' | sort | uniq); do NAME=$i; echo " $NAME $(ps au | cut -f1 -d' '| sort | grep "$NAME" | wc -w)"; done;
}

# Kill a job with a given number.
# You can also just use kill %<number>.
function kj  {
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
            else
                output=""
            fi
        else
            echo "$var is not an integer."
        fi
        sleep 1
        echo $output
    done
}

# awk format
function _af {
    # TODO handle no args.
    arg=$(implode ', $' "$@")
    echo "'{print \$$arg}'"
}

# Shortcut for awk so I don't have to type `awk 'print {$1 $2}'` etc
# e.g)  ls -l | bawk 4 8 | sort -s
function bawk {
    val=$(_af "$@")
    eval "awk $val"
}

function print_array {
    name=$1[@]
    arr=("${!name}")
    for e in "${arr[@]}"; do echo $e; done
}

# string implode
function implode {
    local d=$1;
    shift;
    echo -n "$1";
    shift;
    printf "%s" "${@/#/$d}";
}

# single char implode
function char_implode {
    local IFS="$1"; shift; echo "$*";
}


# FORMATTING FILES CONVERSION
# TODO not just files
# IMAGE
# Dependency - base64
function imgfile_to_base64 {
    local file="$1"
    local converted=$(base64 -w0 "$file")
    echo $converted
}

function imgfile_to_base64_html {
    local file="$1"
    local mime=$(mime "$file")
    local data=$(img_to_base64 "$file")
    echo "<img src='data:$mime;base64,$data'/>"
}

function cleanup {
    for f in  $(find . -type f -iname *\.sw[mop]); do rm -i $f; done
    for f in  $(find . -type f -iname *\.orig); do rm -i $f; done
    for f in  $(find . -type f -iname *\.rej); do rm -i $f; done
}

# Removes the eof marker from the end of all arguments
# e.g.  chomp_eof file.txt
function chomp_eof {
    perl -p -e 'chomp if eof' $1
}

# removes end of line characters
function chomp {
    perl -p -e 'chomp' "$*"
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

# ZIP utils
function zipdir {
    dir=$1
    output="${dir##*/}"
    echo $output.zip
    zip -r $output.zip $1
}

# alias for zipping files that is more intuitive (to me)
# Simple syntax: bzip <filenames_or_glob> -t destination
# Dependency: gnu getopt (so order of args don't matter)
# TODO make this work correctly - unit tests
function bzip {
    if [ -z $1 ]; then
        echo "usage: bzip <file_patterns> -t destination"
    fi

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

# GIT Functions
# Remove untracked files with interactive prompt
function gitrmu {
    rm -i $(git status --porcelain | grep '^??' | cut -f2 -d' ' | xargs)
}

function gitlast {
    git log --name-status --oneline HEAD^..HEAD
}

function gitstaged {
    git diff --name-only --cached
}

# Delete a branch, check it out again from your current branch.
function gitsteamroll {
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

# URL and HTML encoding - decoding
# Decode url encodings, either a file or a string.
# TODO piping is not working for these functions
function urldecode {
    # urldecode <string>
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

function urlencode {
    # TODO - unit tests
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "%s" "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    echo
    LC_COLLATE=$old_lc_collate
}

# TODO compare this to urldecode above via unit tests
# function url_decode {
#    if [ -f $1 ];  then
#        cat $1 | sed -e 's/+/ /g' | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e ;
#    else
#        echo $1 | sed -e 's/+/ /g' | sed -e's/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g' | xargs echo -e ;
#    fi
#}

# TODO check dependencies
# Dependencies: perl with MHTML library.
function htmlentity_decode {
    if [ -z "$2" ]; then
        cat $2 | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'
    else
        echo "$2" | perl -MHTML::Entities -le 'while(<>) {print decode_entities($_);}'
    fi
}

# VIM
function vsdir {
    vim -O $(find "$@" -type f | xargs)
}

function vsgrep {
   vim -O $(grepf "$@" . | xargs)
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

# DOCKER
function dockerrun {
    docker run --name bduncan_docker -it -p 9666:12345 ubuntu
}

function dockerrm {
    docker rm -f bduncan_docker
}

function dockerbash {
    if [ -z $1 ]
    then
        echo 'Usage: dockerbash [containerID|containerName] ';
    else
        docker exec -i -t "$1" /bin/bash
    fi
}

function dockerkillall {
    docker ps | awk '{print $1}' | awk 'FNR > 1 {print}' | xargs docker kill
}

# META - source and show config files
function balias {
    cat $BALIAS_FILES
    for f in $BALIAS_FILES; do source $f; done
}

function benv {
    cat $BENV_FILES
    for f in $BENV_FILES; do source $f; done
}

function bfunc {
    cat $BFUNC_FILES
    for f in $BFUNC_FILES; do source $f; done
}
