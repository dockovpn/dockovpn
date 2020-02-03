#!/bin/bash

source ./functions.sh

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi

# Allow UDP traffic on port 1194.
iptables -A INPUT -i eth0 -p udp -m state --state NEW,ESTABLISHED --dport 1194 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp -m state --state ESTABLISHED --sport 1194 -j ACCEPT

# Allow traffic on the TUN interface.
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i tun0 -o eth0 -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE


/usr/share/easy-rsa/easyrsa build-ca nopass << EOF

EOF
# CA creation complete and you may now import and sign cert requests.
# Your new CA certificate file for publishing is at:
# /usr/share/easy-rsa/pki/ca.crt

/usr/share/easy-rsa/easyrsa gen-req MyReq nopass << EOF2

EOF2
# Keypair and certificate request completed. Your files are:
# req: /usr/share/easy-rsa/pki/reqs/MyReq.req
# key: /usr/share/easy-rsa/pki/private/MyReq.key

/usr/share/easy-rsa/easyrsa sign-req server MyReq << EOF3
yes
EOF3
# Certificate created at: /usr/share/easy-rsa/pki/issued/MyReq.crt

openvpn --genkey --secret /etc/openvpn/ta.key << EOF4
yes
EOF4

# Print app version
$APP_INSTALL_PATH/version.sh

# Copy server keys and certificates
cp pki/ca.crt pki/issued/MyReq.crt pki/private/MyReq.key /etc/openvpn

# Need to feed key password
openvpn --config /etc/openvpn/server.conf &

# By some strange reason we need to do echo command to get to the next command
echo " "

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

echo "$(datef) Config server started, download your $FILE_NAME config at http://$HOST_ADDR/"
echo "$(datef) NOTE: After you download you client config, http server will be shut down!"

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat $FILE_PATH; } | nc -w0 -l 8080

echo "$(datef) Config http server has been shut down"

tail -f /dev/null