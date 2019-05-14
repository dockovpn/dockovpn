#!/bin/bash

cd /usr/share/easy-rsa

./easyrsa build-client-full client nopass
# Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
# Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
# CA is by the path /usr/share/easy-rsa/pki/ca.crt

cd /usr/share/easy-rsa/pki

# Create mkdir if doesn't exist
mkdir -p $APP_INSTALL_PATH/client

cp private/client.key issued/client.crt ca.crt $APP_INSTALL_PATH/client

# Set default value to HOST_ADDR if it was not set from environment
if [ -z "$HOST_ADDR"]
then
    HOST_ADDR='localhost'
fi

cd $APP_INSTALL_PATH
cp config/client.ovpn client
echo -e "\nremote $HOST_ADDR 1194" >> client/client.ovpn

zip -r client.zip client
cp client.zip client

FILE_NAME=client.zip
FILE_PATH=$FILE_NAME

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: application/zip\r\n\Content-Disposition: attachment; filename=\"client.zip\"r\n\Accept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080