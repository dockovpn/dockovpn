#!/usr/bin/env bash

rm -r client

docker run --privileged -it --rm --name uvpn -p 1194:1194/udp -p 8080:8080/tcp -v $(pwd)/client:/opt/teleport/client alekslitvinenk/openvpn:snapshot