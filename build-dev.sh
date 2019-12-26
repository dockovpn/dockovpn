#!/bin/bash

docker build -t alekslitvinenk/openvpn:dev . --no-cache
docker push alekslitvinenk/openvpn:dev