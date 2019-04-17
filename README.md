# docker-openvpn
Out of the box openvpn server docker image which you can use anywhere

## To run bare Ubuntu in docker
`docker run -it --rm --name ubuntu-openvpn --mount type=bind,source="$(pwd)"/scripts,target=/opt/teleport  ubuntu:16.04`

## To build docker-openvpn image
`docker build -t alekslitvinenk/openvpn:v0.0.1 .`

## To run docker-openvpn
`docker run -it --rm --name uvpn alekslitvinenk/openvpn:v0.0.1`
