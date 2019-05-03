#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/allow-ip-forwarding.sh
$CUR_DIR/nat-setup.sh
$CUR_DIR/start-openvpn.sh
$CUR_DIR/client-export.sh

exec bash