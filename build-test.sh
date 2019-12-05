#!/bin/bash

NEW_UUID=test

docker build -t alekslitvinenk/openvpn:$NEW_UUID . --no-cache
docker push alekslitvinenk/openvpn:$NEW_UUID