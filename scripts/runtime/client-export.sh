#!/bin/bash

cd /usr/share/easy-rsa/pki

# Create mkdir if doesn't exist
mkdir -p $APP_INSTALL_PATH/client

cp private/client.key issued/client.crt ca.crt $APP_INSTALL_PATH/client
cd $APP_INSTALL_PATH
cp config/client.ovpn client
zip -r client.zip client
cp client.zip client

FILE_NAME=client.zip
FILE_PATH=$FILE_NAME

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: application/zip\r\n\Content-Disposition: attachment; filename=\"client.zip\"r\n\Accept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080