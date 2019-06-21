#!/bin/sh


cd /usr/share/easy-rsa

./easyrsa build-ca nopass << EOF

EOF
# CA creation complete and you may now import and sign cert requests.
# Your new CA certificate file for publishing is at:
# /usr/share/easy-rsa/pki/ca.crt

./easyrsa gen-req MyReq nopass << EOF2

EOF2
# Keypair and certificate request completed. Your files are:
# req: /usr/share/easy-rsa/pki/reqs/MyReq.req
# key: /usr/share/easy-rsa/pki/private/MyReq.key

./easyrsa sign-req server MyReq << EOF3
yes
EOF3
# Certificate created at: /usr/share/easy-rsa/pki/issued/MyReq.crt

#Copy server keys and certificates
cd /usr/share/easy-rsa/pki
cp ca.crt issued/MyReq.crt private/MyReq.key /etc/openvpn