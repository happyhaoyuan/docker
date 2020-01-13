#!/usr/bin/env bash

export M2_HOME=/usr/share/maven
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

sed -i '$aexport M2_HOME=/usr/share/maven' /home/$DOCKER_USER/.env_var
sed -i '$aexport JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /home/$DOCKER_USER/.env_var
sed -i '$aexport PATH=\$PATH:\$JAVA_HOME/bin' /home/$DOCKER_USER/.env_var


