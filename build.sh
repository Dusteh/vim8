#!/bin/sh

USER_VAR=""
if test $USER == ""; then
    USER_VAR=user
else
    USER_VAR=$USER
fi

UID_VAR=""
if test $UID == ""; then
    UID_VAR=1000
else
    UID_VAR=$UID
fi

GROUP_NAME=$(id -g -n $USER_VAR) || GROUP_NAME=""

GID_VAR=""
if test $GROUP_NAME == ""; then
    GID_VAR=1000
else 
    GID_VAR=$(getent group $GROUP_NAME | awk -F: '{printf "%d\n", $3}')
fi

echo "Running with" $USER_VAR $UID_VAR $GID_VAR

sudo docker build -t vim8 --build-arg USER=${USER_VAR} \
                          --build-arg UID=${UID_VAR} \
                          --build-arg GID=${GID_VAR} \
                          .
