#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/allow-ip-forwarding.sh
$CUR_DIR/iptables-setup.sh
$CUR_DIR/start-openvpn.sh

# Pass all the arguments of this script ti the user creation script
$CUR_DIR/client-gen-export.sh "$@"

exec bash