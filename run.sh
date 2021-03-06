#!/bin/sh


docker rm -f newcc

docker run --name newcc -d \
    -p 3589:3389 \
    -p 2222:22 \
    -e USER=zhouzhipeng \
    -e PASSWORD=shutup \
    -e RESOLUTION=2560x1600 \
    -v /dev/shm:/dev/shm \
    --privileged \
    -v /data/root_data:/home/zhouzhipeng \
    -v /var/run/docker.sock:/var/run/docker.sock \
    zhouzhipeng/docker-ubuntu-xrdp-lxqt:test
#registry.cn-shanghai.aliyuncs.com
docker logs -f newcc
# -v /data/root_data:/root \

# registry.mob.com/zhouzhipeng/docker-ubuntu-xrdp-lxqt:avalable  基本可用版本 (包含vnc,novnc,xrdp,lxqt,chrome,有puslaudio 但是没有声音)
# registry.mob.com/zhouzhipeng/docker-ubuntu-xrdp-lxqt:idea  包含intellij idea



## pulseaudio  modules :   /usr/lib/pulse-11.1/modules