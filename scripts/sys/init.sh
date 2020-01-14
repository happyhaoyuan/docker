#!/usr/bin/env bash

# create a user
DOCKER_USER=${DOCKER_USER:-haozou} 
DOCKER_USER_ID=${DOCKER_USER_ID:-9001} 
DOCKER_PASSWORD=${DOCKER_PASSWORD:-$DOCKER_USER} 
DOCKER_GROUP=${DOCKER_GROUP:-docker} 
DOCKER_GROUP_ID=${DOCKER_GROUP_ID:-9001}
/scripts/sys/create_user.sh -u $DOCKER_USER -i $DOCKER_USER_ID -p $DOCKER_PASSWORD -g $DOCKER_GROUP -r $DOCKER_GROUP_ID
gpasswd -a $DOCKER_USER sudo

echo "#env var" > /home/$DOCKER_USER/.env_var
chown -R $DOCKER_USER:$DOCKER_GROUP /home/$DOCKER_USER/.env_var

source /scripts/env/jdk.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Jdk$(tput sgr0) settled"
source /scripts/env/proxychains.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Proxychains$(tput sgr0) settled"
source /scripts/env/hadoop.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Hadoop$(tput sgr0) settled"
source /scripts/env/spark.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Spark$(tput sgr0) settled"
source /scripts/env/jupyterhub.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Jupyterhub$(tput sgr0) settled"
source /scripts/env/R.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)R$(tput sgr0) settled"

#/scripts/sys/run_scripts.sh -d /scripts/env

# chown -R $DOCKER_USER:$DOCKER_GROUP /workdir
su $DOCKER_USER -c 'source /scripts/usr/zsh.sh'
# source /scripts/usr/zsh.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)zsh$(tput sgr0) settled"

# su -m $DOCKER_USER -c /scripts/launch.sh
# source /scripts/sys/launch.sh
source /scripts/sys/launch_R.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)R server$(tput sgr0) launched"
source /scripts/sys/launch_jupyterhub.sh
echo "[$(tput setaf 6)INFO$(tput sgr0)] $(tput setaf 4)Jupyter server$(tput sgr0) launched"
