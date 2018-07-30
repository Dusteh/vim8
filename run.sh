#!/bin/sh

sudo docker run -it --mount type=bind,source=$HOME,target=$HOME \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --env="DISPLAY" \
    --net=host \
    vim8
