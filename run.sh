#!/bin/sh

sudo docker run -it --mount type=bind,source=$HOME,target=/home/$USER \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --env="DISPLAY" \
    --net=host \
    vim8
