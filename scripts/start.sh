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
TUN_PORT=${HOST_TUN_PORT:-1194}
TUN_PROTO="${HOST_TUN_PROTO:-udp}"
IP_NET="${OVPN_IP_NET:-10.8.0.0/24}"

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi

# Allow UDP traffic on port 1194 or set environment variables HOST_TUN_PROTO and HOST_TUN_PORT.
iptables -A INPUT -i $ADAPTER -p $TUN_PROTO -m state --state NEW,ESTABLISHED --dport $TUN_PORT -j ACCEPT
iptables -A OUTPUT -o $ADAPTER -p $TUN_PROTO -m state --state ESTABLISHED --sport $TUN_PORT -j ACCEPT

# Allow traffic on the TUN interface.
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT

# Allow forwarding traffic only from the VPN (set environment variables OVPN_IP_NET).
iptables -A FORWARD -i tun0 -o $ADAPTER -s $IP_NET -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s $IP_NET -o $ADAPTER -j MASQUERADE

cd "$APP_PERSIST_DIR"

LOCKFILE=.gen

# Regenerate certs only on the first start 
if [ ! -f $LOCKFILE ]; then
    IS_INITIAL="1"

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

    easyrsa gen-crl

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
    tail -f /dev/null
fi
