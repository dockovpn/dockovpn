#!/bin/bash
source ./functions.sh

SHORT=rnqs
LONG="regenerate,noop,quit,skip"
OPTS=$(getopt -a -n dockovpn --options $SHORT --longoptions $LONG -- "$@")

if [[ $? -ne 0 ]] ; then
    exit 1
fi

eval set -- "$OPTS"

while :
do
  case "$1" in
    -r | --regenerate)
      REGENERATE="1"
      shift;
      ;;
    -n | --noop)
      NOOP="1"
      shift;
      ;;
    -q | --quit)
      QUIT="1"
      shift;
      ;;
    -s | --skip)
      SKIP="1"
      shift;
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      exit 1
      ;;
  esac
done

ADAPTER="${NET_ADAPTER:=eth0}"

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi

# Replace variables in ovpn config file
sed -i 's/%HOST_TUN_PROTOCOL%/'"$HOST_TUN_PROTOCOL"'/g' /etc/openvpn/server.conf

# Allow ${HOST_TUN_PROTOCOL} traffic on port 1194.
iptables -A INPUT -i $ADAPTER -p ${HOST_TUN_PROTOCOL} -m state --state NEW,ESTABLISHED --dport 1194 -j ACCEPT
iptables -A OUTPUT -o $ADAPTER -p ${HOST_TUN_PROTOCOL} -m state --state ESTABLISHED --sport 1194 -j ACCEPT

# Allow traffic on the TUN interface.
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i tun0 -o $ADAPTER -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $ADAPTER -j MASQUERADE

cd "$APP_PERSIST_DIR"

LOCKFILE=.gen

# Regenerate certs only on the first start
if [ ! -f $LOCKFILE ]; then
    IS_INITIAL="1"
    test -d pki || REGENERATE="1"
    if [[ -n $REGENERATE ]]; then
        easyrsa --batch init-pki
        easyrsa --batch gen-dh
        # DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem
        # Copy DH file
        cp pki/dh.pem /etc/openvpn
    fi

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

    easyrsa --days=$CRL_DAYS gen-crl

    touch $LOCKFILE
fi

# Copy server keys and certificates
cp pki/dh.pem pki/ca.crt pki/issued/MyReq.crt pki/private/MyReq.key pki/crl.pem ta.key /etc/openvpn

cd "$APP_INSTALL_PATH"

# Print app version
getVersionFull

if ! [[ -n $NOOP ]]; then
    # Need to feed key password
    openvpn --config /etc/openvpn/server.conf &

    if [[ -n $IS_INITIAL ]]; then
        # By some strange reason we need to do echo command to get to the next command
        echo " "

        if ! [[ -n $SKIP ]]; then
          # Generate client config
          generateClientConfig $@ &
        else
          echo "$(datef) SKIP is set: skipping client generation"
        fi
    else
      echo "$(datef) Data exist: skipping client generation"
    fi
fi

if ! [[ -n $QUIT ]]; then
    # Sleep required to avoid race conditions
    sleep 5 && tail -f /opt/Dockovpn/openvpn.log
fi
