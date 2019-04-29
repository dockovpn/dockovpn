#!/bin/sh

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/allow-ip-forwarding.sh
$CUR_DIR/nat-setup.sh
$CUR_DIR/client-setup.sh

# To indicate everything went well we create dummy file which can be observed via mounting
# touch $APP_NAME/done.txt

exec bash