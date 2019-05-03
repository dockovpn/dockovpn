#!/usr/bin/env bash

rm -r client

docker run --privileged -it --rm --name uvpn -p 8080:8080 -v $(pwd)/client:/opt/teleport/client alekslitvinenk/openvpn:snapshot