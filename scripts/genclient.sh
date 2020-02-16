#!/bin/bash

source ./functions.sh

# Pass all the arguments of this script to the user creation script
# Exit normally if the count of arguments is 0 i.e we don't have to create a user
((!$#)) && echo "Nothing to generate for client!" && exit 0

# Parse string into chars:
# c    Create user config
# z    Zip user config
# p    User password for the zip archive
FLAGS=$1

# Switch statement
case $FLAGS in
    c)
        CLIENT_PATH="$(createConfig)"

        CONTENT_TYPE=application/text
        FILE_NAME=client.ovpn
        FILE_PATH="$CLIENT_PATH/$FILE_NAME"
        echo "$(datef) $FILE_PATH file has been generated"
        ;;
    cz)
        CLIENT_PATH="$(createConfig)"
        zipFiles "$CLIENT_PATH"

        CONTENT_TYPE=application/zip
        FILE_NAME=client.zip
        FILE_PATH="$CLIENT_PATH/$FILE_NAME"
        ;;
    czp)
        # (()) engaes arthimetic context
        if (($# < 2))
        then
            echo "Not enogh arguments" && exit 0
        else
            CLIENT_PATH="$(createConfig)"
            zipFilesWithPassword "$CLIENT_PATH" "$2"

            CONTENT_TYPE=application/zip
            FILE_NAME=client.zip
            FILE_PATH="$CLIENT_PATH/$FILE_NAME"
        fi
        ;;
esac

echo "$(datef) Config server started, download your $FILE_NAME config at http://$HOST_ADDR/"
echo "$(datef) NOTE: After you download you client config, http server will be shut down!"

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat "$FILE_PATH"; } | nc -w0 -l 8080

echo "$(datef) Config http server has been shut down"