#!/usr/bin/env bash

rm -r client

docker run --privileged -it --rm --name dovpn -p 1194:1194/udp -p 8080:8080/tcp alekslitvinenk/openvpn