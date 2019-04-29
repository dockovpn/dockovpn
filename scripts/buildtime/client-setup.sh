#!/bin/bash

cd /usr/share/easy-rsa

./easyrsa build-client-full client nopass << EOF
12345
EOF
# Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
# Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
# CA is by the path /usr/share/easy-rsa/pki/ca.crt