#!/usr/bin/env bash

APP_NAME='/opt/teleport'
CUR_DIR="$APP_NAME/buildtime"

$CUR_DIR/server-setup.sh
$CUR_DIR/openvpn-service.sh
$CUR_DIR/allow-ip-forwarding.sh

chmod -R 777 $APP_NAME