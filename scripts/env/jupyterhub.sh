#!/usr/bin/env bash

mkdir -p /etc/jupyterhub
cp /settings/jupyterhub_config.py /etc/jupyterhub/

# add admin user to JupyterHub
sed -i "s/DOCKER_ADMIN_USER/${DOCKER_ADMIN_USER:-$DOCKER_USER}/g" /etc/jupyterhub/jupyterhub_config.py
# user memory limit
# sed -i "s/USER_MEM_LIMIT/${USER_MEM_LIMIT:-4G}/g" /etc/jupyterhub/jupyterhub_config.py