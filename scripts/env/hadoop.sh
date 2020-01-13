#!/usr/bin/env bash

export HDP_VERSION=$HADOOP_VERSION
export HADOOP_HOME=$HADOOP_INSTALL_DIR/hadoop
export HADOOP_LOG_DIR=$HADOOP_HOME/logs
mkdir -p $HADOOP_LOG_DIR
export HADOOP_PID_DIR=$HADOOP_INSTALL_DIR/pids
mkdir -p $HADOOP_PID_DIR
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_TMP_DIR=$HADOOP_HOME/tmp

sed -i '$aexport HADOOP_HOME='$HADOOP_INSTALL_DIR'/hadoop' /home/$DOCKER_USER/.env_var
sed -i '$aexport HADOOP_LOG_DIR=\$HADOOP_HOME/logs' /home/$DOCKER_USER/.env_var
sed -i '$aexport HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop' /home/$DOCKER_USER/.env_var
sed -i '$aexport HADOOP_TMP_DIR=\$HADOOP_HOME/tmp' /home/$DOCKER_USER/.env_var
sed -i '$aexport PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin' /home/$DOCKER_USER/.env_var

sed -i "1i${HADOOP_HOME}/sbin/start-dfs.sh && ${HADOOP_HOME}/sbin/start-yarn.sh" /scripts/sys/launch_hadoop.sh
sed -i '$a'${HADOOP_HOME}'/bin/hdfs dfs -mkdir /home' /scripts/sys/launch_hadoop.sh
sed -i '$a'${HADOOP_HOME}'/bin/hdfs dfs -chown '$DOCKER_USER' /home' /scripts/sys/launch_hadoop.sh

mkdir -p $HADOOP_TMP_DIR
mkdir -p $HADOOP_TMP_DIR/hdfs/datanode
mkdir -p $HADOOP_TMP_DIR/hdfs/namenode
cp -f /settings/core-site.xml $HADOOP_CONF_DIR
sed -i "s~HADOOP_TMP_DIR~$HADOOP_TMP_DIR~" $HADOOP_CONF_DIR/core-site.xml

cp -f /settings/hdfs-site.xml $HADOOP_CONF_DIR
sed -i "s~HADOOP_TMP_DIR~$HADOOP_TMP_DIR~g" $HADOOP_CONF_DIR/hdfs-site.xml

cp /settings/mapred-site.xml $HADOOP_CONF_DIR
cp /settings/yarn-site.xml $HADOOP_CONF_DIR 

sed -i "s~\${JAVA_HOME}~$JAVA_HOME~" $HADOOP_CONF_DIR/hadoop-env.sh

chown -R $DOCKER_USER:$DOCKER_GROUP $HADOOP_HOME
chown -R $DOCKER_USER:$DOCKER_GROUP $HADOOP_TMP_DIR

/etc/init.d/ssh start
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
hdfs namenode -format -force

# start-dfs.sh &&./start-yarn.sh
# hdfs dfs -mkdir /user
# hdfs dfs -mkdir /user/haozou