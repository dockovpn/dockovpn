#!/bin/bash

MAJOR_VERSION=0 # Updated manually
MINOR_VERSION=36 # Updated manually
BUILD_NUMBER=0

# Create file build_number.txt if it doesn't exist
#FILE=build_number.txt
#if test ! -f "$FILE"
#then
#    echo 0 > $FILE
#fi

# Increment build number
#BUILD_NUMBER=$(($(cat $FILE)+1)) # Updated automatically
#echo $BUILD_NUMBER > $FILE

FULL_VESRION="v$MAJOR_VERSION.$MINOR_VERSION.$BUILD_NUMBER"

docker build -t alekslitvinenk/openvpn:$FULL_VESRION -t alekslitvinenk/openvpn:latest . --no-cache
docker push alekslitvinenk/openvpn:$FULL_VESRION
docker push alekslitvinenk/openvpn:latest

echo $FULL_VESRION