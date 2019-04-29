#!/bin/sh

CUR_DIR=$APP_INSTALL_PATH/buildtime

chmod -R 777 $APP_INSTALL_PATH

$CUR_DIR/prepare-system.sh
$CUR_DIR/server-setup.sh
$CUR_DIR/client-setup.sh
$CUR_DIR/openvpn-config.sh