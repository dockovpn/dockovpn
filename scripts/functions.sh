#!/bin/bash

function datef() {
    # Output:
    # Sat Jun  8 20:29:08 2019
    date "+%a %b %-d %T %Y"
}

function createConfig() {
    cd "$APP_PERSIST_DIR"
    CLIENT_ID="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
    CLIENT_PATH="$APP_PERSIST_DIR/clients/$CLIENT_ID"

    # Redirect stderr to the black hole
    easyrsa build-client-full "$CLIENT_ID" nopass &> /dev/null
    # Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
    # Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
    # CA is by the path /usr/share/easy-rsa/pki/ca.crt

    mkdir -p $CLIENT_PATH

    cp "pki/private/$CLIENT_ID.key" "pki/issued/$CLIENT_ID.crt" pki/ca.crt /etc/openvpn/ta.key $CLIENT_PATH

    cd "$APP_INSTALL_PATH"
    cp config/client.ovpn $CLIENT_PATH

    echo -e "\nremote $HOST_ADDR $HOST_TUN_PORT" >> "$CLIENT_PATH/client.ovpn"

    # Embed client authentication files into config file
    cat <(echo -e '<ca>') \
        "$CLIENT_PATH/ca.crt" <(echo -e '</ca>\n<cert>') \
        "$CLIENT_PATH/$CLIENT_ID.crt" <(echo -e '</cert>\n<key>') \
        "$CLIENT_PATH/$CLIENT_ID.key" <(echo -e '</key>\n<tls-auth>') \
        "$CLIENT_PATH/ta.key" <(echo -e '</tls-auth>') \
        >> "$CLIENT_PATH/client.ovpn"

    # Append client id info to the config
    echo ";client-id $CLIENT_ID" >> "$CLIENT_PATH/client.ovpn"

    echo $CLIENT_PATH
}

function zipFiles() {
    CLIENT_PATH="$1"
    IS_QUITE="$2"

    # -q to silence zip output
    # -j junk directories
    zip -q -j "$CLIENT_PATH/client.zip" "$CLIENT_PATH/client.ovpn"
    if [ "$IS_QUITE" != "-q" ]
    then
       echo "$(datef) $CLIENT_PATH/client.zip file has been generated"
    fi
}

function zipFilesWithPassword() {
    CLIENT_PATH="$1"
    ZIP_PASSWORD="$2"
    IS_QUITE="$3"
    # -q to silence zip output
    # -j junk directories
    # -P pswd use standard encryption, password is pswd
    zip -q -j -P "$ZIP_PASSWORD" "$CLIENT_PATH/client.zip" "$CLIENT_PATH/client.ovpn"

    if [ "$IS_QUITE" != "-q" ]
    then
       echo "$(datef) $CLIENT_PATH/client.zip with password protection has been generated"
    fi
}

function removeConfig() {
    local CLIENT_ID="$1"

    cd "$APP_PERSIST_DIR"

    easyrsa revoke $CLIENT_ID << EOF
yes
EOF
    easyrsa gen-crl

    cp /opt/Dockovpn_data/pki/crl.pem /etc/openvpn

    cd "$APP_INSTALL_PATH"
}