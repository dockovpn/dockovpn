#!/bin/sh

apk add --no-cache openvpn easy-rsa bash
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

# Need to edit vars somehow or copy entire file from somewhere
source vars
./clean-all
printf '\n\n\n\n\n\n\n\n' | ./build-ca

# There must be better way to do so
./build-key-server server << EOF










y
y
EOF
#need not to create challenging password
#need to answer y(yes) when asked to sign and commit certificate

#Build strong Deffi-Haufman key
./build-dh

# Generate an HMAC signature to strengthen the server's TLS integrity verification capabilities
openvpn --genkey --secret keys/ta.key