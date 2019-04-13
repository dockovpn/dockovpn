#!/usr/bin/env bash

./server-setup.sh

./openvpn-service.sh

./allow-ip-forwarding.sh

./setup-ufw.sh