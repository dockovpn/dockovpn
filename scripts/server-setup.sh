#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install openvpn easy-rsa
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

#need to edit vars somehow or copy entire file from somewhere
#nano vars

source vars
./clean-all
./build-ca

./build-key-server server
#need not to create challenging password
#need to answer y(yes) when asked to sign and commit certificate

#Build strong Deffi-Haufman key
./build-dh

