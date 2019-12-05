#!/bin/bash

NEW_UUID=latest

docker build -t alekslitvinenk/openvpn:$NEW_UUID . --no-cache