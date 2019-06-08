#!/bin/bash

# Exit normally if the count of arguments is 0 i.e we don't have to create a user
((!$#)) && echo "Nothing to generate for client!" && exit 0

function datef() {
    # Output:
    # Sat Jun  8 20:29:08 2019
    date "+%a %b  %-d %T %Y"
}

function createConfig() {
    cd /usr/share/easy-rsa

    # Redirect stderr to the black hole
    ./easyrsa build-client-full client nopass &> /dev/null
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

    echo "$(datef) Client config has been generated"
}

function zipFiles() {
    # -q to silence zip output
    zip -q client.zip client/client.ovpn
    cp client.zip client

    echo "$(datef) Client.zip created"
}

function zipFilesWithPassword() {
    # -q to silence zip output
    zip -q -P "$1" client.zip client/client.ovpn
    cp client.zip client

    echo "$(datef) Client.zip with password protection created"
}

# Parse string into chars:
# c    Create user config
# z    Zip user config
# p    User password for the zip archive
FLAGS=$1

# Switch statement
case $FLAGS in
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
    czp)
        # (()) engaes arthimetic context
        if (($# < 2))
        then
            echo "Not enogh arguments" && exit 0
        else
            createConfig
            zipFilesWithPassword "$2"

            CONTENT_TYPE=application/zip
            FILE_NAME=client.zip
            FILE_PATH=$FILE_NAME
        fi
        ;;
esac

echo "$(datef) Config server started at $HOST_ADDR:8080/"

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080

echo "$(datef) Config server shut down"