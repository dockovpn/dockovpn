#!/bin/sh

CUR_DIR=$APP_INSTALL_PATH/buildtime

$CUR_DIR/prepare-system.sh
$CUR_DIR/setup-server2.sh
$CUR_DIR/allow-ip-forwarding.sh
$CUR_DIR/openvpn-config.sh

chmod -R 777 $APP_INSTALL_PATH