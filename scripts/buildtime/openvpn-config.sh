#!/bin/sh

#Copy server keys and certificates
cd /usr/share/easy-rsa/pki
cp ca.crt issued/MyReq.crt private/MyReq.key dh.pem /etc/openvpn

#Edit server.conf Probably should be copied
#Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
cp $APP_INSTALL_PATH/config/server.conf /etc/openvpn/server.conf

# Need to feed key password
openvpn --config /etc/openvpn/server.conf