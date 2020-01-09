#!/usr/bin/env bash

function display_help(){
    cat << EOF
Desc: 
    Run 
Usage: 
    ./etc.sh \
$(tput setaf 3)-d$(tput sgr0) Directory
Options:
    $(tput setaf 3)-h, --help$(tput sgr0)                  Help
    $(tput setaf 3)-d, --dir$(tput sgr0) Directory         Run all scripts under the directory ($(tput setaf 1)required$(tput sgr0))
EOF
}

while [[ "$1" != "" ]];
do
    PARAM=$1
    VALUE=$2
    case $PARAM in
        -h | --help)
            display_help
            exit
            ;;
        -d | --dir)
            DIR=$VALUE
            shift 2
            ;;
        *)
            echo "[$(tput setaf 1)ERROR$(tput sgr0)] unknown parameter $(tput setaf 4)$PARAM$(tput sgr0)"
            display_help
            exit 1
            ;;
    esac
done


for script in $(ls $DIR/*.sh);
    do
        # index=$(basename $script)
        # index=${index:0:3}
        # echo "$index"
        # if [[ $index -le $upper_index ]]; then
        #     source $script
        # fi
        cmd="source $script"
        echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
        # eval $cmd
        echo "[$(tput setaf 2)DONE$(tput sgr0)] Script $(tput setaf 4)$script$(tput sgr0) finished!"
    done
