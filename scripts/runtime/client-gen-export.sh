#!/bin/bash

# Exit normally if the count of arguments is 0 i.e we don't have to create a user
((!$#)) && echo "Nothing to generate for client!" && exit 0

echo -e "\n<<PARAMS: $@>>"

function createConfig() {
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
    if [ -z "$HOST_ADDR" ]
    then
        HOST_ADDR='localhost'
    fi

    cd $APP_INSTALL_PATH
    cp config/client.ovpn client

    echo -e "\nremote $HOST_ADDR 1194" >> client/client.ovpn

    # Embed client authentication files into config file
    cat <(echo -e '<ca>') \
        client/ca.crt <(echo -e '</ca>\n<cert>') \
        client/client.crt <(echo -e '</cert>\n<key>') \
        client/client.key <(echo -e '</key>') \
        >> client/client.ovpn
}

function zipFiles() {
    zip -r client.zip client/client.ovpn
    cp client.zip client
}

# Parse string into chars:
# c    Create user config
# z    Zip user config
# p    User password for the zip archive
FLAGS=$1

# Switch statement
case $FLAGS in
    n)
        echo "Default param"
        ;;
    c)      
        createConfig

        CONTENT_TYPE=application/text
        FILE_NAME=client.ovpn
        FILE_PATH=client/$FILE_NAME
        ;;
    cz)      
        createConfig
        zipFiles

        CONTENT_TYPE=application/zip
        FILE_NAME=client.zip
        FILE_PATH=$FILE_NAME
        ;;
esac

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\n\Content-Disposition: attachment; filename=$FILE_NAMEr\n\Accept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080