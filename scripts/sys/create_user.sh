#!/usr/bin/env bash

USER=""
USER_ID=""
PASSWORD=""
GROUP="nogroup"
NOGROUP_ID="$(getent group nogroup | cut -d: -f3)"
DEFAULT_GROUP_ID=${NOGROUP_ID:-9999}
GROUP_ID=$DEFAULT_GROUP_ID

function display_help(){
    cat << EOF
Desc: 
    Create a new user
Usage: 
    ./create_user.sh \
$(tput setaf 3)-u$(tput sgr0) USER \
$(tput setaf 3)-i$(tput sgr0) USER_ID \
$(tput setaf 3)-p$(tput sgr0) PASSWORD \
[$(tput setaf 3)-g$(tput sgr0) GROUP] \
[$(tput setaf 3)-r$(tput sgr0) GROUP_ID]
Options:
    $(tput setaf 3)-h, --help$(tput sgr0)                  Help
    $(tput setaf 3)-u, --user$(tput sgr0) USER             User name ($(tput setaf 1)required$(tput sgr0))
    $(tput setaf 3)-i, --user_id$(tput sgr0) USER_ID       User id ($(tput setaf 1)required$(tput sgr0))
    $(tput setaf 3)-p, --password$(tput sgr0) PASSWORD     User password ($(tput setaf 1)required$(tput sgr0))
    $(tput setaf 3)-g, --group$(tput sgr0) GROUP           Group name ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)nogroup$(tput sgr0))
    $(tput setaf 3)-r, --group_id$(tput sgr0) GROUP_ID     Group id ($(tput setaf 6)optional$(tput sgr0), \
default: $(tput setaf 4)$DEFAULT_GROUP_ID$(tput sgr0))
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
        -u | --user)
            USER=$VALUE
            shift 2
            ;;
        -i | --user_id)
            USER_ID=$VALUE
            shift 2
            ;;
        -p | --password)
            PASSWORD=$VALUE
            shift 2
            ;;
        -g | --group)
            GROUP=$VALUE
            shift 2
            ;;
        -r | --group_id)
            GROUP_ID=$VALUE
            shift 2
            ;;
        *)
            echo "[$(tput setaf 1)ERROR$(tput sgr0)] unknown parameter $(tput setaf 4)$PARAM$(tput sgr0)"
            display_help
            exit 1
            ;;
    esac
done

for PARAM in USER USER_ID PASSWORD GROUP GROUP_ID
do
    VALUE=$PARAM
    if [[ ${!VALUE} == "" ]]; then
        echo "[$(tput setaf 1)ERROR$(tput sgr0)] $PARAM is missing!"
        display_help
        exit 1
    fi
done

echo "[$(tput setaf 6)INFO$(tput sgr0)] Check user $(tput setaf 4)$USER$(tput sgr0)"
id $USER
if [[ $? == 0 ]]; then
    echo "[$(tput setaf 1)ERROR$(tput sgr0)] User $(tput setaf 4)$USER$(tput sgr0) already exists!"
    exit 0
fi

if [[ "$(getent group $GROUP)" == "" ]]; then
    echo "[$(tput setaf 6)INFO$(tput sgr0)] Add new group $(tput setaf 4)$GROUP$(tput sgr0) (group id $(tput setaf 4)$GROUP_ID$(tput sgr0))"
    cmd="groupadd -o -g $GROUP_ID $GROUP"
    echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
    eval $cmd
else
    echo "[$(tput setaf 6)INFO$(tput sgr0)] Group $(tput setaf 4)$GROUP$(tput sgr0) (group id $(tput setaf 4)$GROUP_ID$(tput sgr0)) already exists!"
fi

echo "[$(tput setaf 6)INFO$(tput sgr0)] Creating user $(tput setaf 4)$USER$(tput sgr0) (user id $(tput setaf 4)$USER_ID$(tput sgr0)) for group $(tput setaf 4)$GROUP$(tput sgr0)"
cmd="useradd -oml -u $USER_ID -g $GROUP -d /home/$USER -s /bin/bash -c \"$USER\" $USER"
echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
eval $cmd
echo "[$(tput setaf 2)DONE$(tput sgr0)] User created!"
echo "[$(tput setaf 6)INFO$(tput sgr0)] Setting password"
cmd="echo $USER:$PASSWORD | chpasswd"
echo "[$(tput setaf 3)CMD$(tput sgr0)] $cmd"
eval $cmd
echo "[$(tput setaf 2)DONE$(tput sgr0)] Setting finished!"