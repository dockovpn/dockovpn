#!/usr/bin/env bash

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/nat-setup.sh

# To indicate everything went well we create dummy file which can be observed via mounting
touch $APP_INSTALL_PATH/done.txt

exec bash