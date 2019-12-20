#!/bin/bash

function datef() {
    # Output:
    # Sat Jun  8 20:29:08 2019
    date "+%a %b %-d %T %Y"
}

function createConfig() {
    # Redirect stderr to the black hole
    /usr/share/easy-rsa/easyrsa build-client-full client nopass &> /dev/null
    # Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
    # Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
    # CA is by the path /usr/share/easy-rsa/pki/ca.crt

    # Create mkdir if doesn't exist
    mkdir -p client

    cp pki/private/client.key pki/issued/client.crt pki/ca.crt /etc/openvpn/ta.key client

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
        client/client.key <(echo -e '</key>\n<tls-auth>') \
        client/ta.key <(echo -e '</tls-auth>') \
        >> client/client.ovpn

    echo "$(datef) Client.ovpn file has been generated"
}

function zipFiles() {
    # -q to silence zip output
    zip -q client.zip client/client.ovpn
    cp client.zip client

    echo "$(datef) Client.zip file has been generated"
}

function zipFilesWithPassword() {
    # -q to silence zip output
    zip -q -P "$1" client.zip client/client.ovpn
    cp client.zip client

    echo "$(datef) Client.zip with password protection has been generated"
}