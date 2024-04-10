#!/bin/bash

function datef() {
    # Output:
    # Sat Jun  8 20:29:08 2019
    date "+%a %b %-d %T %Y"
}

function createConfig() {
    cd "$APP_PERSIST_DIR"

    # Redirect stderr to the black hole

    if [ -n "$PASSWORD_PROTECTED" ]; then
        easyrsa --batch build-client-full "$CLIENT_ID"
    else
        easyrsa --batch build-client-full "$CLIENT_ID" nopass &> /dev/null
    fi

    # Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
    # Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
    # CA is by the path /usr/share/easy-rsa/pki/ca.crt

    mkdir -p $CLIENT_PATH

    cp "pki/private/$CLIENT_ID.key" "pki/issued/$CLIENT_ID.crt" pki/ca.crt /etc/openvpn/ta.key $CLIENT_PATH

    cd "$APP_INSTALL_PATH"
    cp config/client.ovpn $CLIENT_PATH
    sed -i 's/%HOST_TUN_PROTOCOL%/'"$HOST_TUN_PROTOCOL"'/g' $CLIENT_PATH/client.ovpn

    echo -e "\nremote $HOST_ADDR_INT $HOST_TUN_PORT" >> "$CLIENT_PATH/client.ovpn"

    # Embed client authentication files into config file
    cat <(echo -e '<ca>') \
        "$CLIENT_PATH/ca.crt" <(echo -e '</ca>\n<cert>') \
        "$CLIENT_PATH/$CLIENT_ID.crt" <(echo -e '</cert>\n<key>') \
        "$CLIENT_PATH/$CLIENT_ID.key" <(echo -e '</key>\n<tls-auth>') \
        "$CLIENT_PATH/ta.key" <(echo -e '</tls-auth>') \
        >> "$CLIENT_PATH/client.ovpn"

    # Append client id info to the config
    echo ";client-id $CLIENT_ID" >> "$CLIENT_PATH/client.ovpn"
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
    easyrsa --days=$CRL_DAYS gen-crl

    cp /opt/Dockovpn_data/pki/crl.pem /etc/openvpn

    cd "$APP_INSTALL_PATH"
}

function getVersion() {
    local app_version="$APP_NAME $(cat $APP_INSTALL_PATH/config/VERSION)"

    echo "$app_version"
}

function getVersionFull() {
    echo "$(datef) $(getVersion)"
}

function listConfigs() {
    cd "$APP_PERSIST_DIR/clients"
    ls -1
}

function getConfig() {
    local CLIENT_ID="$1"

    cat "$APP_PERSIST_DIR/clients/$CLIENT_ID/client.ovpn"
}

function generateClientConfig() {
    #case
    #first argument  = n  use second argument as CLIENT_ID
    #first argument = np use second argument as CLIENT_ID and set PASSWORD_PROTECTED as yes
    #default generate random CLIENT_ID
    FLAGS=$1
    case $FLAGS in
        n)
            CLIENT_ID="$2"
            ;;
        np)
            CLIENT_ID="$2"
            PASSWORD_PROTECTED="yes"
            ;;
        *)
            CLIENT_ID="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
            ;;
    esac

    CLIENT_PATH="$APP_PERSIST_DIR/clients/$CLIENT_ID"

    if [ -d $CLIENT_PATH ]; then
        echo "$(datef) Client with this id [$CLIENT_ID] already exists"
        exit 1
    else
        createConfig
    fi

    CONTENT_TYPE=application/text
    FILE_NAME=client.ovpn
    FILE_PATH="$CLIENT_PATH/$FILE_NAME"

    if (($#))
    then

        # Parse string into chars:
        # z    Zip user config
        # p    User password for the zip archive
        FLAGS=$1

        # Switch statement
        case $FLAGS in
            z)
                zipFiles "$CLIENT_PATH"

                CONTENT_TYPE=application/zip
                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                ;;
            zp)
                # (()) engaes arthimetic context
                if (($# < 2))
                then
                    echo "$(datef) Not enough arguments" && exit 1
                else
                    zipFilesWithPassword "$CLIENT_PATH" "$2"

                    CONTENT_TYPE=application/zip
                    FILE_NAME=client.zip
                    FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                fi
                ;;
            o|n|np)
                    cat "$FILE_PATH"
                    exit 0
                ;;
            oz)
                zipFiles "$CLIENT_PATH" -q

                FILE_NAME=client.zip
                FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                cat "$FILE_PATH"
                exit 0
                ;;
            ozp)
                if (($# < 2))
                then
                    echo "$(datef) Not enough arguments" && exit 1
                else
                    zipFilesWithPassword "$CLIENT_PATH" "$2" -q

                    FILE_NAME=client.zip
                    FILE_PATH="$CLIENT_PATH/$FILE_NAME"
                    cat "$FILE_PATH"
                    exit 0
                fi
                ;;
            *) echo "$(datef) Unknown parameters $FLAGS"
                ;;

        esac
    fi
    echo "$(datef) $FILE_PATH file has been generated"

    echo "$(datef) Config server started, download your $FILE_NAME config at http://$HOST_ADDR_INT:$HOST_CONF_PORT/"
    echo "$(datef) NOTE: After you download your client config, http server will be shut down!"

    { echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat "$FILE_PATH"; } | nc -w0 -l 8080

    echo "$(datef) Config http server has been shut down"
}

RESOLVED_HOST_ADDR=$(curl -s -H "X-DockoVPN-Version: $(getVersion) $0" https://ip.dockovpn.io)

if [[ -n $HOST_ADDR ]]; then
    export HOST_ADDR_INT=$HOST_ADDR
else
    export HOST_ADDR_INT=$RESOLVED_HOST_ADDR
fi
