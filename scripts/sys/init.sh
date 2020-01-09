#!/usr/bin/env bash

# create a user
DOCKER_USER=${DOCKER_USER:-haozou} 
DOCKER_USER_ID=${DOCKER_USER_ID:-9001} 
DOCKER_PASSWORD=${DOCKER_PASSWORD:-$DOCKER_USER} 
DOCKER_GROUP=${DOCKER_GROUP:-docker} 
DOCKER_GROUP_ID=${DOCKER_GROUP_ID:-9001}
/scripts/sys/create_user.sh -u $DOCKER_USER -i $DOCKER_USER_ID -p $DOCKER_PASSWORD -g $DOCKER_GROUP -r $DOCKER_GROUP_ID
gpasswd -a $DOCKER_USER sudo

/scripts/sys/run_scripts.sh -d /scripts/env

# su -m $DOCKER_USER -c /scripts/launch.sh
# source /scripts/sys/launch.sh
source /scripts/sys/launch_R.sh
source /scripts/sys/launch_jupyterhub.sh