#!/usr/bin/env bash

docker run --privileged -it -p 1194:1194/udp -p 8080:8080/tcp -e HOST_ADDR=localhost alekslitvinenk/openvpn "$@"