#!/usr/bin/env bash

export SPARK_VERSION=$SPARK_VERSION
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

chown -R $DOCKER_USER:$DOCKER_GROUP $SPARK_HOME

