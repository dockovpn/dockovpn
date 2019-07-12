#!/bin/bash

source $APP_INSTALL_PATH/runtime/functions.sh

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tn/tap device"
    mknod /dev/net/tun c 10 200
fi