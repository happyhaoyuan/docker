# docker

docker run \ 
    -d \
    --restart="always" \
    --name zac \
    --hostname zac-hub \
    --memory=$(($(head -n 1 /proc/meminfo | awk '{print $2}') * 4 / 5))k \
    --cpus=$(($(nproc) - 1)) \
    --log-opt max-size=50m \
    -p 8000:8000 \
    -p 5006:5006 \
    -e DOCKER_USER=`id -un` \
    -e DOCKER_USER_ID=`id -u` \
    -e DOCKER_PASSWORD=`id -un` \
    -e DOCKER_GROUP_ID=`id -g` \
    -e DOCKER_ADMIN_USER=`id -un` \
    -v `pwd`:/workdir \
    -v `dirname $HOME`:/home_host \
    9434/jupyter_hub:0.0.1


    /workdir: working directory
    /home_host: 