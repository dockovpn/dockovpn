#!/usr/bin/env bash

/opt/teleport/server-setup.sh

/opt/teleport/openvpn-service.sh

#./allow-ip-forwarding.sh

#./setup-ufw.sh