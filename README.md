# docker

docker run \ 
    -d \
    --restart="always" \
    --name zac \
    --hostname zac-hub \
    --memory=$(($(head -n 1 /proc/meminfo | awk '{print $2}') * 4 / 5))k \
    --cpus=$(($(nproc) - 1)) \
    --log-opt max-size=50m \
    -p 5006:5006 \
    -p 7000:7000 \
    -p 8000:8000 \
    -p 8088:8088 \
    -p 9000:9000 \
    -p 9870:9870 \
    -e DOCKER_USER=`id -un` \
    -e DOCKER_USER_ID=`id -u` \
    -e DOCKER_PASSWORD=`id -un` \
    -e DOCKER_GROUP_ID=`id -g` \
    -e DOCKER_ADMIN_USER=`id -un` \
    -v $(pwd):/workdir \
    -v $(dirname $HOME):/home_host \
    9434/zac:latest


<!--     
/workdir: working directory
/home_host:  
-->