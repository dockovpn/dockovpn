#!/bin/sh

#Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
cp $APP_INSTALL_PATH/config/server.conf /etc/openvpn/server.conf