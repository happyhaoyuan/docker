#!/usr/bin/env bash

HOST="9434"
REPO="zac"
TAG="latest"
PUSH=0

display_help(){
    echo "Desc: build the docker image /push to docker hub"
    echo "Usage: ./build.sh [-host 9434] [-repo zac] [-tag latest] [-push]"
    echo "--help          Help"
    echo "--host          Docker host (default: 9434)"
    echo "--repo          Docker repository (default: zac)"
    echo "--tag           Tag for the image (default: latest)"
    echo "--push          Push to docker hub"
    exit
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
        --host)
            HOST=$VALUE
            shift 2
            ;;
        --repo)
            REPO=$VALUE
            shift 2
            ;;
        --tag)
            TAG=$VALUE
            shift 2
            ;;
        --push)
            PUSH=1
            shift 1
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            help
            exit 1
            ;;
    esac
done

echo "docker build -t ${HOST}/${REPO}:${TAG} ."
docker build -t ${HOST}/${REPO}:${TAG} .
echo "docker build finished!"

if [ ${PUSH} -eq 1 ];
then
    echo "docker push ${HOST}/${REPO}:${TAG}"
    docker push ${HOST}/${REPO}:${TAG}
    echo "docker push finished!"
fi
