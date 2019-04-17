#!/usr/bin/env bash

/opt/teleport/server-setup.sh

/opt/teleport/openvpn-service.sh

/opt/teleport/allow-ip-forwarding.sh

#./setup-ufw.sh