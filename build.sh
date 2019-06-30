#!/bin/bash

rm -r client

# bash generate random 10 character alphanumeric string (upper and lowercase) and 
# NEW_UUID=$(env LC_CTYPE=C tr -dc "a-zA-Z0-9" < /dev/urandom | head -c 10 | cat)
NEW_UUID=latest

docker build -t alekslitvinenk/openvpn:$NEW_UUID --no-cache .
docker push alekslitvinenk/openvpn:$NEW_UUID