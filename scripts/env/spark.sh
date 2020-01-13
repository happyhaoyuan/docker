#!/usr/bin/env bash

export SPARK_VERSION=$SPARK_VERSION
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

sed -i '$aexport SPARK_HOME=/opt/spark' /home/$DOCKER_USER/.env_var
sed -i '$aexport PATH=\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$PATH' /home/$DOCKER_USER/.env_var

chown -R $DOCKER_USER:$DOCKER_GROUP $SPARK_HOME

