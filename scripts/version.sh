#!/bin/bash
source ./functions.sh

APP_VERSION="$(cat $APP_INSTALL_PATH/config/VERSION)"

echo "$(datef) $APP_NAME $APP_VERSION"