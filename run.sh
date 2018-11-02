#!/bin/sh


docker rm -f newcc

docker run --name newcc -d -p 3589:3389  -p 5902:5900 -p 6180:80\
  registry.mob.com/zhouzhipeng/docker-ubuntu-xrdp-lxqt

docker logs -f newcc