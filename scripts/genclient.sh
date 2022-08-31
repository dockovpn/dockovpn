#!/bin/bash

source ./functions.sh

CLIENT_PATH="$(createConfig)"
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
        o)
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

echo "$(datef) Config server started, download your $FILE_NAME config at http://$HOST_ADDR:$HOST_CONF_PORT/"
echo "$(datef) NOTE: After you download your client config, http server will be shut down!"

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat "$FILE_PATH"; } | nc -w0 -l 8080

echo "$(datef) Config http server has been shut down"