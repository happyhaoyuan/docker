#!/usr/bin/env bash

HOST="9434"
REPO="zac"
TAG="latest"
FILE="./Dockerfile"
BUILD=0
PUSH=0
CONTEXT="."

function display_help(){
    cat << EOF
Desc: 
    Build docker image and/or push to docker hub
Usage: 
    ./build.sh [$(tput setaf 3)-b$(tput sgr0)] \
[$(tput setaf 3)-f$(tput sgr0) DOCKERFILE] \
[$(tput setaf 3)-o$(tput sgr0) HOST] \
[$(tput setaf 3)-r$(tput sgr0) REPOSITORY] \
[$(tput setaf 3)-t$(tput sgr0) TAG] \
[$(tput setaf 3)-c$(tput sgr0) CONTEXT] \
[$(tput setaf 3)-p$(tput sgr0)]
Options:
    $(tput setaf 3)-h, --help$(tput sgr0)                   Help
    $(tput setaf 3)-b, --build$(tput sgr0)                  Build docker image ($(tput setaf 6)optional$(tput sgr0))
    $(tput setaf 3)-f, --file$(tput sgr0) DOCKERFILE        Docker file to build ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)./Dockerfile$(tput sgr0))
    $(tput setaf 3)-o, --host$(tput sgr0) HSOT              Docker host ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)9434$(tput sgr0))
    $(tput setaf 3)-r, --repo$(tput sgr0) REPOSITORY        Docker repository ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)zac$(tput sgr0))
    $(tput setaf 3)-t, --tag$(tput sgr0) TAG                Tag for the image ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)latest$(tput sgr0))
    $(tput setaf 3)-c, --context$(tput sgr0) CONTEXT        Context to build ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4).$(tput sgr0))
    $(tput setaf 3)-p, --push$(tput sgr0)                   Push to docker hub ($(tput setaf 6)optional$(tput sgr0))
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
        -f | --file)
            FILE=$VALUE
            shift 2
            ;;
        -o | --host)
            HOST=$VALUE
            shift 2
            ;;
        -r | --repo)
            REPO=$VALUE
            shift 2
            ;;
        -t | --tag)
            TAG=$VALUE
            shift 2
            ;;
        -c | --context)
            CONTEXT=$VALUE
            shift 2
            ;;
        -p | --push)
            PUSH=1
            shift 1
            ;;
        -b | --build)
            BUILD=1
            shift 1
            ;;
        *)
            echo "[$(tput setaf 1)ERROR$(tput sgr0)] unknown parameter $(tput setaf 4)$PARAM$(tput sgr0)"
            display_help
            exit 1
            ;;
    esac
done

TARGET=${HOST}/${REPO}:${TAG}

if [ ${BUILD} -eq 1 ];
then
cmd="docker build -f ${FILE} -t ${TARGET} ${CONTEXT}"
echo "[$(tput setaf 6)INFO$(tput sgr0)] Building target $(tput setaf 4)${TARGET}$(tput sgr0) \
with docker file $(tput setaf 4)${FILE}$(tput sgr0) and \
context $(tput setaf 4)${CONTEXT}$(tput sgr0) now"
echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
# eval $cmd
echo "[$(tput setaf 2)DONE$(tput sgr0)] Docker build finished!"
fi

if [ ${PUSH} -eq 1 ];
then
    cmd="docker push ${TARGET}"
    echo "[$(tput setaf 6)INFO$(tput sgr0)] Pushing taregt $(tput setaf 4)${TARGET}$(tput sgr0) now"
    echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
    # eval $cmd
    echo "[$(tput setaf 2)DONE$(tput sgr0)] Docker push finished!"
fi
