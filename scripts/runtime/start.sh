#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/setup-tuntap-device.sh
$CUR_DIR/iptables-setup.sh
$CUR_DIR/gen-server-cert.sh
$CUR_DIR/start-openvpn.sh

# Pass all the arguments of this script ti the user creation script
$CUR_DIR/gen-client-export.sh "$@"

exec bash