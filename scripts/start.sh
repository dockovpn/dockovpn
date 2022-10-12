#!/bin/bash

[ ! -d $APP_PERSIST_DIR/pki ] && cp -r /build/* $APP_PERSIST_DIR/

ADAPTER="${NET_ADAPTER:=eth0}"
source ./functions.sh

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi

# Allow UDP traffic on port 1194.
iptables -A INPUT -i $ADAPTER -p udp -m state --state NEW,ESTABLISHED --dport $PORT -j ACCEPT
iptables -A OUTPUT -o $ADAPTER -p udp -m state --state ESTABLISHED --sport $PORT -j ACCEPT

# Allow traffic on the TUN interface.
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i tun0 -o $ADAPTER -s $IP_NET -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s $IP_NET -o $ADAPTER -j MASQUERADE

cd "$APP_PERSIST_DIR"

LOCKFILE=.gen

# Regenerate certs only on the first start 
if [ ! -f $LOCKFILE ]; then
    IS_INITIAL="1"

    easyrsa build-ca nopass << EOF

EOF
    # CA creation complete and you may now import and sign cert requests.
    # Your new CA certificate file for publishing is at:
    # /opt/Dockovpn_data/pki/ca.crt

    easyrsa gen-req MyReq nopass << EOF2

EOF2
    # Keypair and certificate request completed. Your files are:
    # req: /opt/Dockovpn_data/pki/reqs/MyReq.req
    # key: /opt/Dockovpn_data/pki/private/MyReq.key

    easyrsa sign-req server MyReq << EOF3
yes
EOF3
    # Certificate created at: /opt/Dockovpn_data/pki/issued/MyReq.crt

    openvpn --genkey --secret ta.key << EOF4
yes
EOF4

    easyrsa gen-crl

    touch $LOCKFILE
fi

# Copy server keys and certificates
cp pki/ca.crt pki/issued/MyReq.crt pki/private/MyReq.key pki/crl.pem ta.key /etc/openvpn

cd "$APP_INSTALL_PATH"

# Print app version
$APP_INSTALL_PATH/version.sh

# make the defaults of the cookiecutter.json
echo "$(cat <<eom
{
  "name": "server",
  "port": "${PORT:=1194}",
  "protocol": "${PROTOCOL:=udp}",
  "ip_base": "${IP_BASE:=10.8.0.0}",
  "ip_base_mask": "${IP_BASE_MASK:=255.255.255.0}",
  "dns1": "${DNS1:=208.67.222.222}",
  "dns2": "${DNS2:=208.67.222.220}",
  "client2client": "${CLIENT2CLIENT:=true}"
}
eom
)" > ./config/cookiecutter.json

# This will use the above defaults and not ask for user input
cookiecutter --no-input /opt/Dockovpn/config 

# move the config to where it belongs
mv /opt/Dockovpn/server/server.conf /etc/openvpn/server.conf

# clean up 
rm -rf /opt/Dockovpn/server 

# Need to feed key password
openvpn --config /etc/openvpn/server.conf &

if [[ -n $IS_INITIAL ]]; then
    # By some strange reason we need to do echo command to get to the next command
    echo " "

    # Generate client config
    ./genclient.sh $@
fi


tail -f /dev/null
