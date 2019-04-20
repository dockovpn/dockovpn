#!/usr/bin/env bash

#APP_NAME='/opt/teleport'

/opt/teleport/server-setup.sh

/opt/teleport/openvpn-service.sh

/opt/teleport/allow-ip-forwarding.sh

/opt/teleport/setup-ufw.sh