#!/usr/bin/env bash

#Copy server keys and certificates
cd ~/openvpn-ca/keys
cp ca.crt server.crt server.key ta.key dh2048.pem /etc/openvpn

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | tee /etc/openvpn/server.conf

#Edit server.conf Probably should be copied
#Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile