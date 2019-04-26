#!/usr/bin/env bash

CUR_DIR=$APP_INSTALL_PATH/buildtime

$CUR_DIR/server-setup.sh
$CUR_DIR/openvpn-service.sh
$CUR_DIR/allow-ip-forwarding.sh

chmod -R 777 $APP_INSTALL_PATH